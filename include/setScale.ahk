
; Given the image width in um, return a bar length in um.
/* chooseBarLength(imageW, calibration, userBarLengthum){
	
	imageWum := imageW * calibration
	
	if (userBarLengthum = "auto" or userBarLengthum = 0) {
		if (imageWum <= 600) {
			barLength := 50
		}
		if (imageWum > 600 and <= 1000) {
			barLength := 100
		}
		if (imageWum > 1000 and <= 1500) {
			barLength := 200
		}
		if (imageWum > 1500 and <= 2500){
			barLength := 250
		}
		if (imageWum > 2500 and <= 10000) {
			barLength := 500
		}
		if (imageWum > 10000) {
			barLength := 1000 
		} 
	} else {
		barLength := userBarLengthum
	}
	
	return barLength
} */


/* ;;;;@ copied out of block above

calculateImageWum(imageW, calibration){

	imageWum := imageW * calibration
	
	return imageWum
}	
	calibration := 
	barLength := 1000
 */

/* ; Given a bar length in um, set in menu
setBarLengthInMenu(barLength){


	ControlFocus, WindowsForms10.BUTTON.app.0.1ca0192_r6_ad19, Scale, , , 
	Sleep 500
	
	CoordMode, Mouse, Client		
	Click, 85, 22
	Sleep 500
	
	ControlFocus, Edit1, Scale
	Sleep 500
	SendRaw %barLength%
	Sleep 500
} */


/* ; Given the size of the image and the scale bar,
; compute the input and output positions of the scale bar and number
;
; The computed values are set in the arguments passed ByRef.
calculateBarPos(barLength, calibration, imageW, imageH, zoom, constX, constY, ByRef xBarIn, ByRef xBarOut, ByRef yBarIn, ByRef yBarOut,	ByRef xNumIn, ByRef xNumOut, ByRef yNumIn, ByRef yNumOut){

	;Bar center (xBarIn, yBarIn) = canvas center
	halfBar := 0.5 * barLength / calibration
	
	;Bar Pos.
	xBarIn  := constX + Round(zoom * (0.5 * imageW))
	yBarIn  := constY + Round(zoom * (0.5 * imageH))
	;move bar to lower right, 3% dist to image border
	xBarOut := constX + Round(zoom * (0.97 * imageW - halfBar)) 
	yBarOut := constY + Round(zoom * (0.98 * imageH))
	
	MsgBox, xBarOut = %xBarOut% 

	;Number Pos, slightly above bar Pos.
	xNumIn := xBarIn
	yNumIn := Round (yBarIn - zoom * imageH * 0.029) ; modified in newest lab version to be lower.
	xNumOut := xBarOut
	yNumOut := Round (constY + imageH*zoom * 0.951)
	
	; Return as a dictionary
}
 */

/* ;addScaleBar(calibration, imageW, imageH, zoom, options){
addScaleBar(calibration, imageW, imageH, zoom, options){
	;@ Window Analyzer
	
	; Constants for canvas corner
	constX := 10
	constY := 185
	
	; Set variables according to the calibration
;	barLength := chooseBarLength(imageW, calibration, option["scaleLength"])
	
	calculateBarPos(barLength, calibration, imageW, imageH, zoom, constX, constY, xBarIn, xBarOut, yBarIn, yBarOut,	xNumIn, xNumOut, yNumIn, yNumOut)
	
	; Get the scale color by checking the colors around the xBarOut, yBarOut
	barLengthPx := barLength * calibration
	barColor := getScaleColor(xBarOut - barLengthPx/2, xBarOut + barLengthPx/2, yBarOut - 30, yBarOut + 30 )
	
;@ Window Scale
		;Alt + i opens Insert menu.
    Send !i								
    Sleep 500

	;S opens Scale bar window from open Insert menu.
    Send s								
    Sleep 500
	
	setBarLengthInMenu(barLength)
	setColorInMenu(barColor)
	
	; Close Scale window
	Send {Enter}
	Sleep 500

	
;@ Window Analyzer

	WinWait, BZ-X800 Analyzer, , 5, , 
	
	moveScale(xBarIn, xBarOut, yBarIn, yBarOut, xNumIn, xNumOut, yNumIn, yNumOut)
	burnScale()
	
} */



/* confirmScaleOptions(){	
	ControlFocus, WindowsForms10.BUTTON.app.0.1ca0192_r6_ad13, Scale, , , 
 	Sleep 500	
	
	CoordMode, Mouse, Client
	Click, 120, 345
 	Sleep 500
}	
 */

/* moveScale(xBarIn, xBarOut, yBarIn, yBarOut, xNumIn, xNumOut, yNumIn, yNumOut){

;@ Window: BZ-X800 Analyzer
	
	WinWait, BZ-X800 Analyzer

	;BlockInput On 	;Use with SendEvent, preferable to MouseClickDrag but did not work before.

	SetMouseDelay, 20, 1

	;Click in upper left of canvas to make sure it is active.
	CoordMode, Mouse, Client
	Click 15, 195 
	Sleep 1000

	;@ Bar Move:
	MouseClickDrag, Left, xBarIn, yBarIn, xBarOut, yBarOut, 100,
	Sleep 2000

	;@ Number Move:
	MouseClickDrag, Left, xNumIn, yNumIn, xNumOut, yNumOut, 100
	Sleep 2000

	SetMouseDelay -1
	;BlockInput Off
}
 */

	;(Move Scale)	
	;--------------------

/* burnScale(){	
	SetKeyDelay 20, 0

	;open Insert menu	
    Send !i							
    Sleep 1000

	;confirm scale bar
    Send w								
    Sleep 1000
} */
