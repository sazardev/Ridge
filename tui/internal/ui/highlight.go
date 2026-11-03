package ui

import (
	"strings"
	"unicode"

	"github.com/charmbracelet/lipgloss"
)

// A language-agnostic syntax highlighter: comments, strings, numbers,
// keywords and calls, colored from theme roles. It is not a parser — it only
// has to make code pleasant to read on any terminal theme. Characters are
// classified once; typed text takes its class color, untyped text stays gray.

type tokClass uint8

const (
	clsPlain tokClass = iota
	clsPunct
	clsKeyword
	clsString
	clsNumber
	clsCall
	clsComment
)

var keywords = func() map[string]bool {
	m := map[string]bool{}
	for _, k := range strings.Fields(`
	func function def fn fun lambda class struct interface enum trait impl type typedef union namespace module package import from export use using
	return yield await async go defer chan select case switch default break continue goto fallthrough
	if else elif unless for foreach while do loop in range match when try catch except finally throw throws raise
	var let const val mut static final public private protected internal abstract override virtual extern inline
	new delete this self super nil null None true false True False void int uint string bool byte rune float double char long short
	and or not is as with pass del global where then end begin SELECT FROM WHERE JOIN INSERT UPDATE DELETE CREATE TABLE ORDER BY GROUP LIMIT`) {
		m[k] = true
	}
	return m
}()

func lineComment(lang string) string {
	switch lang {
	case "python", "bash", "linux", "git", "githubActions", "docker", "crystal", "dockerfile":
		return "#"
	case "sql", "haskell":
		return "--"
	}
	return "//"
}

// classify returns one class per rune of code.
func classify(code, lang string) []tokClass {
	cm := []rune(lineComment(lang))
	rs := []rune(code)
	out := make([]tokClass, len(rs))
	hasPrefix := func(i int, p []rune) bool {
		if i+len(p) > len(rs) {
			return false
		}
		for k, r := range p {
			if rs[i+k] != r {
				return false
			}
		}
		return true
	}
	isWord := func(r rune) bool { return unicode.IsLetter(r) || unicode.IsDigit(r) || r == '_' }
	for i := 0; i < len(rs); {
		r := rs[i]
		switch {
		case hasPrefix(i, cm):
			for ; i < len(rs) && rs[i] != '\n'; i++ {
				out[i] = clsComment
			}
		case r == '"' || r == '\'' || r == '`':
			j := i + 1
			for j < len(rs) && rs[j] != r {
				if rs[j] == '\\' {
					j++
				}
				j++
			}
			j = min(j+1, len(rs))
			for k := i; k < j; k++ {
				out[k] = clsString
			}
			i = j
		case unicode.IsDigit(r):
			j := i
			for j < len(rs) && (unicode.IsDigit(rs[j]) || rs[j] == '.' || rs[j] == '_' || rs[j] == 'x') {
				j++
			}
			for k := i; k < j; k++ {
				out[k] = clsNumber
			}
			i = j
		case unicode.IsLetter(r) || r == '_':
			j := i
			for j < len(rs) && isWord(rs[j]) {
				j++
			}
			cls := clsPlain
			switch w := string(rs[i:j]); {
			case keywords[w]:
				cls = clsKeyword
			case j < len(rs) && rs[j] == '(':
				cls = clsCall
			}
			for k := i; k < j; k++ {
				out[k] = cls
			}
			i = j
		case r == '\n' || r == ' ' || r == '\t':
			i++
		default:
			out[i] = clsPunct
			i++
		}
	}
	return out
}

// classStyle is the theme style of a token class. Colors are the terminal's own
// (ANSI) so highlighting follows whatever theme the user runs, light or dark.
func (c *Ctx) classStyle(k tokClass) lipgloss.Style {
	switch k {
	case clsKeyword:
		return c.S.Accent.Bold(false)
	case clsString:
		return c.S.Success
	case clsNumber:
		return c.S.Warning
	case clsCall:
		return c.S.Title.Bold(false)
	case clsComment:
		return c.S.Muted.Italic(true)
	case clsPunct:
		return c.S.Body
	}
	return c.S.Body
}

// highlight colors code for the active theme.
func (c *Ctx) highlight(code, lang string) string {
	rs := []rune(code)
	cls := classify(code, lang)
	var b strings.Builder
	for i := 0; i < len(rs); {
		j := i
		for j < len(rs) && cls[j] == cls[i] && rs[j] != '\n' {
			j++
		}
		if j == i { // a newline
			b.WriteRune(rs[i])
			i++
			continue
		}
		b.WriteString(c.classStyle(cls[i]).Render(string(rs[i:j])))
		i = j
	}
	return b.String()
}
