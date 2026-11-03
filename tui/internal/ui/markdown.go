package ui

import (
	"strings"
	"unicode/utf8"

	"github.com/charmbracelet/lipgloss"
)

// A small, theme-aware Markdown renderer for the snippet explanations:
// `inline code` (accent color, no backticks), **bold**, paragraphs wrapped to a
// readable measure, "- " lists with hanging indent, "# " headings and fenced
// code blocks (syntax highlighted). Everything takes its colors from the
// theme, so it follows the terminal like the rest of the app.

type spanKind int

const (
	spanText spanKind = iota
	spanCode
	spanBold
)

type span struct {
	text string
	kind spanKind
}

// parseInline splits a line into plain / code / bold spans.
func parseInline(s string) []span {
	var out []span
	var cur strings.Builder
	flush := func() {
		if cur.Len() > 0 {
			out = append(out, span{cur.String(), spanText})
			cur.Reset()
		}
	}
	for i := 0; i < len(s); {
		switch {
		case s[i] == '`':
			if j := strings.IndexByte(s[i+1:], '`'); j >= 0 {
				flush()
				out = append(out, span{s[i+1 : i+1+j], spanCode})
				i += j + 2
				continue
			}
		case strings.HasPrefix(s[i:], "**"):
			if j := strings.Index(s[i+2:], "**"); j > 0 {
				flush()
				out = append(out, span{s[i+2 : i+2+j], spanBold})
				i += j + 4
				continue
			}
		}
		cur.WriteByte(s[i])
		i++
	}
	flush()
	return out
}

// plainText strips markdown markers (for contexts that cannot be styled).
func plainText(s string) string {
	var b strings.Builder
	for _, sp := range parseInline(s) {
		b.WriteString(sp.text)
	}
	return b.String()
}

func (c *Ctx) spanStyle(k spanKind) lipgloss.Style {
	switch k {
	case spanCode:
		return c.S.Accent.Bold(false)
	case spanBold:
		return c.S.Body.Bold(true)
	}
	return c.S.Body
}

// inline renders one line with styled spans, no wrapping.
func (c *Ctx) inline(s string, base lipgloss.Style) string {
	var b strings.Builder
	for _, sp := range parseInline(s) {
		st := base
		if sp.kind == spanCode {
			st = c.S.Accent.Bold(false)
		} else if sp.kind == spanBold {
			st = base.Bold(true)
		}
		b.WriteString(st.Render(sp.text))
	}
	return b.String()
}

type token struct {
	text string
	kind spanKind
	glue bool // no space before it: punctuation hugging the previous word or code span
}

// tokens breaks spans into unbreakable words; a code span stays in one piece.
// A token that directly follows the previous one with no space (a comma after
// a code span, a code span inside parentheses) is marked glued.
func tokens(spans []span) []token {
	var out []token
	prevOpen := false // previous span ended without whitespace
	for _, sp := range spans {
		if sp.kind == spanCode {
			out = append(out, token{sp.text, spanCode, prevOpen && len(out) > 0})
			prevOpen = true
			continue
		}
		startsSpace := sp.text != "" && (sp.text[0] == ' ' || sp.text[0] == '\n')
		for i, w := range strings.Fields(sp.text) {
			out = append(out, token{w, sp.kind, i == 0 && !startsSpace && prevOpen && len(out) > 0})
		}
		prevOpen = sp.text != "" && !strings.HasSuffix(sp.text, " ")
	}
	return out
}

// wrapSpans greedy-wraps tokens to width, joining with single spaces. Prefix
// is repeated on continuation lines (hanging indent).
func (c *Ctx) wrapSpans(spans []span, width int, first, rest string) []string {
	var lines []string
	cur := first
	curW := utf8.RuneCountInString(first)
	empty := true
	toks := tokens(spans)
	for i, t := range toks {
		w := utf8.RuneCountInString(t.text)
		if t.glue && !empty {
			cur += c.spanStyle(t.kind).Render(t.text)
			curW += w
			continue
		}
		// Keep a word together with any punctuation glued after it.
		for j := i + 1; j < len(toks) && toks[j].glue; j++ {
			w += utf8.RuneCountInString(toks[j].text)
		}
		if !empty && curW+1+w > width {
			lines = append(lines, cur)
			cur, curW, empty = rest, utf8.RuneCountInString(rest), true
		}
		if !empty {
			cur += " "
			curW++
		}
		cur += c.spanStyle(t.kind).Render(t.text)
		curW += w
		empty = false
	}
	return append(lines, cur)
}

// renderMarkdown renders blocks at the given maximum measure.
func (c *Ctx) renderMarkdown(src, lang string, width int) string {
	width = max(20, min(width, 76)) // ≤ 80 characters per line reads best
	var out []string
	var para []string
	var code []string
	inCode := false
	flushPara := func() {
		if len(para) == 0 {
			return
		}
		out = append(out, c.wrapSpans(parseInline(strings.Join(para, " ")), width, "", "")...)
		out = append(out, "")
		para = nil
	}
	for _, raw := range strings.Split(src, "\n") {
		line := strings.TrimRight(raw, " \t")
		trim := strings.TrimSpace(line)
		switch {
		case strings.HasPrefix(trim, "```"):
			if inCode {
				out = append(out, c.codeBlock(strings.Join(code, "\n"), lang)...)
				out = append(out, "")
				code, inCode = nil, false
			} else {
				flushPara()
				inCode = true
			}
		case inCode:
			code = append(code, raw)
		case trim == "":
			flushPara()
		case strings.HasPrefix(trim, "#"):
			flushPara()
			out = append(out, c.S.Title.Render(strings.TrimSpace(strings.TrimLeft(trim, "#"))), "")
		case strings.HasPrefix(trim, "- ") || strings.HasPrefix(trim, "* "):
			flushPara()
			bullet := c.S.Muted.Render(c.G.Dot + " ")
			out = append(out, c.wrapSpans(parseInline(trim[2:]), width, bullet, "  ")...)
		default:
			para = append(para, trim)
		}
	}
	flushPara()
	if inCode {
		out = append(out, c.codeBlock(strings.Join(code, "\n"), lang)...)
	}
	for len(out) > 0 && out[len(out)-1] == "" {
		out = out[:len(out)-1]
	}
	return strings.Join(out, "\n")
}

// codeBlock indents highlighted code by two cells.
func (c *Ctx) codeBlock(code, lang string) []string {
	var out []string
	for _, ln := range strings.Split(c.highlight(code, lang), "\n") {
		out = append(out, "  "+ln)
	}
	return out
}
