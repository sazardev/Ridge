package progress

import (
	"math"
	"sort"
	"time"
)

// ActivitySample is one finished session as seen by the activity ranking.
type ActivitySample struct {
	At          time.Time
	Category    string
	SnippetID   string
	Duration    time.Duration
	AccuracyPct float64
	NetCPM      float64
}

// ActivityStat aggregates a category or an exercise (SnippetID).
type ActivityStat struct {
	Key         string
	Sessions    int
	Time        time.Duration
	AvgAccuracy float64
	AvgNetCPM   float64
	Performance float64
	Trend       Trend
}

// ActivityReport is the progress screen's "where you spend time / struggle".
type ActivityReport struct {
	MostPracticedCategories, LowestCategories []ActivityStat
	MostPracticedExercises, LowestExercises   []ActivityStat
}

const (
	activityTopN      = 5
	recencyWindow     = 60 * 24 * time.Hour
	minLowestSessions = 3
	accWeight         = 0.6
	speedWeight       = 0.4
	trendWindowDays   = 30.0
)

func avg(g []ActivitySample, f func(ActivitySample) float64) float64 {
	if len(g) == 0 {
		return 0
	}
	var s float64
	for _, x := range g {
		s += f(x)
	}
	return s / float64(len(g))
}

func perf(g []ActivitySample, overallSpeed float64) float64 {
	if len(g) == 0 {
		return 0
	}
	norm := 0.0
	if overallSpeed > 0 {
		norm = math.Min(100, avg(g, func(x ActivitySample) float64 { return x.NetCPM })/overallSpeed*50)
	}
	return accWeight*avg(g, func(x ActivitySample) float64 { return x.AccuracyPct }) + speedWeight*norm
}

func actTrend(g []ActivitySample, now time.Time, overall float64) Trend {
	var r, p []ActivitySample
	for _, s := range g {
		age := now.Sub(s.At).Hours() / 24
		switch {
		case age < trendWindowDays:
			r = append(r, s)
		case age < 2*trendWindowDays:
			p = append(p, s)
		}
	}
	if len(r) == 0 || len(p) == 0 {
		return Stable
	}
	rs, ps := perf(r, overall), perf(p, overall)
	if ps <= 0 {
		if rs <= 0 {
			return Stable
		}
		return Improving
	}
	ch := (rs - ps) / ps
	switch {
	case ch > stableBand:
		return Improving
	case ch < -stableBand:
		return Worsening
	}
	return Stable
}

func stats(samples []ActivitySample, now time.Time, key func(ActivitySample) string, withTrend bool) []ActivityStat {
	by := map[string][]ActivitySample{}
	for _, s := range samples {
		by[key(s)] = append(by[key(s)], s)
	}
	overall := avg(samples, func(x ActivitySample) float64 { return x.NetCPM })
	var out []ActivityStat
	for k, g := range by {
		var t time.Duration
		for _, s := range g {
			t += s.Duration
		}
		st := ActivityStat{Key: k, Sessions: len(g), Time: t,
			AvgAccuracy: avg(g, func(x ActivitySample) float64 { return x.AccuracyPct }),
			AvgNetCPM:   avg(g, func(x ActivitySample) float64 { return x.NetCPM }),
			Performance: perf(g, overall)}
		if withTrend {
			st.Trend = actTrend(g, now, overall)
		}
		out = append(out, st)
	}
	return out
}

func top(s []ActivityStat, less func(a, b ActivityStat) bool) []ActivityStat {
	sort.SliceStable(s, func(i, j int) bool {
		if less(s[i], s[j]) != less(s[j], s[i]) {
			return less(s[i], s[j])
		}
		return s[i].Key < s[j].Key
	})
	if len(s) > activityTopN {
		s = s[:activityTopN]
	}
	return s
}

// Activity builds the report from every session sample.
func Activity(samples []ActivitySample, now time.Time) ActivityReport {
	var recent []ActivitySample
	for _, s := range samples {
		if now.Sub(s.At) <= recencyWindow {
			recent = append(recent, s)
		}
	}
	cat := func(s ActivitySample) string { return s.Category }
	ex := func(s ActivitySample) string { return s.SnippetID }
	most := func(a, b ActivityStat) bool {
		if a.Sessions != b.Sessions {
			return a.Sessions > b.Sessions
		}
		return a.Time > b.Time
	}
	lowest := func(a, b ActivityStat) bool { return a.Performance < b.Performance }
	enough := func(in []ActivityStat) []ActivityStat {
		var out []ActivityStat
		for _, s := range in {
			if s.Sessions >= minLowestSessions {
				out = append(out, s)
			}
		}
		return out
	}
	return ActivityReport{
		MostPracticedCategories: top(stats(samples, now, cat, true), most),
		LowestCategories:        top(enough(stats(recent, now, cat, true)), lowest),
		MostPracticedExercises:  top(stats(samples, now, ex, false), most),
		LowestExercises:         top(enough(stats(recent, now, ex, false)), lowest),
	}
}

// WeeklySession is the slice of a session the weekly summary needs.
type WeeklySession struct {
	At          time.Time
	Duration    time.Duration
	XP          int
	NetCPM      float64
	AccuracyPct float64
}

// Weekly is the last-7-days card with the previous week for comparison.
type Weekly struct {
	Sessions, PreviousSessions     int
	Duration, PreviousDuration     time.Duration
	XP                             int
	AvgCPM, PreviousAvgCPM, AvgAcc float64
	ActiveDays                     int
}

// WeeklySummary mirrors weekly_summary_calculator.dart.
func WeeklySummary(sessions []WeeklySession, nowLocal time.Time) Weekly {
	day := func(t time.Time) time.Time {
		y, m, d := t.Local().Date()
		return time.Date(y, m, d, 0, 0, 0, 0, time.Local)
	}
	today := day(nowLocal)
	start := today.AddDate(0, 0, -6)
	prevStart := start.AddDate(0, 0, -7)
	var cur, prev []WeeklySession
	days := map[time.Time]bool{}
	for _, s := range sessions {
		d := day(s.At)
		if d.After(today) {
			continue
		}
		if d.Before(start) {
			if !d.Before(prevStart) {
				prev = append(prev, s)
			}
		} else {
			cur = append(cur, s)
			days[d] = true
		}
	}
	mean := func(g []WeeklySession, f func(WeeklySession) float64) float64 {
		if len(g) == 0 {
			return 0
		}
		var t float64
		for _, s := range g {
			t += f(s)
		}
		return t / float64(len(g))
	}
	dur := func(g []WeeklySession) (t time.Duration) {
		for _, s := range g {
			t += s.Duration
		}
		return
	}
	w := Weekly{Sessions: len(cur), PreviousSessions: len(prev), Duration: dur(cur), PreviousDuration: dur(prev),
		AvgCPM:         mean(cur, func(s WeeklySession) float64 { return s.NetCPM }),
		PreviousAvgCPM: mean(prev, func(s WeeklySession) float64 { return s.NetCPM }),
		AvgAcc:         mean(cur, func(s WeeklySession) float64 { return s.AccuracyPct }), ActiveDays: len(days)}
	for _, s := range cur {
		w.XP += s.XP
	}
	return w
}
