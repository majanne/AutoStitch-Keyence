## What the script does ##

* Stitch image folders that contain a .gci file using Keyence BZ-X800 Analyzer and Wide Image Viewer software.
* Output: The stitched acquisition in uncompressed and compressed tifs. 
* Reduce image size by up to 50% using Fiji/ ImageJ, _Color, Stack to RGB_.
* Add metric information (image width in microns) to the output image using Fiji/ ImageJ, _Analyze, Set Scale_.
* Compress a copy of the raw image folders.

## Software requirements ##

* [Autohotkey](https://www.autohotkey.com/) (Open source) 
* [Keyence Analyzer Analysis Software](https://www.keyence.com/landing/microscope/lp_fluorescence.jsp) (Proprietary)
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

* The order of the channels during acquisition defines the output name. The output of CH1 is generated first, in our setting that image name will be output_dapi.tif.
* Channel dependent extensions and overlay: CH1, \_dapi; CH2, \_gfp; CH3, \_rfp; CH4, \_bf; Overlay, \_ovly
* Uncompressed and compressed tifs, _.tif_ and _\_small.tif_, respectively

### Multi-Point name handling ###

The microscope allows the user to image up to three slides in one run (Multi-Point acquisition).
When using Multi-Point acquisition, however, only one common name can be entered in the Capture-window (example: myExp).  
The Analyzer output for three slides that are imaged together is the following:  
A folder _myExp_ that contains up to three subfolders, _XY01_, _XY02_, _XY03_. The names XY01-3 correspond to the position of the slides in the slide holder.

__This script allows the user to define up to three slide names by using _#_.__  

___Example:___
Slide positions XY01-3 are used. Slide names can be specified individually if these names are preceeded by the _#_ symbol.

__Script output for three imaged slides, example shown for slide 2:__

__Input option 1.__ Common name entered, __myExp__. Output for slide 2: __myExp\_slide2__  
__Input option 2.__ Common and slide names entered, __myExp#Cond1#Cond2#Cond3__. Output for slide 2: __myExp\_Cond2__  
__Input option 3.__ Slide names entered, __#Apples#Pears#Oranges__. Output for slide 2: __Pears__  

__Error handling:__ If an unrecognized input name, e.g. the subfolder name _XY04_ appears, the output name generated with _Input option 2_ would be _myExp#Cond1#Cond2#Cond3\_XY04_.

## Preparations for script use ##

To stitch images with this script the Keyence BZ-X800 Analyzer software needs to be installed, including the locally plugged USB dongle that enables Keyence's stitching add-on. If the installation is for some reason incomplete, the _Load a Group_ button will not respond and stitching is not possible. 
Autohotkey and Fiji/ ImageJ need to be installed.

Proposed set up: 
*On your server, in the Tools folder, create the folder auto-stitch and paste the ....
*Create a folder on the Desktop named _AutoStitch Information_. Enter there the xxx file and the short README file for the user.















