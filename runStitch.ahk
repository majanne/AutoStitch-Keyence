;;; Constant header
#NoEnv
#include \\pbiob-centos.salk.edu\groot-data\Tools\auto-stitch\ahkStitch.ahk


;;; Options
options := getDefaultOptions()
options["insertScale"] := false
options["compress"] := true


;;; Run where you launched
inputDir := A_WorkingDir
outputDir := A_WorkingDir "\output"
stitchFolders(inputDir, outputDir, options)


;;; Pressing ESC ends the script anytime
ExitApp
return
Esc::ExitApp
return