;#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
global STITCH_BASE_DIR
STITCH_BASE_DIR := "<PATH_TO_INSTALL_DIR>"

; Includes cannot contain variables. Using the hardcoded install path here.
#include <PATH_TO_INSTALL_DIR>
#include include\utils.ahk
#include include\runStitching.ahk
#include include\runPost.ahk
#include include\getImageChannels.ahk
#include include\exportTiff.ahk
#include include\exportBigTiff.ahk
#include include\saveKtf.ahk
#include include\closeImage.ahk
#include include\confirmStitching.ahk
#include include\getImageSize.ahk
#include include\getCalibration.ahk
#include include\setCanvas.ahk
#include include\addScaleBar.ahk
#include include\confirmScaleOptions.ahk
#include include\moveScale.ahk
#include include\burnScale.ahk
#include include\calculateBarPos.ahk
#include include\setBarLengthInMenu.ahk
#include include\chooseBarLength.ahk
#include include\isBlack.ahk
#include include\getScaleColor.ahk
#include include\setColorInMenu.ahk
#include include\saveTiffSmall.ahk 
#include include\doNotSaveTiffSmall.ahk
#include include\saveJpg.ahk

;#include %A_ScriptDir%\include\runMockStitching.ahk
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Default options for the application
;; 
;; These are stored in a dictionary and can be accessed using:
;;   1) an assignmend knowing the name 
;;     myvar := options["key"]
;;   2) a loop over every key value
;;     For key, value in options
;;        MsgBox %key% = %value%
;;
;;  insertScale: "yes" or "no"
;;  scaleLength: <number in micrometers> or "auto", example: 10000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getDefaultOptions() {
	global STITCH_BASE_DIR
	
	; Options dictionary
	options := {}
	options["formats"] := "TIFF, TIFF compressed"
	options["insertScale"] := false
	options["scaleLength"] := 1000
	options["shortName"]   := true
	options["compress"]    := false
	
	; Binaries
	options["scriptDir"] := STITCH_BASE_DIR
	options["keyenceAnalyzer"] := "C:\Program Files\Keyence\BZ-X800\Analyzer\BZ-X800_Analyzer.exe"
	options["imageJ"] := A_MyDocuments "\fiji-imageJ\Fiji.app\ImageJ-win64.exe"
	options["gzip"] := "C:\Program Files\7-Zip\7zg.exe"
	
	; Constants
	options["metaBanner"] := "------- Auto Stitch Information -------"
	
	return %options%
}

stitchFolders(inputDir, outputDir, options) {

	title := "Image Stitcher"
	MsgBox, 0x21, %title%, Launching in %inputDir%.`nPressing ESC stops the script anytime.
	IfMsgBox Cancel
		ExitApp

	; Check binary files exist
	checkBinaries(options, ["keyenceAnalyzer", "imageJ", "gzip"])

	;@ Creates output directory in userWorkDir, eg. the folder "output" in "baohai".
	FileCreateDir %outputDir%
	; Temp directory is inside output. Remove and recreate
	tmpDir := outputDir "\tmpdir"
	FileRemoveDir %tmpDir%, 1
	FileCreateDir %tmpDir%
	
	;@ Recursively go into every sub-directory
	level := 1   ; top-level
	prefix := "" ; no prefix for top-level
	stitchFoldersRecursive(inputDir, prefix, level, outputDir, tmpDir, options)
	
	compress := options["compress"]
	if (compress = true or compress = "yes") {
		MsgBox, 0, %title%, Stitched all folders.`nCompression is enabled.`nCheck the results and delete the original folders to save space.
	} else {
		MsgBox, 0, %title%, Stitched all folders.`nCompression is disabled.`nConsider compressing the originals.
	}
}

stitchFoldersRecursive(inputDir, prefix, level, outputDir, tmpDir, options) {
	
	if (level > 4) {
		;@ Do not go more than four levels deep
		return false
	}
	
	hasOneGci := false
	Loop, %inputDir%\*, 2                ;@ Loops subDirs: "\*", only Folders: "2" (Files = "1")	
	{
		currentName := A_LoopFileName     ;@ Name needed to compose output file name.
		currentWorkDir := A_LoopFileLongPath ;@ Full input path, needed for address fields.
	
		if (currentWorkDir = outputDir or currentWorkDir = tmpDir) {
			; Do nothing and move to the next directory
			continue
		}
		
		; Compose the output file name
		outputFileName := formatFileName(prefix, currentName, "__", options["shortName"])
		
		; Call the stiching function
		imageData := {}
		FileCreateDir %tmpDir%
		hasGci := runStitching(currentWorkDir, outputFileName, tmpDir, options, imageData)
		if (hasGci) {
			; Succesfull stitching, run postprocessing
			runPost(tmpDir, outputDir, options, imageData)
		}
		FileRemoveDir %tmpDir%, 1
		
		; Set the root to process the next level of directories
		nextPrefix := outputFileName  ;@ The current file name is the next prefix
		nextLevel := level + 1        ;@ Increment the level, we go up to 4 levels deep
		;@ Output directory remains the same

		; Process the subfolders
		hasSubGci := stitchFoldersRecursive(currentWorkDir, nextPrefix, nextLevel, outputDir, tmpDir, options)
		
		; If this is level 1 and its subfolders have a gci, then zip it
		if (level = 1 and (hasGci or hasSubGci)) {
			compress := options["compress"]
			if (compress = true or compress = "yes") {
				zipFile := currentWorkDir ".zip"
				cmd := options["gzip"] " a " zipFile " " currentWorkDir
				; MsgBox Run compression %currentWorkDir%
				runWait %cmd%
			}
		}
		
		; If at least one folder in this level has a GCI, the level can be zipped
		hasOneGci := (hasOneGci or hasGci or hasSubGci)
	}
	
	return hasOneGci
}


checkBinaries(ByRef options, keys) {
	; Check all the binaries defined exist
	For i, key in keys {
		if (not options.hasKey(key)) {
			MsgBox 0x10, Image Stitcher, Program file "%key%" is not defined.
			ExitApp
		}
		file := options[key]
		if (FileExist(file) = "") {
			MsgBox 0x10, Image Stitcher, Program file "%key%" does not exist: %file%
		}
	}
	return
}
