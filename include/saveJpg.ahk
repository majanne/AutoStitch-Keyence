

saveJpg(outputDirName, currentName, channel)
{

;@Window: BZ-X800 Analyzer
	WinWait, BZ-X800 Analyzer, , 5, ,

    Send !f							;@ Alt + F opens File menu in Analyzer window
    Sleep 500

    Send a						    	;@ Opens "Save As" window from open File menu.
	
;@ Window: Save As	
	WinWait, Save As, , 5, , 

	;Sequence to send filename
	ControlFocus, Edit1, Save As, , , 
	Sleep 1000

	Send ^a
	Sleep 500

	Send {Backspace}
	Sleep 500

	sendClipboard(outputDirName "\" currentName "_"channel ".jpg")

    ;SendRaw %outputDirName%\%currentName%_%channel%.jpg
    ;Sleep 1000

	;Sequence to select .jpg
	ControlFocus, ComboBox2, Save As, , , 
	Sleep 1000

	Control, ShowDropDown, , ComboBox2, Save As, , , 
	Sleep 1000

	Control, Choose, 2, ComboBox2, Save As, , ,  ; 2 = jpg pos in list
	Sleep 1000

	ControlFocus, Button2, Save As, , , 
	Sleep 1000

	Send !s
	Sleep 1000
	
	;Accept loss of information for .jpg
	Send {Enter}
	Sleep 1000
	
}