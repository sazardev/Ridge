package ui

import (
	"os"
	"strings"

	"github.com/omar/ridge/tui/internal/content"
)

// Strings mirror lib/l10n/*.arb in spirit: en/es, looked up by key.
var strings_ = map[string][2]string{ // {en, es}
	"tagline":         {"Type better, not just faster.", "Escribe mejor, no solo más rápido."},
	"home.zen":        {"Zen", "Zen"},
	"home.zen.d":      {"Free practice — no clock, no pressure", "Práctica libre — sin reloj ni presión"},
	"home.sprint":     {"Sprint", "Sprint"},
	"home.sprint.d":   {"Beat the clock: 30 / 60 / 120 s", "Contra el reloj: 30 / 60 / 120 s"},
	"home.prec":       {"Precision", "Precisión"},
	"home.prec.d":     {"Pass with 80%+ accuracy", "Aprueba con 80%+ de precisión"},
	"home.surv":       {"Survival", "Supervivencia"},
	"home.surv.d":     {"5 lives, combo multiplier, no clock", "5 vidas, multiplicador de combo, sin reloj"},
	"home.daily":      {"Daily challenge", "Reto diario"},
	"home.daily.d":    {"Same snippet for everyone, once a day", "Mismo snippet para todos, una vez al día"},
	"home.courses":    {"Courses", "Rutas de aprendizaje"},
	"home.courses.d":  {"Guided lessons, unlocked in order", "Lecciones guiadas, se desbloquean en orden"},
	"home.profile":    {"Profile", "Perfil"},
	"home.profile.d":  {"Level, XP, streak and history", "Nivel, XP, racha e historial"},
	"home.settings":   {"Settings", "Ajustes"},
	"home.settings.d": {"Language, content language, motion", "Idioma, lenguaje activo, animación"},
	"home.quit":       {"Quit", "Salir"},
	"lang.title":      {"Choose a language", "Elige un lenguaje"},
	"lessons":         {"lessons", "lecciones"},
	"courses.title":   {"Courses", "Rutas"},
	"course.locked":   {"Pass the previous lesson (≥ 80%) to unlock", "Aprueba la lección anterior (≥ 80%) para desbloquear"},
	"snip.title":      {"Pick a snippet", "Elige un snippet"},
	"filter":          {"filter", "filtrar"},
	"empty":           {"Nothing here yet.", "Aún no hay nada aquí."},
	"nodata":          {"No sessions yet — go type something!", "Aún no hay sesiones — ¡ve a teclear algo!"},
	"cpm":             {"cpm", "cpm"},
	"raw":             {"raw speed", "velocidad bruta"},
	"acc":             {"Accuracy", "Precisión"},
	"cons":            {"Consistency", "Consistencia"},
	"streak":          {"Best streak", "Mejor racha"},
	"corr":            {"Corrections", "Correcciones"},
	"hands":           {"Hands", "Manos"},
	"fatigue":         {"Fatigue", "Fatiga"},
	"weak":            {"Weak spots", "Puntos débiles"},
	"fingers":         {"Fingers", "Dedos"},
	"xp.gained":       {"XP earned", "XP ganada"},
	"level":           {"Level", "Nivel"},
	"levelup":         {"Level up!", "¡Subes de nivel!"},
	"passed":          {"Passed", "Aprobado"},
	"failed":          {"Not yet — need 80%+", "Aún no — se requiere 80%+"},
	"time":            {"Time", "Tiempo"},
	"lives":           {"Lives", "Vidas"},
	"score":           {"Score", "Puntaje"},
	"cleared":         {"Snippets cleared", "Snippets completados"},
	"gameover":        {"Run over", "Fin de la run"},
	"timeup":          {"Time's up", "Se acabó el tiempo"},
	"done":            {"Done", "Completado"},
	"daily.done":      {"Today's challenge is already counted.", "El reto de hoy ya contó."},
	"streakdays":      {"Day streak", "Racha de días"},
	"history":         {"Recent sessions", "Sesiones recientes"},
	"set.locale":      {"Interface language", "Idioma de la interfaz"},
	"set.lang":        {"Active programming language", "Lenguaje de programación activo"},
	"set.motion":      {"Reduced motion", "Movimiento reducido"},
	"on":              {"on", "sí"},
	"off":             {"off", "no"},
	"locked.level":    {"Unlocks at level", "Se desbloquea en el nivel"},
	"explain":         {"About this snippet", "Sobre este snippet"},
	"tooSmall":        {"Terminal too small — need at least 40×20.", "Terminal muy pequeña — se requieren al menos 40×20."},
	"paste":           {"Paste is ignored while typing.", "Pegar se ignora mientras tecleas."},
	"paused":          {"Paused", "En pausa"},
}

// utf8Locale reports whether the environment promises UTF-8.
func utf8Locale() bool {
	for _, k := range []string{"LC_ALL", "LC_CTYPE", "LANG"} {
		if v := os.Getenv(k); v != "" {
			v = strings.ToLower(v)
			return strings.Contains(v, "utf-8") || strings.Contains(v, "utf8")
		}
	}
	return true
}

// defaultLocale picks es when the environment is Spanish.
func defaultLocale() content.Locale {
	if strings.HasPrefix(strings.ToLower(os.Getenv("LANG")), "es") {
		return content.ES
	}
	return content.EN
}

// addStrings lets each screen file register its own en/es strings.
func addStrings(m map[string][2]string) {
	for k, v := range m {
		strings_[k] = v
	}
}
