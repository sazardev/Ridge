package ui

import (
	"strings"

	"github.com/charmbracelet/bubbles/help"
	"github.com/charmbracelet/bubbles/textinput"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/omar/ridge/tui/internal/store"
)

func init() {
	addStrings(map[string][2]string{
		"ob.skip":      {"skip", "omitir"},
		"ob.next":      {"next", "siguiente"},
		"ob.start":     {"Get started", "Empezar"},
		"ob.welcome":   {"Real code, not filler", "Código real, no relleno"},
		"ob.welcome.d": {"Train your typing with real Go snippets — the syntax you actually write at work, not random sentences.", "Entrena tu tecleo con snippets reales de Go — la sintaxis que escribes en el trabajo, no frases al azar."},
		"ob.metrics":   {"Know exactly what slows you down", "Sabe exactamente qué te frena"},
		"ob.metrics.d": {"Speed, accuracy, per-finger and per-character — every session shows you what to improve, and why.", "Velocidad, precisión, por dedo y por carácter — cada sesión te muestra qué mejorar y por qué."},
		"ob.paths":     {"Progress at your own pace", "Avanza a tu ritmo"},
		"ob.paths.d":   {"Guided learning paths, XP, and achievements — fully offline, whenever you want.", "Rutas guiadas, XP y logros — totalmente sin conexión, cuando quieras."},
		"ob.look":      {"Make it yours", "Hazlo tuyo"},
		"ob.look.d":    {"Pick a palette and color mode — you can always change this later in Settings.", "Elige una paleta y un modo de color — puedes cambiarlo luego en Ajustes."},
		"ob.look.keys": {"← → palette   t color mode", "← → paleta   t modo de color"},
		"ob.device":    {"We already know your setup", "Ya conocemos tu equipo"},
		"ob.device.d":  {"We detected your platform and device automatically — nothing to configure.", "Detectamos tu plataforma y dispositivo automáticamente — nada que configurar."},
		"ob.ready":     {"No friction, ever", "Sin fricción, nunca"},
		"ob.ready.d":   {"Just a username — no email, no password. Let's start typing.", "Solo un nombre de usuario — sin correo ni contraseña. Empecemos a teclear."},
		"ob.username":  {"Choose a username", "Elige un nombre de usuario"},
	})
}

// onboardingScreen is the first-run flow: welcome → metrics → paths →
// appearance → device → username. Text fades in on every page.
type onboardingScreen struct {
	ctx   *Ctx
	page  int
	input textinput.Model
	err   string
}

const obPages = 6

func newOnboarding(c *Ctx) *onboardingScreen {
	ti := textinput.New()
	ti.Prompt = ""
	ti.Placeholder = "ada"
	ti.CharLimit = store.MaxUsernameLength
	ti.PlaceholderStyle = c.S.Muted
	ti.TextStyle = c.S.Body
	o := &onboardingScreen{ctx: c, input: ti}
	o.enter()
	return o
}

func (o *onboardingScreen) enter() {
	o.ctx.Anim.Set("ob.fade", 0)
	o.ctx.Anim.To("ob.fade", 1, 8, 1)
	if o.page == obPages-1 {
		o.input.Focus()
	} else {
		o.input.Blur()
	}
}

func (o *onboardingScreen) Init() tea.Cmd { return textinput.Blink }

func (o *onboardingScreen) Update(msg tea.Msg) (Screen, tea.Cmd) {
	c := o.ctx
	k, ok := msg.(tea.KeyMsg)
	if !ok {
		return o, nil
	}
	last := o.page == obPages-1
	if o.page == 3 && (k.String() == "right" || k.String() == "left") {
		if k.String() == "right" {
			o.cyclePalette(1)
		} else {
			o.cyclePalette(-1)
		}
		return o, func() tea.Msg { return themeMsg{} }
	}
	switch k.String() {
	case "ctrl+c":
		return o, tea.Quit
	case "esc":
		if o.page > 0 {
			o.page--
			o.enter()
		}
		return o, nil
	case "enter", "right", "l":
		if last {
			if k.String() == "enter" {
				return o, o.finish()
			}
			break
		}
		o.page++
		o.enter()
		return o, nil
	case "left", "h":
		if !last && o.page > 0 {
			o.page--
			o.enter()
		}
		return o, nil
	}
	if o.page == 3 {
		switch k.String() {
		case "t":
			c.Set.ThemeMode = map[string]string{"system": "light", "light": "dark", "dark": "system"}[c.Set.ThemeMode]
			c.SaveSettings()
			return o, func() tea.Msg { return themeMsg{} }
		}
	}
	if last {
		var cmd tea.Cmd
		o.input, cmd = o.input.Update(msg)
		o.err = ""
		return o, cmd
	}
	return o, nil
}

// clickBody advances the tour; the final page is a text field, so a click
// there does not submit an empty username.
func (o *onboardingScreen) clickBody(_, _ int) (tea.Cmd, bool) {
	if o.page >= obPages-1 {
		return nil, true
	}
	o.page++
	o.enter()
	return nil, true
}

func (o *onboardingScreen) finish() tea.Cmd {
	c := o.ctx
	name := strings.TrimSpace(o.input.Value())
	if name == "" {
		o.err = c.T("err.required")
		return nil
	}
	if len([]rune(name)) > store.MaxUsernameLength {
		o.err = c.T("err.username.len")
		return nil
	}
	pr := c.DB.LoadProfile()
	pr.Username = name
	pr.Platform, pr.OSVersion, pr.Device = DetectDevice()
	_ = c.DB.SaveProfile(pr)
	c.Set.OnboardingDone = true
	c.SaveSettings()
	return goHome()
}

// Palette cycling on the appearance page uses the arrow keys, handled here so
// the menu-less page stays simple.
func (o *onboardingScreen) cyclePalette(d int) {
	c := o.ctx
	cur := 0
	for i, id := range PaletteIDs {
		if id == c.Set.Palette {
			cur = i
		}
	}
	c.Set.Palette = PaletteIDs[(cur+d+len(PaletteIDs))%len(PaletteIDs)]
	c.SaveSettings()
}

func (o *onboardingScreen) View() string {
	c, s := o.ctx, o.ctx.S
	f := c.Anim.V("ob.fade")
	fade := fgStyle(c.Theme.Mix(RoleMuted, RoleFg, f))
	titles := [][2]string{{"ob.welcome", "ob.welcome.d"}, {"ob.metrics", "ob.metrics.d"}, {"ob.paths", "ob.paths.d"},
		{"ob.look", "ob.look.d"}, {"ob.device", "ob.device.d"}, {"ob.ready", "ob.ready.d"}}
	t := titles[o.page]
	var dots []string
	for i := 0; i < obPages; i++ {
		if i == o.page {
			dots = append(dots, s.Accent.Render("●"))
		} else {
			dots = append(dots, s.Muted.Render("○"))
		}
	}
	w := min(contentWidth(c), 64)
	body := []string{c.Theme.shimmerText(c.T(t[0]), RolePrimary, RoleSecondary, -1, true), "",
		lipgloss.NewStyle().Width(w).Render(fade.Render(c.T(t[1]))), ""}
	switch o.page {
	case 3:
		body = append(body, swatch(c, c.Set.Palette)+"  "+s.Accent.Render(c.Set.Palette), s.Muted.Render(c.T("ob.look.keys")))
	case 4:
		pl, osv, dev := DetectDevice()
		for _, v := range []string{pl, osv, dev} {
			if v != "" {
				body = append(body, s.Badge.Render(v))
			}
		}
	case 5:
		body = append(body, s.Title.Render(c.T("ob.username")), s.Marker.Render(c.G.Marker+" ")+o.input.View())
		if o.err != "" {
			body = append(body, s.Error.Render(c.G.Cross+" "+o.err))
		}
	}
	body = append(body, "", strings.Join(dots, " "))
	return lipgloss.Place(contentWidth(c), max(10, c.H-8), lipgloss.Center, lipgloss.Center, lipgloss.JoinVertical(lipgloss.Left, body...))
}

func (o *onboardingScreen) Help() help.KeyMap {
	if o.page == obPages-1 {
		return bindings{short: kbs(kb("enter", "enter", "get started"), kb("esc", "esc", "back"))}
	}
	return bindings{short: kbs(kb("enter|right", "→/enter", "next"), kb("left|esc", "←/esc", "back"), kb("ctrl+c", "ctrl+c", "quit"))}
}
