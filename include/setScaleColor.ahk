

/* isBlack(rgbColor) {
	b := Mod(rgbColor, 256)
	g := Mod(Floor(rgbColor / 256) , 256)
	r := Mod(Floor(rgbColor / 256 / 256) , 256)

	luminance := 0.2126*r + 0.7152*g + 0.0722*b
	;MsgBox For %rgbColor% R= %r%, G= %g%, B= %b%, L= %luminance%.
	if ( luminance < 150 ) {
		;MsgBox For 1 %rgbColor% R= %r%, G= %g%, B= %b%, L= %luminance%.
		return 1
	} else {
		;MsgBox For 0 %rgbColor% R= %r%, G= %g%, B= %b%, L= %luminance%.
		return 0
	}
} */

/* getScaleColor(xLeft, xRight, yTop, yBottom) {
	samples := 7
	xStep := (xRight-xLeft)/(samples-1)
	yStep := (yBottom - yTop)/(samples-1)
	
	blackCounter := 0
	x := xLeft
	Loop, %samples% {
		y := yTop
		Loop, %samples% {
			PixelGetColor, colorProbe, x, y , RGB
			blackCounter := blackCounter + isBlack(colorProbe)
			; Move to next Y point
			y := y + yStep
		}
		; Move to next X point
		x := x + xStep
	}
	if (blackCounter > Floor(samples*samples/2)) {
		return "white"
	} else {
		return "black"
	}
} */

	;scaleColor := getScaleColor(xBarOut - halfBar, yBarOut - 30 ,xBarOut + halfBar, yBarOut + 30)

/* setColorInMenu(scaleColor) {
	WinWait, Scale
	
 	ControlFocus, WindowsForms10.COMBOBOX.app.0.1ca0192_r6_ad14, Scale, , , 
	Sleep 500
	Control, ShowDropDown, , WindowsForms10.COMBOBOX.app.0.1ca0192_r6_ad14, Scale, , , 
	Sleep 500

	if(scaleColor = "black") {
		pos := 1
	} else {
		pos := 2
	}

	Control, Choose, %pos%, WindowsForms10.COMBOBOX.app.0.1ca0192_r6_ad14, Scale, , ,  ; 1: black, 2 = white Scale Bar.
	Sleep 500
	
	;--------------------
	;select Number Color in menu
	
	ControlFocus, WindowsForms10.COMBOBOX.app.0.1ca0192_r6_ad13, Scale, , , 
	Sleep 500
	Control, ShowDropDown, , WindowsForms10.COMBOBOX.app.0.1ca0192_r6_ad13, 
	Sleep 500
	
	if(scaleColor = "black") {
		pos := 1
	} else {
		pos := 2
	}

	Control, Choose, %pos%, WindowsForms10.COMBOBOX.app.0.1ca0192_r6_ad13, Scale, , ,  ; 1: black, 2 = white Scale Bar.
	Sleep 500	
}	 */
	




	
