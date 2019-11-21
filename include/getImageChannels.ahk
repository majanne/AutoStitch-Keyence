;;
;; Function to return the image channels in order
;;
getImageChannels(ByRef imageInfo) {
	;@ Window Load a Group.

	SetKeyDelay, 40, 1
	Clipboard :=

	;get Lens and CH info
	ControlFocus, WindowsForms10.Window.8.app.0.1ca0192_r6_ad12, Load a Group., , , 
	Sleep 300

	;=> Click on "Place" to activate correct location for tabbing
	CoordMode, Mouse, Client
	CoordMode, Pixel, Client
	Click 388, 737
	Sleep 100
	; Go to upper left. It should be the "Place" field
	Send {Up 10}
	Send {Left 2}
	Send ^c
	ClipWait
	content := Clipboard
	Clipboard :=
	if (content != "Place") {
		MsgBox "Error retrieving information from table"
		ExitApp
	}
	
	; Now copy all the fields in the metaData dictionary
	; Keys are always converted to lower case
	metaData := {}
	StringLower, key, content
	prevKey := ""
	while (prevKey != key) {
		prevKey := key
		if (key != "") {
			Send {Right}
			Clipboard :=
			Send ^c
			ClipWait
			value := Clipboard
			metaData[key] := value
			Send {Left}
		}
		Send {Down}
		Clipboard :=
		Send ^c
		ClipWait
		content := Clipboard
		StringLower, key, content
	}
	
	; Test for mandatory fields
	if (not metadata.hasKey("exposure time")) {
		MsgBox "Error retrieving channel information from table"
		ExitApp
	}
	
	; Exports fields that are declared in imageInfo
	For key, value in metadata {
		if (imageInfo.hasKey(key)) {
			imageInfo[key] := value
		}
	}
	
	; Order and map channels
	channelExposure := metadata["exposure time"]
	channelExposure := StrSplit(channelExposure, ",", " ")
	channels := []
	Loop % channelExposure.MaxIndex() {
		v := channelExposure[A_Index]
		if (InStr(v, "CH1")) {
			channels.Push("dapi")
		} else if(InStr(v, "CH2")) {
			channels.Push("gfp")
		} else if (InStr(v, "CH3")) {
			channels.Push("rfp")
		} else if (InStr(v, "CH4")) {
			channels.Push("bf")
		} else {
			MsgBox, , Error, The program does not know what this channel is: "%v%"
		}
	}
	; Add overlay if list is larger than one
	if (channels.MaxIndex() > 1) {
		channels.push("ovly")
	}
	; Reverse the list, storing it in allChannels
	allChannels := []
	sz := channels.MaxIndex()
	Loop % sz {
		i := A_Index
		v := channels[sz + 1 - i]
		allChannels.Push(v)
	}
	
	; Check/uncheck the overlay checkbox
	hasOverlay := isInList("ovly", channels)
	PixelGetColor, checkColor, 1150, 47 , Slow RGB
	isChecked := (checkColor != 0xFFFFFF)
	if (not isChecked and hasOverlay) {
		click 1150, 47
		sleep 2500
		; MsgBox "Checked"
	} else if (isChecked and not hasOverlay) {
		click 1150, 47
		sleep 2500
		; MsgBox "Unchecked"
	} else {
		; Nothing to do
		; MsgBox "Already in right state"
	}
	sleep 1000
	
	return allChannels
}