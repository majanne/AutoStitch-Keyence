

saveKtf(outputDirName, currentName, channel)
{

;@ Window: BZ-X800 Wide Image Viewer
	
	SetKeyDelay, 40, 0
	
	BlockInput On
	
	;Click exit
	CoordMode, Mouse, Client			;@ Makes the following mouse moves relative to the coordinates in the active window.
    Click 742, 19						;@ Left-clicks on "Exit" in the "BZ-X800 Wide Image Viewer" window of the overlay image
    Sleep 2000
	
	;Pop up: send yes to save 
	
	Send y
	Sleep 2000
	BlockInput Off

		
;@ Window: Save As

	BlockInput On
   
	;Add precision to key strokes:
   	SetKeyDelay , 20, 0
	
	;Addressing the control via controlfocus allows to use simple send-commands which do more reliable keystrokes than controlsend:
	ControlFocus, Edit1, Save As
	
	Send ^a
	Sleep 500
	
	Send {Backspace}
	Sleep 500

	sendClipboard(outputDirName "\" currentName "_" channel ".ktf")	

;	SendRaw, %outputDirName%\%currentName%_%channel%.ktf
;   Sleep 1000		

	ControlFocus, Button2, Save As
	
	Send s
	Sleep 2000
	
	;Reset key stroke speed to default:
	SetKeyDelay, 10, -1
	
	BlockInput Off
}


doNotSaveKtf()
{
;@ Window: BZ-X800 Wide Image Viewer
	
	; The active window
	topId := winExist("A")
	
	SetKeyDelay, 40, 0
	BlockInput On
	
	;Click exit
	;CoordMode, Mouse, Client			;@ Makes the following mouse moves relative to the coordinates in the active window.
    ;Click 742, 19						;@ Left-clicks on "Exit" in the "BZ-X800 Wide Image Viewer" window 
    ;Sleep 2000
	WinClose, A
	
	; Wait for OK/Cancel dialog
	confirmWinClass := "#32770"
	WinWaitActive, ahk_class %confirmWinClass% , , 15
	Sleep 500
	Send n
	Sleep 500
	BlockInput Off
	
	; Wait for both windows to close
	WinWaitClose, ahk_class %confirmWinClass%, , 15
	WinWaitClose, ahk_id %topId%, , 15
}