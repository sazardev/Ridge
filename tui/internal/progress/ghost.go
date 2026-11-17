package progress

import (
	"time"

	"github.com/omar/ridge/tui/internal/typing"
)

// GhostStep is when the ghost typed a given position.
type GhostStep struct {
	Position int
	At       time.Duration
}

// FoldGhost reduces a recorded keystroke stream to the correct-position
// timeline the ghost replays (ghost_run_fold.dart).
func FoldGhost(events []typing.Keystroke) []GhostStep {
	var steps []GhostStep
	pos := 0
	var el time.Duration
	for _, k := range events {
		el += k.Flight
		if k.IsCorrection {
			if pos > 0 {
				pos--
			}
			continue
		}
		if k.Result != typing.Correct {
			continue
		}
		steps = append(steps, GhostStep{pos, el})
		pos++
	}
	return steps
}

// GhostPosition is how many characters the ghost has typed after elapsed.
func GhostPosition(steps []GhostStep, elapsed time.Duration) int {
	n := 0
	for _, s := range steps {
		if s.At > elapsed {
			break
		}
		n = s.Position + 1
	}
	return n
}
