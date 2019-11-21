

exportTiff(outputDirName, currentName, channel)
{
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

	; Wait for save as. Paste file name and hit enter
	WinWaitActive, Save As
	saveasWinId := winExist("A")
	sleep 500
	sendClipboard(outputDirName "\" currentName "_" channel)
    Send {Enter}						
    Sleep 2000
	
	; Wait for all windows to close
	WinWaitClose, ahk_id %saveasWinId%
	WinWaitClose, ahk_class %exportWinId%
	
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