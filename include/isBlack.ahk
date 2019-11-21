isBlack(rgbColor) {
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
}