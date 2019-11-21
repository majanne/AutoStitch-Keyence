	

confirmStitching(){	
	WinWaitActive, Image Stitch
	; MsgBox Clicking on OK button
	ControlClick, WindowsForms10.BUTTON.app.0.1ca0192_r6_ad15, Image Stitch, , LEFT, , , , NA 

	WinWaitClose, ImageStitch
	WinWaitClose, Load a Group.

	; Wait until active for 30 seconds, then force activation
    WinWaitActive BZ-X800 Analyzer, , 30000
	; MsgBox, Closed all windows and back to analyzer
	WinActivate BZ-X800 Analyzer
}

cancelStitching(){	
	WinWait, Load a Group.
	
	;No stitching output for BZ-X800 Analyzer:
	ControlClick, WindowsForms10.BUTTON.app.0.1ca0192_r6_ad16, Image Stitch, , LEFT, , , , NA 

    Sleep 1000		
}