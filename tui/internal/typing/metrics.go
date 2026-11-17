package typing

import (
	"math"
	"sort"
	"time"
)

// CharStat is the per-character profile (SPEC §4.2).
type CharStat struct {
	Char      rune
	Attempts  int
	Errors    int
	AvgFlight time.Duration
}

// FingerStat is the per-finger profile.
type FingerStat struct {
	Finger   Finger
	Attempts int
	Errors   int
}

// Metrics is everything derived from a session (SPEC §4.2).
type Metrics struct {
	RawCPM, NetCPM       float64
	RawWPM, NetWPM       float64
	Accuracy             float64
	Consistency          float64
	MaxStreak            int
	FatigueCPM           [3]float64
	HandBalance          float64
	Corrections          int
	Chars                []CharStat
	Fingers              []FingerStat
	Duration             time.Duration
	CorrectFirstTryChars int
}

// Calculate derives metrics from forward keystrokes (corrections excluded
// from speed/accuracy but counted separately).
func Calculate(events []Keystroke, total time.Duration) Metrics {
	var fwd []Keystroke
	m := Metrics{Duration: total}
	for _, k := range events {
		if k.IsCorrection {
			m.Corrections++
			continue
		}
		fwd = append(fwd, k)
	}
	correct := 0
	for _, k := range fwd {
		if k.Result == Correct {
			correct++
		}
	}
	mins := total.Minutes()
	per := func(n int) float64 {
		if mins <= 0 {
			return 0
		}
		return float64(n) / mins
	}
	m.RawCPM, m.NetCPM = per(len(fwd)), per(correct)
	m.RawWPM, m.NetWPM = m.RawCPM/5, m.NetCPM/5 // 5 chars = 1 word, the usual convention
	if len(fwd) > 0 {
		m.Accuracy = float64(correct) / float64(len(fwd)) * 100
	}
	m.CorrectFirstTryChars = correct
	m.Consistency = consistency(fwd)
	m.MaxStreak = maxStreak(fwd)
	m.FatigueCPM = fatigue(fwd)
	m.HandBalance = handBalance(fwd)
	m.Chars = charStats(fwd)
	m.Fingers = fingerStats(fwd)
	return m
}

func consistency(fwd []Keystroke) float64 {
	var fl []float64
	for _, k := range fwd {
		if k.Flight > 0 {
			fl = append(fl, float64(k.Flight)/float64(time.Millisecond))
		}
	}
	if len(fl) < 2 {
		return 100
	}
	var sum float64
	for _, f := range fl {
		sum += f
	}
	mean := sum / float64(len(fl))
	if mean <= 0 {
		return 100
	}
	var v float64
	for _, f := range fl {
		v += (f - mean) * (f - mean)
	}
	sd := math.Sqrt(v / float64(len(fl)))
	return math.Max(0, math.Min(100, 100*(1-sd/mean)))
}

func maxStreak(fwd []Keystroke) int {
	cur, best := 0, 0
	for _, k := range fwd {
		if k.Result == Correct {
			cur++
			if cur > best {
				best = cur
			}
		} else {
			cur = 0
		}
	}
	return best
}

func fatigue(fwd []Keystroke) [3]float64 {
	var out [3]float64
	n := len(fwd)
	if n == 0 {
		return out
	}
	t := n / 3
	bounds := [][2]int{{0, t}, {t, 2 * t}, {2 * t, n}}
	for i, b := range bounds {
		if b[1] <= b[0] {
			continue
		}
		var el time.Duration
		for _, k := range fwd[b[0]:b[1]] {
			el += k.Flight
		}
		if mins := el.Minutes(); mins > 0 {
			out[i] = float64(b[1]-b[0]) / mins
		}
	}
	return out
}

func handBalance(fwd []Keystroke) float64 {
	l, r := 0, 0
	for _, k := range fwd {
		switch k.Finger.Hand() {
		case "L":
			l++
		case "R":
			r++
		}
	}
	mx := l
	if r > mx {
		mx = r
	}
	if mx == 0 {
		return 1
	}
	mn := l
	if r < mn {
		mn = r
	}
	return float64(mn) / float64(mx)
}

func charStats(fwd []Keystroke) []CharStat {
	by := map[rune]*CharStat{}
	sums := map[rune]time.Duration{}
	cnt := map[rune]int{}
	for _, k := range fwd {
		s := by[k.Expected]
		if s == nil {
			s = &CharStat{Char: k.Expected}
			by[k.Expected] = s
		}
		s.Attempts++
		if k.Result != Correct {
			s.Errors++
		}
		if k.Flight > 0 {
			sums[k.Expected] += k.Flight
			cnt[k.Expected]++
		}
	}
	out := make([]CharStat, 0, len(by))
	for c, s := range by {
		if cnt[c] > 0 {
			s.AvgFlight = sums[c] / time.Duration(cnt[c])
		}
		out = append(out, *s)
	}
	sort.Slice(out, func(i, j int) bool { return out[i].Char < out[j].Char })
	return out
}

func fingerStats(fwd []Keystroke) []FingerStat {
	by := map[Finger]*FingerStat{}
	for _, k := range fwd {
		s := by[k.Finger]
		if s == nil {
			s = &FingerStat{Finger: k.Finger}
			by[k.Finger] = s
		}
		s.Attempts++
		if k.Result != Correct {
			s.Errors++
		}
	}
	out := make([]FingerStat, 0, len(by))
	for _, s := range by {
		out = append(out, *s)
	}
	sort.Slice(out, func(i, j int) bool { return out[i].Finger < out[j].Finger })
	return out
}

// NgramStat is a 2/3-character chain profile (SPEC §4.2 "n-gramas").
type NgramStat struct {
	Text       string
	Occurrence int
	Errors     int
	AvgMs      float64
}

// NgramSample is one occurrence of an n-gram, stored for the weakness ranking.
type NgramSample struct {
	Text     string
	IsError  bool
	FlightMs float64
}

// TransitionSample is the cost of moving between two physical keys.
type TransitionSample struct {
	From, To string
	IsError  bool
	FlightMs float64
}

func forward(events []Keystroke) []Keystroke {
	var out []Keystroke
	for _, k := range events {
		if !k.IsCorrection {
			out = append(out, k)
		}
	}
	return out
}

// NgramSamples slides 2- and 3-character windows over the forward keystrokes,
// keyed by the characters actually typed (like the app).
func NgramSamples(events []Keystroke) []NgramSample {
	fwd := forward(events)
	var out []NgramSample
	for _, size := range []int{2, 3} {
		for i := 0; i+size <= len(fwd); i++ {
			w := fwd[i : i+size]
			var text []rune
			var dur time.Duration
			bad := false
			for _, k := range w {
				text = append(text, k.Actual)
				dur += k.Flight
				if k.Result != Correct {
					bad = true
				}
			}
			out = append(out, NgramSample{string(text), bad, float64(dur) / float64(time.Millisecond)})
		}
	}
	return out
}

// TransitionSamples records each consecutive pair of physical keys.
func TransitionSamples(events []Keystroke) []TransitionSample {
	fwd := forward(events)
	var out []TransitionSample
	for i := 1; i < len(fwd); i++ {
		a, b := fwd[i-1], fwd[i]
		out = append(out, TransitionSample{PhysicalKey(a.Actual), PhysicalKey(b.Actual),
			b.Result != Correct, float64(b.Flight) / float64(time.Millisecond)})
	}
	return out
}

// KeyHeat is the per-physical-key aggregate behind the keyboard heat map.
type KeyHeat struct {
	Presses, Errors int
	AvgFlightMs     float64
}

// Heatmap aggregates presses, errors and speed by physical key.
func Heatmap(events []Keystroke) map[string]KeyHeat {
	sums := map[string]float64{}
	cnt := map[string]int{}
	out := map[string]KeyHeat{}
	for _, k := range forward(events) {
		key := PhysicalKey(k.Actual)
		h := out[key]
		h.Presses++
		if k.Result != Correct {
			h.Errors++
		}
		out[key] = h
		if k.Flight > 0 {
			sums[key] += float64(k.Flight) / float64(time.Millisecond)
			cnt[key]++
		}
	}
	for key, h := range out {
		if cnt[key] > 0 {
			h.AvgFlightMs = sums[key] / float64(cnt[key])
		}
		out[key] = h
	}
	return out
}
