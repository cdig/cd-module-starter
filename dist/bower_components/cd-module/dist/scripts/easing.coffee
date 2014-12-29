# Easing
# Here's a nice bucket for us to dump easing functions into.

Make "Easing",
	inOutCubic: (t, b, c, d)->
		t /= d/2
		if (t < 1)
			return c/2*t*t*t + b
		else
			t -= 2
			return c/2*(t*t*t + 2) + b
