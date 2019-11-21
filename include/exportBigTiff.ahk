
exportBigTiff(outputDirName, currentName, channel)
{
    CoordMode, Mouse, Client			;@ Makes the following mouse moves relative to the coordinates in the active window.
    Click 45, 25						;@ Left-clicks on "File" in the "BZ-X800 Wide Image Viewer" window of the overlay image
    Sleep 1000	


    Send {Tab 4}						;@ Moves to "Export in the original scale".
    Sleep 1000

    Send {Enter}						;@ Opens "Export As" window.
    Sleep 1000

    Send {Down}							;@ Choose Big Tiff format (includes metadata).
    Sleep 500

    Send {Tab}							;@ Switches from Cancel to OK.
    Sleep 500

    Send {Enter}						;@ Opens "Save As" window.
    Sleep 500

	sendClipboard(outputDirName "\" currentName "_" channel "_big.tif")
	
;   SendRaw %outputDirName%\%currentName%_%channel%_big.tif
;   Sleep 1000

    Send {Enter}						;@ Saves Big Tiff.
    Sleep 2000
}