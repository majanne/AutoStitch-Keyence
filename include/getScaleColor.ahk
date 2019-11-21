getScaleColor(xLeft, xRight, yTop, yBottom) {
	;MsgBox, xL = %xLeft%, xR = %xRight%, yT = %yTop%, yB = %yBottom%
	
	CoordMode, Mouse, Client
	CoordMode, Pixel, Client
	
	samples := 7
	xStep := (xRight-xLeft)/(samples-1)
	yStep := (yBottom - yTop)/(samples-1)
	
	blackCounter := 0
	x := xLeft
	Loop, %samples% {
		y := yTop
		Loop, %samples% {
			PixelGetColor, colorProbe, x, y , RGB
			;MouseMove, %x%, %y%, 0
			;sleep 100
			blackCounter := blackCounter + isBlack(colorProbe)
			; Move to next Y point
			y := y + yStep
		}
		; Move to next X point
		x := x + xStep
	}
	;MsgBox, blackCounter = %blackCounter%
	
	if (blackCounter > Floor(samples*samples/2)) {
		return "white"
	} else {
		return "black"
	}
}