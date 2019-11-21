

getCalibration(){

	topId := WinExist("A")

;@ Window: Keyence Analyzer

	SetKeyDelay, 40, 1	
	;empty clipboard 
	Clipboard := 

	;open Insert Menu
	Send !i								
	Sleep 500

	;open Scale window
	Send s						
	Sleep 500
	
;@ Window: Scale	
	WinWait, Scale
	
	;click on the Settings Button to open the Calibration Setting window
	ControlFocus, WindowsForms10.BUTTON.app.0.1ca0192_r6_ad11, Scale, , , 	
    Sleep 250
	
	CoordMode, Mouse, Client
	Click, 160, 310
    Sleep 250
	
;@ Window: Calibration Setting
	WinWaitActive, Calibration Setting

	ControlFocus, WindowsForms10.EDIT.app.0.1ca0192_r6_ad11, Calibration Setting, , , 
    Sleep 250

	;label ref field content
	Send ^a 
	Sleep 250
	
	;copy ref length to clipboard  
	Send ^c 
    Sleep 250

	;wait for the Clipboard to contain the ref length
	ClipWait
	
	;associate ref length with variable
	calibration := Clipboard
	Sleep 100
	
	;close the Calibration Setting window
	Send {Enter}
	Sleep 250	
	
	;close Scale window without inserting scale: TEST THIS:
	WinWaitClose, Calibration Setting

;@ Window: Scale	
	WinWaitActive, Scale
	
	CoordMode, Mouse, Client
	ControlFocus, WindowsForms10.BUTTON.app.0.1ca0192_r6_ad12, Scale, , , 

	Click, 225, 345
	Sleep 250
	
	WinWaitClose, Scale
	WinWaitActive, ahk_id %topId%
	
	return calibration
}

