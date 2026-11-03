package ui

import (
	"fmt"
	"os"
	"runtime"
	"strings"

	"github.com/charmbracelet/bubbles/help"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	"github.com/omar/ridge/tui/internal/store"
	"github.com/omar/ridge/tui/internal/typing"
)

func init() {
	addStrings(map[string][2]string{
		"prof.title":       {"Profile", "Perfil"},
		"prof.guest":       {"Guest · offline", "Invitado · sin conexión"},
		"prof.edit":        {"Edit profile", "Editar perfil"},
		"prof.kb":          {"Keyboard setup", "Configuración de teclado"},
		"prof.langs":       {"Favorite languages", "Lenguajes favoritos"},
		"prof.username":    {"Username", "Nombre de usuario"},
		"prof.quote":       {"Favorite quote", "Cita favorita"},
		"prof.programmer":  {"Favorite programmer", "Programador favorito"},
		"prof.github":      {"GitHub username", "Usuario de GitHub"},
		"prof.website":     {"Website", "Sitio web"},
		"prof.layout":      {"Keyboard layout", "Distribución de teclado"},
		"prof.brand":       {"Keyboard brand", "Marca del teclado"},
		"prof.model":       {"Keyboard model", "Modelo del teclado"},
		"prof.device":      {"Device", "Dispositivo"},
		"prof.layouts":     {"qwerty, azerty, qwertz, dvorak, colemak, workman, other", "qwerty, azerty, qwertz, dvorak, colemak, workman, other"},
		"err.username.len": {"Username must be 24 characters or fewer.", "El nombre debe tener 24 caracteres o menos."},
		"err.layout":       {"Use one of: qwerty, azerty, qwertz, dvorak, colemak, workman, other.", "Usa una de: qwerty, azerty, qwertz, dvorak, colemak, workman, other."},
		"err.url":          {"Use a full URL starting with http:// or https://.", "Usa una URL completa que empiece con http:// o https://."},
		"prof.noaccount":   {"Accounts need a Firebase client, which Linux lacks — this install stays a Guest, offline profile.", "Las cuentas requieren un cliente Firebase, que Linux no tiene — esta instalación sigue como perfil Invitado sin conexión."},
	})
}

var favoriteLanguages = []string{"go", "python", "javascript", "typescript", "rust", "c", "cpp", "csharp", "java", "kotlin",
	"swift", "ruby", "php", "dart", "lua", "haskell", "scala", "elixir", "clojure", "perl", "r", "objectiveC", "shell", "sql",
	"assembly", "zig", "nim", "julia", "groovy", "fsharp", "ocaml", "erlang", "crystal", "solidity", "powershell", "lisp",
	"prolog", "cobol", "fortran", "matlab", "other"}

var favLangNames = map[string]string{"cpp": "C++", "csharp": "C#", "fsharp": "F#", "objectiveC": "Objective-C", "ocaml": "OCaml",
	"php": "PHP", "sql": "SQL", "javascript": "JavaScript", "typescript": "TypeScript", "powershell": "PowerShell", "cobol": "COBOL"}

func favName(id string) string {
	if n, ok := favLangNames[id]; ok {
		return n
	}
	if n := langName(id); n != id {
		return n
	}
	return strings.ToUpper(id[:1]) + id[1:]
}

var keyboardLayouts = []string{"qwerty", "azerty", "qwertz", "dvorak", "colemak", "workman", "other"}

// DetectDevice reads platform, OS and device model from the host
// (EnsureDeviceInfoUseCase); nothing to configure by hand.
func DetectDevice() (platform, osVersion, device string) {
	platform = runtime.GOOS + "/" + runtime.GOARCH
	if b, err := os.ReadFile("/etc/os-release"); err == nil {
		for _, ln := range strings.Split(string(b), "\n") {
			if strings.HasPrefix(ln, "PRETTY_NAME=") {
				osVersion = strings.Trim(strings.TrimPrefix(ln, "PRETTY_NAME="), `"`)
			}
		}
	}
	if osVersion == "" {
		osVersion = runtime.GOOS
	}
	for _, p := range []string{"/sys/devices/virtual/dmi/id/product_name", "/sys/firmware/devicetree/base/model"} {
		if b, err := os.ReadFile(p); err == nil {
			device = strings.Trim(strings.TrimSpace(string(b)), "\x00")
			break
		}
	}
	if device == "" {
		device, _ = os.Hostname()
	}
	return
}

type profileScreen struct{ ctx *Ctx }

func newProfile(c *Ctx) *profileScreen {
	p := c.DB.LoadProfile()
	if p.Platform == "" {
		p.Platform, p.OSVersion, p.Device = DetectDevice()
		_ = c.DB.SaveProfile(p)
	}
	return &profileScreen{c}
}

func (p *profileScreen) Title() string { return p.ctx.T("prof.title") }
func (p *profileScreen) Init() tea.Cmd { return nil }

func (p *profileScreen) Update(msg tea.Msg) (Screen, tea.Cmd) {
	k, ok := msg.(tea.KeyMsg)
	if !ok {
		return p, nil
	}
	c := p.ctx
	switch k.String() {
	case "esc", "q":
		return p, pop()
	case "e":
		return p, push(p.editForm())
	case "b":
		return p, push(p.keyboardForm())
	case "l":
		pr := c.DB.LoadProfile()
		return p, push(newMultiSelect(c, c.T("prof.langs"), favoriteLanguages, favName, pr.FavoriteLanguages, func(sel []string) {
			pr.FavoriteLanguages = sel
			_ = c.DB.SaveProfile(pr)
		}))
	}
	return p, nil
}

func validURL(s string) string {
	if s == "" || strings.HasPrefix(s, "http://") || strings.HasPrefix(s, "https://") {
		return ""
	}
	return "err.url"
}

func (p *profileScreen) editForm() Screen {
	c := p.ctx
	pr := c.DB.LoadProfile()
	return newForm(c, c.T("prof.edit"), []*formField{
		{Label: c.T("prof.username"), Value: pr.Username, Max: store.MaxUsernameLength, Required: true},
		{Label: c.T("prof.quote"), Value: pr.Quote, Max: 160},
		{Label: c.T("prof.programmer"), Value: pr.Programmer, Max: 60},
		{Label: c.T("prof.github"), Value: pr.Github, Max: 39},
		{Label: c.T("prof.website"), Value: pr.Website, Max: 120, Validate: func(v string) string {
			if e := validURL(v); e != "" {
				return c.T(e)
			}
			return ""
		}},
	}, func(v []string) string {
		pr.Username, pr.Quote, pr.Programmer, pr.Github, pr.Website = v[0], v[1], v[2], v[3], v[4]
		if err := c.DB.SaveProfile(pr); err != nil {
			return err.Error()
		}
		return ""
	})
}

func (p *profileScreen) keyboardForm() Screen {
	c := p.ctx
	pr := c.DB.LoadProfile()
	return newForm(c, c.T("prof.kb"), []*formField{
		{Label: c.T("prof.layout") + " (" + c.T("prof.layouts") + ")", Value: pr.KeyboardLayout, Max: 10, Validate: func(v string) string {
			for _, l := range keyboardLayouts {
				if v == "" || v == l {
					return ""
				}
			}
			return c.T("err.layout")
		}},
		{Label: c.T("prof.brand"), Value: pr.KeyboardBrand, Max: 40},
		{Label: c.T("prof.model"), Value: pr.KeyboardModel, Max: 60},
	}, func(v []string) string {
		pr.KeyboardLayout, pr.KeyboardBrand, pr.KeyboardModel = v[0], v[1], v[2]
		if err := c.DB.SaveProfile(pr); err != nil {
			return err.Error()
		}
		return ""
	})
}

func (p *profileScreen) View() string {
	c, s := p.ctx, p.ctx.S
	pr := c.Profile()
	xp := c.TotalXP()
	lvl := typing.LevelForXP(xp)
	name := pr.Username
	if name == "" {
		name = "guest"
	}
	head := lipgloss.JoinHorizontal(lipgloss.Top, s.Title.Render(name), "  ", s.Badge.Render(c.T("prof.guest")), " ",
		s.BadgeAccent.Render(fmt.Sprintf("%s %d", c.T("level"), lvl)), " ", s.Badge.Render(fmt.Sprintf("%d XP", xp)))
	row := func(label, v string) string {
		if v == "" {
			return ""
		}
		return s.Muted.Render(fmt.Sprintf("%-22s", label)) + s.Body.Render(v) + "\n"
	}
	var favs []string
	for _, f := range pr.FavoriteLanguages {
		favs = append(favs, favName(f))
	}
	body := row(c.T("prof.quote"), pr.Quote) + row(c.T("prof.programmer"), pr.Programmer) + row(c.T("prof.github"), pr.Github) +
		row(c.T("prof.website"), pr.Website) + row(c.T("prof.langs"), strings.Join(favs, ", ")) +
		row(c.T("prof.layout"), pr.KeyboardLayout) + row(c.T("prof.brand"), pr.KeyboardBrand) + row(c.T("prof.model"), pr.KeyboardModel) +
		row(c.T("prof.device"), strings.Trim(strings.Join([]string{pr.Platform, pr.OSVersion, pr.Device}, " · "), " ·"))
	return lipgloss.JoinVertical(lipgloss.Left, head, "", strings.TrimRight(body, "\n"), "", s.Muted.Render(c.T("prof.noaccount")))
}

func (p *profileScreen) Help() help.KeyMap {
	return bindings{short: kbs(kb("e", "e", "edit"), kb("l", "l", "languages"), kb("b", "b", "keyboard"), kb("esc", "esc", "back"))}
}
