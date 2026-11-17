package ui

// orientation classifies a terminal by its usable aspect ratio, not by a fixed
// width. The same app therefore reflows for a tall split pane (portrait), a
// roughly square window, and a normal wide terminal (landscape).
type orientation int

const (
	portrait orientation = iota
	square
	landscape
)

// orientationFor is ratio-based so 80x50 and 160x100 behave alike.
func orientationFor(w, h int) orientation {
	if w <= 0 || h <= 0 {
		return landscape
	}
	r := float64(w) / float64(h)
	switch {
	case r < 0.85:
		return portrait
	case r < 1.45:
		return square
	default:
		return landscape
	}
}

func (c *Ctx) orientation() orientation { return orientationFor(c.W, c.H) }

// isLandscape reports whether side-by-side panes have room to breathe.
func (c *Ctx) isLandscape() bool { return c.orientation() == landscape }

// isPortrait reports a tall, narrow pane (vertical split / phone-like terminal).
func (c *Ctx) isPortrait() bool { return c.orientation() == portrait }
