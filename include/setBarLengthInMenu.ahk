; Given a bar length in um, set in menu
setBarLengthInMenu(barLength){


	ControlFocus, WindowsForms10.BUTTON.app.0.1ca0192_r6_ad19, Scale, , , 
	Sleep 500
	
	CoordMode, Mouse, Client		
	Click, 85, 22
	Sleep 500
	
	ControlFocus, Edit1, Scale
	Sleep 500
	

	sendClipboard(barLength)	
;	SendRaw %barLength%
;	Sleep 500
}