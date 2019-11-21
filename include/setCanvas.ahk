


setCanvas(){
;@ Window: Keyence Analyzer

	WinWait, BZ-X8000 Analyzer, , 5, , 

	Send !v
	Sleep 500

	Send o
	Sleep 500
	
    ;validate at default Pos, x 0.1 
	Send {Enter} 
	Sleep 500
}