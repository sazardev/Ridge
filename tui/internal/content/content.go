// Package content loads the bundled snippet catalogs and learning paths — the
// very same JSON the Flutter app ships (assets/content/**).
package content

import (
	"embed"
	"encoding/json"
	"fmt"
	"io/fs"
	"sort"
	"strings"
)

//go:embed assets
var assets embed.FS

// Difficulty mirrors SPEC §3.2.
type Difficulty string

const (
	Beginner     Difficulty = "beginner"
	Intermediate Difficulty = "intermediate"
	Advanced     Difficulty = "advanced"
	Expert       Difficulty = "expert"
)

// Locale selects the bilingual text variant.
type Locale string

const (
	EN Locale = "en"
	ES Locale = "es"
)

// Snippet is one typeable piece of real code.
type Snippet struct {
	ID            string     `json:"id"`
	Language      string     `json:"language"`
	Difficulty    Difficulty `json:"difficulty"`
	Category      string     `json:"category"`
	Length        string     `json:"length"`
	Code          string     `json:"code"`
	IsActive      bool       `json:"isActive"`
	TitleEn       string     `json:"titleEn"`
	TitleEs       string     `json:"titleEs"`
	TldrEn        string     `json:"tldrEn"`
	TldrEs        string     `json:"tldrEs"`
	ExplanationEn string     `json:"explanationEn"`
	ExplanationEs string     `json:"explanationEs"`
}

// Title returns the localized title, falling back to the other language.
func (s Snippet) Title(l Locale) string { return pick(l, s.TitleEn, s.TitleEs) }

// Tldr returns the localized one-liner.
func (s Snippet) Tldr(l Locale) string { return pick(l, s.TldrEn, s.TldrEs) }

// Explanation returns the localized long explanation.
func (s Snippet) Explanation(l Locale) string { return pick(l, s.ExplanationEn, s.ExplanationEs) }

// Lesson is one ordered step of a learning path.
type Lesson struct {
	ID        string `json:"id"`
	SnippetID string `json:"snippetId"`
	Order     int    `json:"order"`
	TitleEn   string `json:"titleEn"`
	TitleEs   string `json:"titleEs"`
}

// Title returns the localized lesson title.
func (l Lesson) Title(loc Locale) string { return pick(loc, l.TitleEn, l.TitleEs) }

// Path is a guided course (SPEC §5.7).
type Path struct {
	ID            string   `json:"id"`
	Language      string   `json:"language"`
	Lessons       []Lesson `json:"lessons"`
	TitleEn       string   `json:"titleEn"`
	TitleEs       string   `json:"titleEs"`
	DescriptionEn string   `json:"descriptionEn"`
	DescriptionEs string   `json:"descriptionEs"`
	TagEn         string   `json:"tagEn"`
	TagEs         string   `json:"tagEs"`
}

// Title returns the localized course title.
func (p Path) Title(l Locale) string { return pick(l, p.TitleEn, p.TitleEs) }

// Description returns the localized course description.
func (p Path) Description(l Locale) string { return pick(l, p.DescriptionEn, p.DescriptionEs) }

// Tag returns the localized short tag.
func (p Path) Tag(l Locale) string { return pick(l, p.TagEn, p.TagEs) }

func pick(l Locale, en, es string) string {
	if l == ES && es != "" {
		return es
	}
	if en != "" {
		return en
	}
	return es
}

// Catalog is the merged, read-only content bank.
type Catalog struct {
	snippets  map[string]Snippet
	byLang    map[string][]Snippet
	paths     []Path
	pathsLang map[string][]Path
}

// Load reads and merges every embedded asset.
func Load() (*Catalog, error) {
	c := &Catalog{
		snippets:  map[string]Snippet{},
		byLang:    map[string][]Snippet{},
		pathsLang: map[string][]Path{},
	}
	if err := readAll(assets, "assets/snippets", func(b []byte) error {
		var list []Snippet
		if err := json.Unmarshal(b, &list); err != nil {
			return err
		}
		for _, s := range list {
			if !s.IsActive {
				continue
			}
			c.snippets[s.ID] = s
			c.byLang[s.Language] = append(c.byLang[s.Language], s)
		}
		return nil
	}); err != nil {
		return nil, err
	}
	if err := readAll(assets, "assets/learning_paths", func(b []byte) error {
		var list []Path
		if err := json.Unmarshal(b, &list); err != nil {
			return err
		}
		for _, p := range list {
			sort.Slice(p.Lessons, func(i, j int) bool { return p.Lessons[i].Order < p.Lessons[j].Order })
			c.paths = append(c.paths, p)
			c.pathsLang[p.Language] = append(c.pathsLang[p.Language], p)
		}
		return nil
	}); err != nil {
		return nil, err
	}
	// Beginner-first course order: foundations, then topic courses, then algorithms.
	rank := func(id string) int {
		switch {
		case strings.Contains(id, "foundations"):
			return 0
		case strings.Contains(id, "algorithms"):
			return 2
		}
		return 1
	}
	less := func(a, b Path) bool {
		if ra, rb := rank(a.ID), rank(b.ID); ra != rb {
			return ra < rb
		}
		return a.ID < b.ID
	}
	sort.Slice(c.paths, func(i, j int) bool { return less(c.paths[i], c.paths[j]) })
	for _, list := range c.pathsLang {
		sort.Slice(list, func(i, j int) bool { return less(list[i], list[j]) })
	}
	return c, nil
}

func readAll(fsys fs.FS, dir string, fn func([]byte) error) error {
	entries, err := fs.ReadDir(fsys, dir)
	if err != nil {
		return err
	}
	for _, e := range entries {
		if e.IsDir() || !strings.HasSuffix(e.Name(), ".json") {
			continue
		}
		b, err := fs.ReadFile(fsys, dir+"/"+e.Name())
		if err != nil {
			return err
		}
		if err := fn(b); err != nil {
			return fmt.Errorf("%s: %w", e.Name(), err)
		}
	}
	return nil
}

// Snippet looks one up by id.
func (c *Catalog) Snippet(id string) (Snippet, bool) { s, ok := c.snippets[id]; return s, ok }

// SnippetsFor returns every active snippet of a language.
func (c *Catalog) SnippetsFor(lang string) []Snippet { return c.byLang[lang] }

// PathsFor returns the courses of a language.
func (c *Catalog) PathsFor(lang string) []Path { return c.pathsLang[lang] }

// Path looks a course up by id.
func (c *Catalog) Path(id string) (Path, bool) {
	for _, p := range c.paths {
		if p.ID == id {
			return p, true
		}
	}
	return Path{}, false
}

// Languages lists languages with content, sorted by display name.
func (c *Catalog) Languages() []string {
	out := make([]string, 0, len(c.byLang))
	for l := range c.byLang {
		out = append(out, l)
	}
	sort.Slice(out, func(i, j int) bool { return LanguageName(out[i]) < LanguageName(out[j]) })
	return out
}

var langNames = map[string]string{
	"go": "Go", "bash": "Bash", "sql": "SQL", "rust": "Rust", "zig": "Zig", "python": "Python",
	"javascript": "JavaScript", "typescript": "TypeScript", "haskell": "Haskell", "c": "C",
	"cpp": "C++", "java": "Java", "crystal": "Crystal", "swift": "Swift", "css": "CSS",
	"csharp": "C#", "dart": "Dart", "kotlin": "Kotlin", "php": "PHP", "git": "Git",
	"linux": "Linux", "githubActions": "GitHub Actions", "dockerfile": "Docker", "docker": "Docker",
	"mojo": "Mojo",
}

// LanguageName returns the display name of a language id.
func LanguageName(id string) string {
	if n, ok := langNames[id]; ok {
		return n
	}
	return id
}

// Categories lists every distinct snippet category, sorted.
func (c *Catalog) Categories() []string {
	seen := map[string]bool{}
	var out []string
	for _, list := range c.byLang {
		for _, s := range list {
			if !seen[s.Category] {
				seen[s.Category] = true
				out = append(out, s.Category)
			}
		}
	}
	sort.Strings(out)
	return out
}
