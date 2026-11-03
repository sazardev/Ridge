// Package progress holds the pure progression rules — weakness ranking,
// activity ranking, mastery, streaks, achievements, lesson unlocking, weekly
// summary, daily challenge — ported 1:1 from lib/features/*/domain/services.
package progress

import (
	"math"
	"sort"
	"time"
)

// Trend of a ranked item.
type Trend int

const (
	Stable Trend = iota
	Improving
	Worsening
)

// Sample is one observation of a character/finger/n-gram/key transition.
type Sample struct {
	AgeDays  float64
	IsError  bool
	FlightMs float64
}

// RankEntry is one ranked weakness.
type RankEntry struct {
	Key   string
	Score float64
	Trend Trend
}

const (
	HalfLifeDays    = 14.0
	errorRateWeight = 0.6
	slownessWeight  = 0.4
	stableBand      = 0.1
	windowDays      = 14.0
)

func recency(age float64) float64 { return math.Pow(0.5, age/HalfLifeDays) }

func weightedFlight(s []Sample) float64 {
	var w, fw float64
	for _, x := range s {
		r := recency(x.AgeDays)
		w += r
		fw += r * x.FlightMs
	}
	if w <= 0 {
		return 0
	}
	return fw / w
}

func score(s []Sample, globalFlight float64) float64 {
	if len(s) == 0 {
		return 0
	}
	var w, ew float64
	for _, x := range s {
		r := recency(x.AgeDays)
		w += r
		if x.IsError {
			ew += r
		}
	}
	if w <= 0 {
		return 0
	}
	slow := 0.0
	if globalFlight > 0 {
		slow = math.Max(0, math.Min(1, weightedFlight(s)/(2*globalFlight)))
	}
	return errorRateWeight*(ew/w) + slownessWeight*slow
}

func trend(s []Sample) Trend {
	var recent, prev []Sample
	for _, x := range s {
		switch {
		case x.AgeDays < windowDays:
			recent = append(recent, x)
		case x.AgeDays < 2*windowDays:
			prev = append(prev, x)
		}
	}
	if len(recent) == 0 || len(prev) == 0 {
		return Stable
	}
	rs, ps := score(recent, weightedFlight(recent)), score(prev, weightedFlight(prev))
	if ps <= 0 {
		if rs <= 0 {
			return Stable
		}
		return Worsening
	}
	ch := (rs - ps) / ps
	switch {
	case ch > stableBand:
		return Worsening
	case ch < -stableBand:
		return Improving
	}
	return Stable
}

// Rank orders keys by weakness (error rate 60 %, slowness 40 %, recency-weighted).
func Rank(by map[string][]Sample, topN int) []RankEntry {
	var all []Sample
	for _, s := range by {
		all = append(all, s...)
	}
	g := weightedFlight(all)
	out := make([]RankEntry, 0, len(by))
	for k, s := range by {
		out = append(out, RankEntry{k, score(s, g), trend(s)})
	}
	sort.Slice(out, func(i, j int) bool {
		if out[i].Score != out[j].Score {
			return out[i].Score > out[j].Score
		}
		return out[i].Key < out[j].Key
	})
	if len(out) > topN {
		out = out[:topN]
	}
	return out
}

// Streak counts consecutive played local days ending today (or yesterday).
func Streak(days map[string]bool, today time.Time) int {
	const f = "2006-01-02"
	d := today
	if !days[d.Format(f)] {
		d = d.AddDate(0, 0, -1)
		if !days[d.Format(f)] {
			return 0
		}
	}
	n := 0
	for days[d.Format(f)] {
		n++
		d = d.AddDate(0, 0, -1)
	}
	return n
}
