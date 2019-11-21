;addScaleBar(calibration, imageW, imageH, zoom, options){
addScaleBar(calibration, imageW, imageH, zoom, options){
	;@ Window Analyzer
	
	; Constants for canvas corner
	constX := 10
	constY := 185
	
	; Set variables according to the calibration
	barLength := chooseBarLength(imageW, calibration, options["scaleLength"])
	
	calculateBarPos(barLength, calibration, imageW, imageH, zoom, constX, constY, xBarIn, xBarOut, yBarIn, yBarOut,	xNumIn, xNumOut, yNumIn, yNumOut)
	
	; Get the scale color by checking the colors around the xBarOut, yBarOut
	barLengthPx := zoom * (barLength / calibration)
	;MsgBox, barLengthPx = %barLengthPx%, barLength = %barLength%, calibration = %calibration%
	barColor := getScaleColor(xBarOut - barLengthPx/2, xBarOut + barLengthPx/2, yBarOut - 20, yBarOut )
	
;@ Window Scale
		;Alt + i opens Insert menu.
    Send !i								
    Sleep 500

	;S opens Scale bar window from open Insert menu.
    Send s								
    Sleep 500
	
	setBarLengthInMenu(barLength)
	setColorInMenu(barColor)
	
	;MsgBox, "Closing Scale Window"
	Sleep 500
	
	; Close Scale window
	Send {Enter}
	Sleep 500

	
;@ Window Analyzer

	WinWait, BZ-X800 Analyzer, , 5, , 
	
	moveScale(xBarIn, xBarOut, yBarIn, yBarOut, xNumIn, xNumOut, yNumIn, yNumOut)
	burnScale()
	
}