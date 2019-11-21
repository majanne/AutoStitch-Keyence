

closeImage(topWinId)
{
	;@Window: BZ-X800 Analyzer	
	WinActivate, ahk_id %topWinId%
	WinWaitActive, ahk_id %topWinId%, , 10
	
	; Save current text for comparison. Save is done when it changes
	pos := 0
	textStart := ""
	maxRetry := 120
	if (pos = 0 and maxRetry > 0) {
		maxRetry := maxRetry - 1
		sleep 5000
		; Reactivate the window
		WinActivate, ahk_id %topWinId%
		WinWaitActive, ahk_id %topWinId%, , 30
		; Get its text
		WinGetText, allText, ahk_id %topWinId%
		pos := RegexMatch(allText, "is)(.*)Image Book.*", match)
		textStart := match1
	}
	
	; MsgBox, Start text = %textStart%
	
	SetKeyDelay, 40, 0
	Sleep 1000
    Send !f					
    Sleep 1000
    Send c
    Sleep 2000
	
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
	
	; MsgBox, Start text = %textStart%`nEnd text = %textEnd%
	
	WinWaitActive, ahk_id %topWinId%, , 10
	WinActivate, ahk_id %topWinId%
}
