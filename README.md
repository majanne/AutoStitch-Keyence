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
When using Multi-Point acquisition, the _Capture_-window allows to enter one name (_Example: myExp_) for all three slides. The acquisition output is then stored in subfolders named XY01, XY02, XY03 if three slides where imaged, XY01, XY02 for two slides.

The Analyzer output when three slides are imaged in one run:

Folder _myExp_ containing 3 subfolders, _XY01_, _XY02_ , _XY03_.

__This script allows the user to define slide names by using _#_.__  

___Example:___
myExperiment (myExp). Slide positions XY01-3 are used. Slide names (here: Cond1-3 or Exp1-3) can be specified individually if these names are preceeded by the _#_ symbol.

__Script output:__

__Method 1.__ Common name __myExp__:
1. myExp\_slide1
2. myExp\_slide2
3. myExp\_slide3

__Method 2.__ Common and slide names __myExp#Cond1#Cond2#Cond3__:
1. myExp\_Cond1
2. myExp\_Cond2
3. myExp\_Cond3

__Method 3.__ Slide names __#myExp1#myExp2#myExp3__:
1. myExp1
2. myExp2
3. myExp3

__Error handling:__ If an unrecognized input name, e.g. the subfolder name _XY04_ appears, the slide name with Method 2 will be _myExp#Cond1#Cond2#Cond3\_XY04_.















