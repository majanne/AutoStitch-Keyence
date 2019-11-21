
;Save 48bit-tiff:	
saveTiffSmall(outputDirName, currentName, channel, topWinId)
{
	outputFile := outputDirName "\" currentName "_" channel "_small"
	
	; Save current text for comparison. Save is done when it changes
	WinGetText, allText, ahk_id %topWinId%
	pos := RegexMatch(allText, "is)(.*)Image Book.*", match)
	textStart := match1
	
	;@ Window: BZ-X8000 Analyzer
	; "alt+f" + "a" to save as:
	SetKeyDelay, 40, 0
    Send !f
    Sleep 500
    Send a
	
	; Wait for Save dialog
	WinWaitActive, Save As, , 15,
	WinActivate, Save As
	sleep 500
	saveWinId := WinExist("A")

	;Sequence to send filename
	ControlFocus, Edit1, ahk_id %saveWinId%,
	Sleep 500
	ControlSetText, Edit1, %outputFile%, ahk_id %saveWinId%, 

	; Clicking Save
	ControlFocus, Button2, ahk_id %saveWinId%,
	Sleep 500
	ControlGetText, buttonText, Button2, ahk_id %saveWinId%,
	if (buttonText != "&Save") {
		MsgBox "saveTiffSmall(): Could not find save button. Exiting ..."
		ExitApp
	}
	Send {Enter}
	Sleep 500
	
	WinWaitClose, ahk_id %saveWinId%,, 120
	if (ErrorLevel) {
		MsgBox "saveTiffSmall(): Timed out waiting for save dialog to close. Exiting ..."
		ExitApp
	}
	WinWaitActive, ahk_id %topWinId%, , 5
	WinActivate, ahk_id %topWinId%
	
	; Wait for save to conclude
	sleep 1000
	
	; Wait until the text changes
	WinGetText, allText, ahk_id %topWinId%
	pos := RegexMatch(allText, "is)(.*)Image Book.*", match)
	textEnd := match1
	maxRetry := 120
	while (textStart = textEnd and maxRetry > 0) {
		maxRetry := maxRetry - 1
		sleep 1000
		WinActivate, ahk_id %topWinId%
		WinGetText, allText, ahk_id %topWinId%
		pos := RegexMatch(allText, "is)(.*)Image Book.*", match)
		textEnd := match1
	}
	
	; Wait a little more to make sure the window is responsive
	sleep 3000
	
	; MsgBox, Start text = %textStart%`nEnd text = %textEnd%
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


