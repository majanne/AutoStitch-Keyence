
;; Print the contents of the options dictionary to Notepad
printOptions(options) {
	Send Application options
	Send {Enter}
	sleep 50
	For key, value in options {
		Send {Space}   %key% = %value%
		Send {Enter}
	}	
	return
}

;; Print the contents of the options dictionary to Notepad
printDictToString(title, ByRef dict, ByRef nameMap, separator:=":") {
	txt := title
	For key, value in dict {
		if (nameMap.hasKey(key)) {
			key := nameMap[key]
			if (key = "") {
				; Skip keys that are hidden
				continue
			}
		}
		txt := txt "`n" key " " separator " " value
	}	
	return txt
}

;; Return true if the group file exists in the current path
checkGroupFileExists(inputDirPath, currentName) {
	pattern := inputDirPath . "\" .currentName
	exist := FileExist(pattern)
	if (exist == "") {
		return false
	} else {
		return true
	}
}

;; Returns true if the searchName is in the options list
;; Example:
;;   userChannels := StrSplit(options["channels"], "," , " ")
;;   if ( isInList("ovly", userChannels) {
;;       do something
;;   } 
isInList(searchName, optionsList) {
	;; Loop over user channels, looking whether a specific name is in
	selected := false
	for i, key in optionsList {
		if (key = searchName) {
			selected := true
		}
	}
	return selected
}

;; Returns the index of a value in a list
;; Example:
;;   userChannels := StrSplit(options["channels"], "," , " ")
;;   if ( isInList("ovly", userChannels) {
;;       do something
;;   } 
indexInList(searchName, optionsList) {
	;; Loop over user channels, looking whether a specific name is in
	index := -1
	for i, key in optionsList {
		if (key = searchName) {
			index := i
		}
	}
	return index
}

;; Paste content to clipboard
sendClipboard(text) {
	Clipboard := 
	Clipboard := text
	ClipWait
	Send ^v
	Sleep 500
	Clipboard := 
}

;; Splits the name
;;
;;
;;
formatFilename(prefix, suffix, separator, useShortName) {
	; First call with empty prefix
	if (prefix = "") {
		return suffix
	}
	
	; If short name is used we trim the prefix to the last separator
	; Example:
	;    prefix = "abc__def" becomes "def"
	if (useShortName = true or useShortName = "yes") {
		re := "^.*" . separator
		prefix := RegExReplace(prefix, re, "")
	}
	
	; The default output name is the concatenation
	outputName := prefix . separator . suffix
	 
	; Check the suffix is a slide and try to format
	slideNames := ["XY01", "XY02", "XY03"]
	isSlide := isInList(suffix, slideNames)
	hasHash := InStr(prefix, "#")
	formatted := false
	
	if (isSlide and hasHash and not formatted) {
		; Try to substitute the #<name1>#<name2>
		re := "O)((#[^#]+)+)"
		foundPos := RegExMatch(prefix, re, subPat)
		if (foundPos > 0) {
			userList := StrSplit(SubStr(subPat.Value(1), 2), "#")
			slideIndex := indexInList(suffix, slideNames)
			if (slideIndex <= userList.MaxIndex()) {
				userIndex := userList[slideIndex]
				outputName := RegExReplace(prefix, re, "_"userIndex, 0, 1, foundPos)
				formatted := true
			}
		}
	}
	if (isSlide and not formatted) {
		; At least change XY01 to slide1
		slideIndex := indexInList(suffix, slideNames)
		suffix := "slide" . slideIndex
		outputName := prefix . "_" . suffix
		formatted := true
	}
	
	; Return the formatted name
	return outputName
}

;MsgBox % "T0 " formatFileName("home__col0_3#7#12#9", "XY01", "__", true)
;MsgBox % "T0 " formatFileName("abc__def__col0_3#7#12", "XY03", "__", true)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;/home/col0_3_7"
;MsgBox % "T1 " formatFileName("/home/col0_3#7#My_slide_2#9", "XY02")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;/home/col0_3_12"
;MsgBox % "T2 " formatFileName("/home/col0_3#7#12#9", "XY03")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;/home/col0_3_9"
;MsgBox % "T3 " formatFileName("/home/col0_3#7", "XY03")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;/home/col0_3#7_slide3"
;MsgBox % "T4 " formatFileName("/home/col0_3", "XY01")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;/home/col0_3_slide1"
;MsgBox % "T5 " formatFileName("/home/col0_3", "XY04")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;/home/col0_3_XY04"
