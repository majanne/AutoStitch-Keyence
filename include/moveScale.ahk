moveScale(xBarIn, xBarOut, yBarIn, yBarOut, xNumIn, xNumOut, yNumIn, yNumOut){

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
