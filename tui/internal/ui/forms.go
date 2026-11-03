package ui

import (
	"strings"

	"github.com/charmbracelet/bubbles/help"
	"github.com/charmbracelet/bubbles/textinput"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

func init() {
	addStrings(map[string][2]string{
		"form.save":    {"save", "guardar"},
		"form.cancel":  {"cancel", "cancelar"},
		"confirm.yes":  {"yes", "sí"},
		"confirm.no":   {"no", "no"},
		"confirm.q":    {"Are you sure?", "¿Seguro?"},
		"err.required": {"This field is required.", "Este campo es obligatorio."},
	})
}

type formField struct {
	Label, Placeholder string
	Value              string
	Max                int
	Required           bool
	Validate           func(string) string // returns an error message, "" when valid
	ti                 textinput.Model
	err                string
}

// formScreen is a small inline-validated form: one field focused at a time,
// placeholder in muted, focused prompt in primary, errors in danger with how to fix them.
type formScreen struct {
	ctx      *Ctx
	title    string
	fields   []*formField
	focus    int
	onSubmit func(vals []string) string
	err      string
}

func newForm(c *Ctx, title string, fields []*formField, onSubmit func(vals []string) string) *formScreen {
	f := &formScreen{ctx: c, title: title, fields: fields, onSubmit: onSubmit}
	for _, fl := range fields {
		ti := textinput.New()
		ti.Prompt = ""
		ti.Placeholder = fl.Placeholder
		ti.SetValue(fl.Value)
		ti.CharLimit = fl.Max
		ti.PlaceholderStyle = c.S.Muted
		ti.TextStyle = c.S.Body
		fl.ti = ti
	}
	f.setFocus(0)
	return f
}

func (f *formScreen) setFocus(i int) {
	f.focus = (i + len(f.fields)) % len(f.fields)
	for j, fl := range f.fields {
		if j == f.focus {
			fl.ti.Focus()
		} else {
			fl.ti.Blur()
		}
	}
}

func (f *formScreen) Title() string { return f.title }
func (f *formScreen) Init() tea.Cmd { return textinput.Blink }

func (f *formScreen) validate() bool {
	ok := true
	for _, fl := range f.fields {
		v := strings.TrimSpace(fl.ti.Value())
		fl.err = ""
		switch {
		case fl.Required && v == "":
			fl.err = f.ctx.T("err.required")
		case fl.Validate != nil:
			fl.err = fl.Validate(v)
		}
		if fl.err != "" {
			ok = false
		}
	}
	return ok
}

func (f *formScreen) submit() tea.Cmd {
	if !f.validate() {
		return nil
	}
	vals := make([]string, len(f.fields))
	for i, fl := range f.fields {
		vals[i] = strings.TrimSpace(fl.ti.Value())
	}
	if msg := f.onSubmit(vals); msg != "" {
		f.err = msg
		return nil
	}
	return pop()
}

func (f *formScreen) Update(msg tea.Msg) (Screen, tea.Cmd) {
	if k, ok := msg.(tea.KeyMsg); ok {
		switch k.String() {
		case "esc":
			return f, pop()
		case "ctrl+s":
			return f, f.submit()
		case "tab", "down":
			f.setFocus(f.focus + 1)
			return f, nil
		case "shift+tab", "up":
			f.setFocus(f.focus - 1)
			return f, nil
		case "enter":
			if f.focus == len(f.fields)-1 {
				return f, f.submit()
			}
			f.setFocus(f.focus + 1)
			return f, nil
		}
	}
	var cmd tea.Cmd
	fl := f.fields[f.focus]
	fl.ti, cmd = fl.ti.Update(msg)
	return f, cmd
}

func (f *formScreen) View() string {
	s := f.ctx.S
	w := contentWidth(f.ctx)
	var rows []string
	for i, fl := range f.fields {
		label := s.Muted.Render(fl.Label)
		prompt := s.Muted.Render("  ")
		if i == f.focus {
			label = s.Title.Render(fl.Label)
			prompt = s.Marker.Render(f.ctx.G.Marker + " ")
		}
		rows = append(rows, label, prompt+fl.ti.View())
		if fl.err != "" {
			rows = append(rows, s.Error.Render("  "+f.ctx.G.Cross+" "+fl.err))
		}
		rows = append(rows, "")
	}
	if f.err != "" {
		rows = append(rows, s.Error.Render(f.ctx.G.Cross+" "+f.err))
	}
	return lipgloss.NewStyle().Width(w).Render(strings.Join(rows, "\n"))
}

func (f *formScreen) Help() help.KeyMap {
	return bindings{short: kbs(kb("tab", "tab", "next"), kb("ctrl+s|enter", "ctrl+s", "save"), kb("esc", "esc", "cancel"))}
}

// confirmScreen is a centered double-border dialog; destructive actions always ask.
type confirmScreen struct {
	ctx *Ctx
	msg string
	yes func()
}

func newConfirm(c *Ctx, msg string, yes func()) *confirmScreen { return &confirmScreen{c, msg, yes} }

func (d *confirmScreen) Init() tea.Cmd { return nil }

func (d *confirmScreen) Update(msg tea.Msg) (Screen, tea.Cmd) {
	if k, ok := msg.(tea.KeyMsg); ok {
		switch k.String() {
		case "y", "Y", "s", "S":
			d.yes()
			return d, pop()
		case "n", "N", "esc", "enter", "q":
			return d, pop()
		}
	}
	return d, nil
}

func (d *confirmScreen) View() string {
	c, s := d.ctx, d.ctx.S
	body := s.Warning.Render(c.T("confirm.q")) + "\n\n" + s.Body.Render(d.msg) + "\n\n" +
		s.Key.Render("y") + s.Muted.Render(" "+c.T("confirm.yes")+"   ") + s.Key.Render("n") + s.Muted.Render(" "+c.T("confirm.no"))
	return lipgloss.Place(contentWidth(c), max(6, c.H-8), lipgloss.Center, lipgloss.Center, s.Dialog.Render(body))
}

func (d *confirmScreen) Help() help.KeyMap {
	return bindings{short: kbs(kb("y", "y", "confirm"), kb("n|esc", "n", "cancel"))}
}

// multiSelect is a checkbox list (favorite languages).
type multiSelect struct {
	ctx   *Ctx
	title string
	opts  []string
	label func(string) string
	on    map[string]bool
	m     *menu
	save  func([]string)
}

func newMultiSelect(c *Ctx, title string, opts []string, label func(string) string, current []string, save func([]string)) *multiSelect {
	ms := &multiSelect{ctx: c, title: title, opts: opts, label: label, on: map[string]bool{}, save: save}
	for _, v := range current {
		ms.on[v] = true
	}
	ms.m = newMenu(c, "multi."+title, ms.items())
	ms.m.filterable = true
	return ms
}

func (ms *multiSelect) items() []item {
	var out []item
	for _, o := range ms.opts {
		mark := ms.ctx.S.Muted.Render("[ ]")
		if ms.on[o] {
			mark = ms.ctx.S.Success.Render("[" + ms.ctx.G.Check + "]")
		}
		out = append(out, item{Label: ms.label(o), Badge: mark, Value: o})
	}
	return out
}

func (ms *multiSelect) Title() string { return ms.title }
func (ms *multiSelect) Init() tea.Cmd { return nil }

func (ms *multiSelect) Update(msg tea.Msg) (Screen, tea.Cmd) {
	k, ok := msg.(tea.KeyMsg)
	if !ok {
		return ms, nil
	}
	if ms.m.handleFilter(k.String(), k.Runes) {
		return ms, nil
	}
	switch k.String() {
	case "up", "k":
		ms.m.move(-1)
	case "down", "j":
		ms.m.move(1)
	case " ", "x":
		if it, ok := ms.m.selected(); ok {
			v := it.Value.(string)
			ms.on[v] = !ms.on[v]
			ms.m.items = ms.items()
		}
	case "enter":
		var out []string
		for _, o := range ms.opts {
			if ms.on[o] {
				out = append(out, o)
			}
		}
		ms.save(out)
		return ms, pop()
	case "esc", "q":
		return ms, pop()
	}
	return ms, nil
}

func (ms *multiSelect) View() string { return ms.m.view(contentWidth(ms.ctx), ms.ctx.H-10) }

func (ms *multiSelect) Help() help.KeyMap {
	return bindings{short: kbs(kb("space", "space", "toggle"), kb("/", "/", "filter"), kb("enter", "enter", "save"), kb("esc", "esc", "cancel"))}
}

// spark renders values as a one-line sparkline (▁▂▃▄▅▆▇█).
func spark(vals []float64) string {
	if len(vals) == 0 {
		return ""
	}
	r := []rune("▁▂▃▄▅▆▇█")
	lo, hi := vals[0], vals[0]
	for _, v := range vals {
		lo, hi = min(lo, v), max(hi, v)
	}
	var b strings.Builder
	for _, v := range vals {
		i := 0
		if hi > lo {
			i = int((v - lo) / (hi - lo) * float64(len(r)-1))
		}
		b.WriteRune(r[i])
	}
	return b.String()
}
