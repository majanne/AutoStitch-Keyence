; Given the size of the image and the scale bar,
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

	;MsgBox, barLength = %barLength%, calibration = %calibration%, imageW = %imageW%, imageH = %imageH%, constX = %constX%, constY = %constY%
	;MsgBox, xBarOut = %xBarOut% 

	;Number Pos, slightly above bar Pos.
	xNumIn := xBarIn
	yNumIn := Round (yBarIn - zoom * imageH * 0.029) ; modified in newest lab version to be lower.
	xNumOut := xBarOut
	yNumOut := Round (constY + imageH*zoom * 0.951)
	
	; Return as a dictionary
}
