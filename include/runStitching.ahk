
runStitching(inputDirPath, currentName, outputDirPath, options, imageInfo) {

	; Reset all image info fields
	imageInfo["date"] := "NA"
	imageInfo["objective lens in use"] := "NA"
	imageInfo["exposure time"] := "NA"

	; Keystroke settings
	SetKeyDelay, 20, 1

	; Only run on directories with a .gci file
	hasGci := false
	Loop, Files, %inputDirPath%\*.gci
	{
		hasGci := true
	}
	if (not hasGci) {
		return false
	}

	; Verify Keyence is not already running
	if (WinExist("BZ-X800 Analyzer")) {
		MsgBox 0x10, Image Stitcher, "Keyence Analyzer is already running. Close all windows before launching script"
		ExitApp
	}	

	; Start Keyence
	Run % options["keyenceAnalyzer"], , Max
	WinWaitActive, BZ-X800 Analyzer, ,30000
	sleep 1000
	analyzerWinId := WinExist("A")
	
    ;Click Load a Group button:
	ControlFocus, WindowsForms10.BUTTON.app.0.1ca0192_r6_ad118, BZ-X800 Analyzer
	ControlClick, WindowsForms10.BUTTON.app.0.1ca0192_r6_ad118, BZ-X800 Analyzer, , LEFT, , , , NA 

;--------------------------------------------------------------------------------------
;@ Window: Load a Group.
	WinWait, Load a Group., , 5, , 
	
	; Enter the path to the input file
	ControlFocus, Edit1, Load a Group.  ; Select address bar
	Send ^a                             ; Select all text
	Sleep 500
	sendClipboard(inputDirPath)         ; Paste the input dir path
	Send {Enter}                        ; Enter will load the preview
	Sleep 3000                          ; Wait
	if (WinExist("Loading")) {
		WinWaitClose, Loading
	}
	WinWaitActive, Load a Group. , , 3000     ; Wait
	
	;Get all the image channels
	; return in the order they will be processed, overlay first
	allChannels := getImageChannels(imageInfo)
	
    ;Open the "Image stitch" window and launch the layout procedure:
	ControlClick, WindowsForms10.BUTTON.app.0.1ca0192_r6_ad118, Load a Group., , LEFT, , , , NA 
	
;--------------------------------------------------------------------------------------	
;@ Window: Image stitch
	WinWaitActive, Image Stitch, , 500, , 
	
	; This block waits until the image is loaded
	; The loading will go back and forth between active windows. We check the loading
	; is complete by verifying the top window remains active for a few seconds.
	isLoading := True
	maxWait := 900  ; In seconds (900 = 15 minutes)
	while (isLoading and maxWait > 0) {
		samples := 4
		isLoading := False
		i = 0
		while (i < samples) {
			progressWinId := "ahk_class WindowsForms10.Window.208.app.0.1ca0192_r6_ad1"
			if (WinExist(progressWinId)) {
				isLoading := True
				WinWaitClose %progressWinId%
				Break
			}
			i := i + 1
			sleep 1000
		}
		maxWait := (maxWait - samples*1)
	}
	if (maxWait == 0) {
		MsgBox Exiting app: timed out loading %inputDirPath%
		ExitApp
	} else {
		;;; MsgBox Completed Loading
	}
	
	;Select uncompressed:
	Control, Check, , WindowsForms10.BUTTON.app.0.1ca0192_r6_ad11, Image Stitch
	Sleep 1000 
	
	;Left click on Start Stitching:
	ControlClick, WindowsForms10.BUTTON.app.0.1ca0192_r6_ad16, Image Stitch, , LEFT, , , , NA 
	
	; This block waits until the image is loaded
	; The loading will go back and forth between active windows.
	; The top window will be different at each time one channel completes
	; We verify all channels are done by checking the is no progress window
	isLoading := True
	maxWait := 900  ; In seconds (900 = 15 minutes)
	while (isLoading and maxWait > 0) {
		samples := 8
		isLoading := False
		i = 0
		while (i < samples) {
			progressWinId := "ahk_class WindowsForms10.Window.208.app.0.1ca0192_r6_ad1"
			if (WinExist(progressWinId)) {
				isLoading := True
				WinWaitClose %progressWinId%
				Break
			}
			i := i + 1
			sleep 1000
		}
		maxWait := (maxWait - samples*1)
	}
	if (maxWait == 0) {
		MsgBox Exiting app: timed out loading %inputDirPath%
		ExitApp
	} else {
		;;; MsgBox Completed Stitching
	}
	
;--------------------------------------------------------------------------------------
;@ Window: BZ-X800 Wide Image Viewer
	userFormats := StrSplit(options["formats"], ",", " ")

	for i, channel in allChannels {
		; Save BifTiff ?
		sleep 2000
		WinGetTitle, currentTitle, A
		if (currentTitle = "Overview Window") {
			currentWin := WinExist("A")
			WinClose, A
			WinWaitClose, ahk_id %currentWin%, , 20
			sleep 2000
		}
		WinGetTitle, currentTitle, A
		currentWin := WinExist("A")
		if (not RegexMatch(currentTitle, "BZ-X800 Wide Image Viewer .*ktf.*")) {
			MsgBox Lost track of the image window`nCurrent window title is %currentWin%`n Exiting now.
			ExitApp
		}
		; MsgBox Processing channel %channel%, window %currentWin%
		if (isInList("BigTIFF", userFormats)) {
			exportBigTiff(outputDirPath, currentName, channel)
		}
		WinWaitActive, ahk_id %currentWin% , , 20
		; Save Tiff ?
		if (isInList("TIFF", userFormats)) {
			exportTiff(outputDirPath, currentName, channel)
		}
		WinWaitActive, ahk_id %currentWin% , , 20
		; Save KTF ?
		if (isInList("Ktf", userFormats)) {
			saveKtf(outputDirPath, currentName, channel)
		} else {
			doNotSaveKtf()
		}
		WinWaitClose, ahk_id %currentWin%, , 240
		if (ErrorLevel) {
			MsgBox, Timed out waiting for channel %channel% window to close. Window [%currentWin%], title [%currentTitle%]
			ExitApp
		}
	}

;--------------------------------------------------------------------------------------
;@ Window: Image Stitch   
	confirmStitching()			

;--------------------------------------------------------------------------------------	
;@ Window: BZ-X800 Analyzer
	WinWaitActive, ahk_id %analyzerWinId%
	
	hasSizeInfo := False
	scaleBar := options["insertScale"]
	for i, channel in allChannels {
		; For the first image, get the size
		if (hasSizeInfo = False) {
			imageWH := getImageSize()
			imageW := imageWH[1]
			imageH := imageWH[2]
			calibration := getCalibration()
			hasSizeInfo := True
			;MsgBox, imageW: %imageW%, imageH: %imageH%
			imageInfo["imageWum"] := imageW * calibration
			imageInfo["imageHum"] := imageH * calibration
			imageInfo["calibration"] := calibration
		}
	
		; Add scale bar
		scaleBar := options["insertScale"]
		if (scaleBar = "yes" or scaleBar = true){
			; Set the zoom to a known state
			zoom := 0.1
			setCanvas()
			addScaleBar(calibration, imageW, imageH, zoom, options)
		}
		; Save
		if (isInList("JPEG", userFormats)) {
			saveJpg(outputDirPath, currentName, channel)
		}
		if (isInList("TIFF compressed", userFormats)) {
			saveTiffSmall(outputDirPath, currentName, channel)
			closeImage()	
		} else {
			doNotSaveTiffSmall()			
		}
	}

	; Close the program
	WinActivate, ahk_id %analyzerWinId%
	WinWaitActive, ahk_id %analyzerWinId%
	Sleep 500
	WinClose, ahk_id %analyzerWinId%
	WinWaitClose, ahk_id %analyzerWinId%
	
	; Return true when it generated images
	return true
} 