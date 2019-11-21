

getImageSize(){
	
	topId := WinExist("A")
	
	;empty clipboard
	Clipboard :=  
	
;@Window: BZ-X800 Analyzer
	SetKeyDelay, 40, 0

	Send !m ;@ Opens the Analyzer Measure menu.
	Sleep 500

	Send r ;@ Opens the Image properties window.
	Sleep 500
	
;@Window: Photo Properties
	WinWaitActive, Photo Properties

	;move to image size
	Send {Tab 4} 
	Sleep 250

	;copy image size
	Send ^c 
	Sleep 250
	
	;wait for the Clipboard to contain the image size
	ClipWait
	
	;associate image size with variable
	ImageSize := Clipboard 
	Sleep 250
		
	;use "x" as the delimiter to separate x and y values, eg. 100x150 into the array imageWH, pos1= 100 or imageW, pos2= 150 or imageH
	imageWH := StrSplit(ImageSize, "x", " ")	
	
	;close Photo Properties window
	ControlFocus, WindowsForms10.BUTTON.app.0.1ca0192_r6_ad11, Photo Properties, , , 
	Sleep 250
	
	Coordmode, Mouse, Client
	Click, 230, 400
	Sleep 250
	WinWaitClose, PhotoProperties
	
	WinWaitActive, ahk_id %topId%

	return imageWH
}
