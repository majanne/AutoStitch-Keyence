

exportTiff(outputDirName, currentName, channel)
{
	outputFile := outputDirName "\" currentName "_" channel

	; The active window
	topId := winExist("A")

    CoordMode, Mouse, Client			;@ Makes the following mouse moves relative to the coordinates in the active window.
    Click 45, 25						;@ Left-clicks on "File" in the "BZ-X800 Wide Image Viewer" window of the overlay image
    Sleep 1000	

    Send {Tab 4}						;@ Moves to "Export in the original scale".
    Sleep 1000

    Send {Enter}						;@ Opens "Export As" window.
    Sleep 1000

	; Export dialog, OK/Cancel
	exportWinClass := "WindowsForms10.Window.8.app.0.34f5582_r6_ad1"
	WinWaitActive, ahk_class %exportWinClass%
    Send {Tab}							;@ Switches from Cancel to OK.
    Sleep 500
    Send {Enter}
    Sleep 500

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
		MsgBox "exportTiff(): Timed out waiting for save dialog to close. Exiting ..."
		ExitApp
	}
	
	
	; Wait for all windows to close
	WinWaitClose, ahk_class %exportWinId%,, 300
	if (ErrorLevel) {
		MsgBox "exportTiff(): Timed out waiting for export dialog to close. Exiting ..."
		ExitApp
	}
	
	; Close the overview Window
	WinActivate, Overview Window
	WinClose, Overview Window
	
	; Wait for the parent to be active again
	WinActivate, ahk_id %topId%
	WinWaitActive, ahk_id %topId%, , 20
}

/* 
exportBigTiff(outputDirName, currentName, channel)
{
    CoordMode, Mouse, Client			;@ Makes the following mouse moves relative to the coordinates in the active window.
    Click 45, 25						;@ Left-clicks on "File" in the "BZ-X800 Wide Image Viewer" window of the overlay image
    Sleep 1000	


    Send {Tab 4}						;@ Moves to "Export in the original scale".
    Sleep 1000

    Send {Enter}						;@ Opens "Export As" window.
    Sleep 1000

    Send {Down}							;@ Choose Big Tiff format (includes metadata).
    Sleep 500

    Send {Tab}							;@ Switches from Cancel to OK.
    Sleep 500

    Send {Enter}						;@ Opens "Save As" window.
    Sleep 500

    SendRaw %outputDirName%\%currentName%_%channel%_big.tif
    Sleep 1000

    Send {Enter}						;@ Saves Big Tiff.
    Sleep 500
} */