
runPost(inputDir, outputDir, options, imageInfo) {

	; Rename fields: short and case-sensitive names when printing
	nameMap := {}
	nameMap["date"] := "Acquisition date"
	nameMap["objective lens in use"] := "Objective lens"
	nameMap["exposure time"] := "Channel and exposure time"
	; Keys renamed to empty "" are suppressed from printing
	nameMap["calibration"] := ""
	nameMap["imageWum"] := ""
	nameMap["imageHum"] := ""

	; Write imageInfo to a text file
	metadataFile := inputDir "\imageInfo.txt"
	file := FileOpen(metadataFile, "w")
	file.Enconding := "UTF-16"
	file.Write(printDictToString(options["metaBanner"], imageInfo, nameMap))
	file.Close()

	; calibration (um/px)
	; imageW (px)
	; imageWum = px * um/px = um
	imageWum := imageInfo["imageWum"]
	pattern := ".tif"

	; If you have an opened instance of ImageJ while running this script, you may
	; encounter a problem where ImageJ will try to run the script in that instance
	; instead of using a new (separate) instance.
	;
	; To resolve that, open ImageJ and uncheck:
	;   Edit --> Options --> Misc --> Run single instance listener
	;
	; Once that is done, multiple ImageJ can be run on the same machine.

	; Create the command line for imageJ
	pythonScript := options["scriptDir"] "\imagej\postprocess.py"
	cmd := options["imageJ"] " --console --headless --run """ pythonScript """ ""xwidth=" imageWum ", indir='" inputDir "', outdir='" inputDir "', pattern='" pattern "', metadataFile='" metadataFile "'"""
	
	; RunWait will wait until imageJ quits
	; MsgBox Launching ImageJ with command: %cmd%
	RunWait %ComSpec% /c "%cmd%"
	sleep 2000
	
	; Remove the temporary text file
	FileDelete %metadataFile%
	
	; Move all files from input to output
	; MsgBox Moving from %inputDir% to %outputDir%
	Loop, %inputDir%\*.*
	{
		src := A_LoopFileLongPath
		dest := outputDir "\" A_LoopFileName
		FileMove, %src%, %dest%, 1
	}
	
	return true
} 