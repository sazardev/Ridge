package ui

import (
	"math"
	"time"

	"github.com/charmbracelet/harmonica"
)

// frameInterval is the 60 fps budget while something moves (DESIGN: 60 fps max
// while interacting). idleInterval is the ambient-animation budget; it also
// runs at 60 fps so the breathing mark and shimmer stay liquid on modern
// terminals (the whole frame costs well under a millisecond).
const (
	frameInterval = time.Second / 60
	idleInterval  = time.Second / 60
)

type spring struct {
	pos, vel, target float64
	sp               harmonica.Spring
}

// Anim owns every eased value of the UI. It is stepped by one ticker that the
// root model starts only while something is moving and stops when it settles
// ("animations run on a ticker owned by the UI loop and stop when nothing is
// pending"). With reduced motion every value jumps straight to its target.
type Anim struct {
	Reduced bool
	springs map[string]*spring
	last    time.Time
	Idle    bool    // an ambient animation (shimmer, caret pulse) wants frames
	T       float64 // seconds since start, for ambient effects
	start   time.Time
}

// NewAnim builds an empty animation set.
func NewAnim(now time.Time) *Anim {
	return &Anim{springs: map[string]*spring{}, last: now, start: now}
}

// To eases key toward target. freq is the angular speed, damp the damping
// ratio (1 = critically damped, <1 overshoots a little).
func (a *Anim) To(key string, target, freq, damp float64) {
	s := a.springs[key]
	if s == nil {
		s = &spring{pos: target, target: target}
		a.springs[key] = s
	}
	s.target = target
	s.sp = harmonica.NewSpring(harmonica.FPS(60), freq, damp)
	if a.Reduced {
		s.pos, s.vel = target, 0
	}
}

// Set jumps key to value (no easing) and makes it the target.
func (a *Anim) Set(key string, v float64) {
	a.springs[key] = &spring{pos: v, target: v}
}

// Kick gives key an instantaneous velocity (used for impulses like a shake).
func (a *Anim) Kick(key string, v float64, freq, damp float64) {
	if a.Reduced {
		return
	}
	s := a.springs[key]
	if s == nil {
		s = &spring{}
		a.springs[key] = s
	}
	s.vel += v
	s.sp = harmonica.NewSpring(harmonica.FPS(60), freq, damp)
}

// V is the current eased value of key (0 if unknown).
func (a *Anim) V(key string) float64 {
	if s := a.springs[key]; s != nil {
		return s.pos
	}
	return 0
}

// Step advances every spring by the real elapsed time (capped so a stalled
// frame never teleports) and reports whether anything is still moving.
func (a *Anim) Step(now time.Time) (moving bool) {
	dt := now.Sub(a.last).Seconds()
	a.last = now
	a.T = now.Sub(a.start).Seconds()
	steps := int(math.Round(dt * 60))
	if steps < 1 {
		steps = 1
	}
	if steps > 6 {
		steps = 6
	}
	for _, s := range a.springs {
		if s.sp == (harmonica.Spring{}) {
			continue
		}
		for i := 0; i < steps; i++ {
			s.pos, s.vel = s.sp.Update(s.pos, s.vel, s.target)
		}
		if math.Abs(s.pos-s.target) < 0.002 && math.Abs(s.vel) < 0.002 {
			s.pos, s.vel = s.target, 0
		} else {
			moving = true
		}
	}
	return moving
}

// Moving reports whether any spring is unsettled (without stepping).
func (a *Anim) Moving() bool {
	for _, s := range a.springs {
		if math.Abs(s.pos-s.target) > 0.002 || math.Abs(s.vel) > 0.002 {
			return true
		}
	}
	return false
}

// Forget drops keys with a prefix (when a screen is left).
func (a *Anim) Forget(prefix string) {
	for k := range a.springs {
		if len(k) >= len(prefix) && k[:len(prefix)] == prefix {
			delete(a.springs, k)
		}
	}
}
