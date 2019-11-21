
; Given the image width in um, return a bar length in um.
chooseBarLength(imageW, calibration, userBarLengthum){
	
	imageWum := imageW * calibration
	
	if (userBarLengthum = "auto" or userBarLengthum = 0) {
		if (imageWum <= 600) {
			barLength := 50
		}
		if (imageWum > 600 and <= 1000) {
			barLength := 100
		}
		if (imageWum > 1000 and <= 1500) {
			barLength := 200
		}
		if (imageWum > 1500 and <= 2500){
			barLength := 250
		}
		if (imageWum > 2500 and <= 10000) {
			barLength := 500
		}
		if (imageWum > 10000) {
			barLength := 1000 
		} 
	} else {
		barLength := userBarLengthum
	}
	
	return barLength
}