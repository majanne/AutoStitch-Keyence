

closeImage()
{

;@Window: BZ-X800 Analyzer	
	topId := WinExist("A") 
	Sleep 500
    Send !f						
    Sleep 500
    Send c
    Sleep 2000
	WinWaitActive, ahk_id %topId%
}
