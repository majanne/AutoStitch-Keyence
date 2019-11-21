
;Save 48bit-tiff:	
saveTiffSmall(outputDirName, currentName, channel) 
{
;@ Window: BZ-X8000 Analyzer
	topId := WinExist("A")
	
	SetKeyDelay, 20, 0

    Send !f							;@ Alt + F opens File menu in Analyzer window
    Sleep 500
    Send s						    	;@ Opens "Save As" window from open File menu.
	
	WinWaitActive, Save As, , 5, , 

;@ Window: Save As

	;Sequence to send filename
	ControlFocus, Edit1, Save As, , , 
	Sleep 1000
	Send ^a
	Send {Backspace}
	sendClipboard(outputDirName "\" currentName "_" channel "_small")

	ControlFocus, Button2, Save As, , , 
	Sleep 1000
	Send !s
	Sleep 1000
	WinWaitClose, Save As
	WinWaitActive, ahk_id %topId%
}


/* ;when only jpg, not tiff is saved, tiffs need to be closed individually
doNotSaveTiffSmall(){

	Send !f
	Sleep 500

	Send c
	Sleep 500
	
	Send n
	Sleep 500

} */


