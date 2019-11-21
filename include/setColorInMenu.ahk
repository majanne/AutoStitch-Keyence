setColorInMenu(scaleColor) {
	WinWait, Scale
	
 	ControlFocus, WindowsForms10.COMBOBOX.app.0.1ca0192_r6_ad14, Scale, , , 
	Sleep 500
	Control, ShowDropDown, , WindowsForms10.COMBOBOX.app.0.1ca0192_r6_ad14, Scale, , , 
	Sleep 500

	if(scaleColor = "black") {
		pos := 1
	} else {
		pos := 2
	}

	Control, Choose, %pos%, WindowsForms10.COMBOBOX.app.0.1ca0192_r6_ad14, Scale, , ,  ; 1: black, 2 = white Scale Bar.
	Sleep 500
	
	;--------------------
	;select Number Color in menu
	
	ControlFocus, WindowsForms10.COMBOBOX.app.0.1ca0192_r6_ad13, Scale, , , 
	Sleep 500
	Control, ShowDropDown, , WindowsForms10.COMBOBOX.app.0.1ca0192_r6_ad13, 
	Sleep 500
	
	if(scaleColor = "black") {
		pos := 1
	} else {
		pos := 2
	}

	Control, Choose, %pos%, WindowsForms10.COMBOBOX.app.0.1ca0192_r6_ad13, Scale, , ,  ; 1: black, 2 = white Scale Bar.
	Sleep 500	
	Send {Enter}
}	