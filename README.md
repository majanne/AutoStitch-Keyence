## What the script does ##

* Stitch image folders that contain a .gci file with Keyence BZ-X800 Analyzer and Wide Image Viewer software.
* Generated output: The stitched acquisition in an uncompressed and compressed tif. 
* Reduce image size by up to 50% with Fiji/ ImageJ via _Color, Stack to RGB_.
* Add metric information (image width in microns) to the output image with Fiji/ ImageJ via _Analyze, Set Scale_.
* Compress a copy of the raw image folders.

## Software requirements ##

* [Autohotkey](https://www.autohotkey.com/) (Open source) 
* [Keyence Analyzer Analysis Software](https://www.keyence.com/landing/microscope/lp_fluorescence.jsp) (Proprietory)
* [Fiji/ ImageJ](https://imagej.net/Fiji) (Open source)

## Acquisition conditions ##

* Microscope: Keyence BZ series
* Software: BZ-X800 Viewer
* Image type: Still image
* Sample holder: Slide
* Channels: CH1, DAPI; CH2, GFP; CH3, RFP; CH4, Brightfield. Modifiable in the script or via microscope set up
* Overlay: Deactivated, later generated with the Analyzer software if more than one channel was used for acquisition.
* Capture method: Multi-Color (Single color can be acquired via _Multi-Color_ setting)
* Capture area settings: Multi-Point supported


## File name handling ##

* The order of the channels defines the output name. The output of CH1 is generated first, in our setting that image name will be output_dapi.tif.
* Channel dependent extensions and overlay: CH1, \_dapi; CH2, \_gfp; CH3, \_rfp; CH4, \_bf; Overlay, \_ovly
* Uncompressed and compressed tif: _.tif_ and _\_small.tif_, respectively

#### Multi-Point name handling #### 

The Keyence Slide Scanning Microscope allows to image up to three slides in one run (Multi-Point acquisition).
When using Multi-Point acquisition, the _Capture_-window allows to enter one name (here: myExp) for all three slides.  
The Analyzer output for three slides imaged in one run is the following:  
A folder _myExp_ that contains up to three subfolders, _XY01_, _XY02_ , _XY03_. The names XY01-3 correspond to the positions of the slides in the slide holder.

__This script allows the user to define up to three slide names by using _#_.__  

___Example:___
Slide positions XY01-3 are used. Slide names can be specified individually if these names are preceeded by the _#_ symbol.

__Script output for three imaged slides, example shown for slide 2:__

__Input option 1.__ Common name __myExp__ given, output for slide 2: __myExp\_slide2__  
__Input option 2.__ Common and slide names __myExp#Cond1#Cond2#Cond3__ given, output for slide 2: __myExp\_Cond2__  
__Input option 3.__ Slide names __#Apples#Pears#Oranges__ given, output for slide 2: __Pears__  

__Error handling:__ If an unrecognized input name, e.g. the subfolder name _XY04_ appears, the output name generated with Input option 2 would be _myExp#Cond1#Cond2#Cond3\_XY04_.















