package store

import (
	"crypto/rand"
	"crypto/sha256"
	"crypto/subtle"
	"encoding/base64"
	"encoding/hex"
	"strconv"
	"strings"
)

// Settings mirrors AppSettings for the options that make sense in a terminal
// (window border, corner style, navigation rail and OS shortcuts are GUI-only).
type Settings struct {
	Locale          string // "" = follow $LANG
	ActiveLanguage  string // "" = not chosen yet
	ThemeMode       string // system | light | dark
	Palette         string // auto | one of the 25 palettes
	Expressive      bool   // gradients on
	ReducedMotion   bool
	Accessible      bool
	Bell            bool // terminal bell on a wrong key (sound-pack stand-in)
	OnboardingDone  bool
	LiveKeyboard    bool
	ReminderOn      bool
	ReminderMinutes int // minutes after local midnight
	LockEnabled     bool
	LargeText       bool // letter-spaced, double-spaced code (the typing view is the hero)
	HighContrast    bool // 7:1 contrast on every role, no dimmed text
}

func b2s(b bool) string { return strconv.FormatBool(b) }
func s2b(s string, def bool) bool {
	if s == "" {
		return def
	}
	v, err := strconv.ParseBool(s)
	if err != nil {
		return def
	}
	return v
}

// LoadSettings reads settings with the app's defaults.
func (d *DB) LoadSettings() Settings {
	s := Settings{
		Locale: d.Get("s.locale"), ActiveLanguage: d.Get("s.lang"),
		ThemeMode: d.Get("s.theme"), Palette: d.Get("s.palette"),
		Expressive:      s2b(d.Get("s.expressive"), true),
		ReducedMotion:   s2b(d.Get("s.reduced"), false),
		Accessible:      s2b(d.Get("s.accessible"), false),
		Bell:            s2b(d.Get("s.bell"), false),
		OnboardingDone:  s2b(d.Get("s.onboarded"), false),
		LiveKeyboard:    s2b(d.Get("s.livekb"), false),
		ReminderOn:      s2b(d.Get("s.reminder"), false),
		ReminderMinutes: 1200,
		LockEnabled:     s2b(d.Get("s.lock"), false),
		LargeText:       s2b(d.Get("s.large"), true),
		HighContrast:    s2b(d.Get("s.contrast"), false),
	}
	if v, err := strconv.Atoi(d.Get("s.reminder_min")); err == nil {
		s.ReminderMinutes = v
	}
	if s.ThemeMode == "" {
		s.ThemeMode = "system"
	}
	if s.Palette == "" {
		s.Palette = "auto"
	}
	return s
}

// SaveSettings persists every field.
func (d *DB) SaveSettings(s Settings) error {
	for k, v := range map[string]string{
		"s.locale": s.Locale, "s.lang": s.ActiveLanguage, "s.theme": s.ThemeMode, "s.palette": s.Palette,
		"s.expressive": b2s(s.Expressive), "s.reduced": b2s(s.ReducedMotion), "s.accessible": b2s(s.Accessible),
		"s.bell": b2s(s.Bell), "s.onboarded": b2s(s.OnboardingDone), "s.livekb": b2s(s.LiveKeyboard),
		"s.reminder": b2s(s.ReminderOn), "s.reminder_min": strconv.Itoa(s.ReminderMinutes), "s.lock": b2s(s.LockEnabled), "s.large": b2s(s.LargeText), "s.contrast": b2s(s.HighContrast),
	} {
		if err := d.Set(k, v); err != nil {
			return err
		}
	}
	return nil
}

// Profile is the local Guest profile (SPEC §7.1) with its customization.
type Profile struct {
	Username, Quote, Programmer, Github, Website string
	FavoriteLanguages                            []string
	KeyboardLayout, KeyboardBrand, KeyboardModel string
	Platform, OSVersion, Device                  string
}

// MaxUsernameLength matches CreateGuestProfileUseCase.
const MaxUsernameLength = 24

// LoadProfile reads the profile; Username == "" means none yet.
func (d *DB) LoadProfile() Profile {
	p := Profile{
		Username: d.Get("p.username"), Quote: d.Get("p.quote"), Programmer: d.Get("p.programmer"),
		Github: d.Get("p.github"), Website: d.Get("p.website"),
		KeyboardLayout: d.Get("p.kb_layout"), KeyboardBrand: d.Get("p.kb_brand"), KeyboardModel: d.Get("p.kb_model"),
		Platform: d.Get("p.platform"), OSVersion: d.Get("p.os"), Device: d.Get("p.device"),
	}
	if v := d.Get("p.favlangs"); v != "" {
		p.FavoriteLanguages = strings.Split(v, ",")
	}
	return p
}

// SaveProfile persists the profile.
func (d *DB) SaveProfile(p Profile) error {
	for k, v := range map[string]string{
		"p.username": p.Username, "p.quote": p.Quote, "p.programmer": p.Programmer, "p.github": p.Github,
		"p.website": p.Website, "p.favlangs": strings.Join(p.FavoriteLanguages, ","),
		"p.kb_layout": p.KeyboardLayout, "p.kb_brand": p.KeyboardBrand, "p.kb_model": p.KeyboardModel,
		"p.platform": p.Platform, "p.os": p.OSVersion, "p.device": p.Device,
	} {
		if err := d.Set(k, v); err != nil {
			return err
		}
	}
	return nil
}

// --- PIN lock (SPEC §7; same sha256(salt:pin) scheme as pin_repository_impl) ---

func pinHash(pin, salt string) string {
	h := sha256.Sum256([]byte(salt + ":" + pin))
	return hex.EncodeToString(h[:])
}

// HasPIN reports whether a PIN is set.
func (d *DB) HasPIN() bool { return d.Get("lock.pin_hash") != "" }

// SetPIN stores a salted hash of the PIN.
func (d *DB) SetPIN(pin string) error {
	b := make([]byte, 16)
	if _, err := rand.Read(b); err != nil {
		return err
	}
	salt := base64.URLEncoding.EncodeToString(b)
	if err := d.Set("lock.pin_salt", salt); err != nil {
		return err
	}
	return d.Set("lock.pin_hash", pinHash(pin, salt))
}

// VerifyPIN compares in constant time.
func (d *DB) VerifyPIN(pin string) bool {
	salt, want := d.Get("lock.pin_salt"), d.Get("lock.pin_hash")
	if salt == "" || want == "" {
		return false
	}
	return subtle.ConstantTimeCompare([]byte(pinHash(pin, salt)), []byte(want)) == 1
}

// ClearPIN removes the PIN.
func (d *DB) ClearPIN() error {
	if err := d.Del("lock.pin_hash"); err != nil {
		return err
	}
	return d.Del("lock.pin_salt")
}
