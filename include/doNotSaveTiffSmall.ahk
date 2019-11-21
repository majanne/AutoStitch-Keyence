;when only jpg, not tiff is saved, tiffs need to be closed individually
doNotSaveTiffSmall(){

	; The active window
	winId := winExist("A")
	
	; Send the close sequence (alt+f, c)
	Sleep 500
	Send !f
	Sleep 500
	Send c
	Sleep 1000
	
	; Yes/No dialog
	winWaitActive, "ahk_class #32770"
	Sleep 500
	Send n
	
	WinWaitClose, ahk_class %winId%

}
