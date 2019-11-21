#@ Float xwidth
#@ String indir
#@ String outdir
#@ String pattern
#@ String metadataFile
""" ImageJ batch script in Python to
    1. add spatial calibration to images from microscope
    2. convert stack to RGB color channels to reduce file size
"""

# Imports
import os
import time
from ij import IJ
from ij.plugin import RGBStackConverter
from ij.measure import Calibration

# Auxiliary functions
def convertStackToRGB(img):
    """ Convert individual color layers to a single RGB composite
    """
    try:
        RGBStackConverter.convertToRGB(img)
    except:
        pass
    return img

def setSpatialCalibration(img, xwidth, unit="micron"):
    """ img is an image object from openImage()
        xwidth is the width of the image in units (default micron)
    """
    if xwidth <= 0:
        # If spatial calibration is not given. Do not try to set it.
        return
    pixelSize = xwidth / (1.0*img.getWidth())
    cal = Calibration(img)
    cal.pixelWidth = pixelSize
    cal.pixelHeight = pixelSize
    cal.setUnit(unit)
    img.setCalibration(cal)
    return img

def readTextFile(file):
    text = ""
    try:
        # Read text content
        fid = open(file)
        text = fid.read()
        fid.close()
    except e:
        print "Error: reading text file: %s" % (e)
    return text

def appendMetadata(img, newHeader):
    """ Put the text from metadataFile in the "Info" field of img
    """ 
    # Append to existing content
    oldHeader = img.getInfoProperty()
    if oldHeader is not None:
        newHeader = oldHeader + "\n" + newHeader
    img.setProperty("Info", newHeader)
    return

def matchPatten(filename, pattern):
    """ Return true if the file matches the pattern
    """
    return (f.endswith(pattern))


# Main loop
t0 = time.time()
print "#------------------------------------------------"
print "# Converting stack to RGB and setting spatial scale"
print "# Parameters:"
print "#    image width (um) = %g" % (xwidth)
print "#    file pattern = %s" % (pattern)
print "#    input dir  = %s" % (indir)
print "#    output dir = %s" % (outdir)
print "#    metadata file = %s" % (metadataFile)
print "#------------------------------------------------"

# Print the metadata on the screen
metaText = readTextFile(metadataFile)
if (metaText != ""):
    print "# Metadata information:\n"
    print metaText
    print "#------------------------------------------------"

# Create the output directory
if not os.path.exists(outdir):
    os.makedirs(outdir)

# Loop through all files in input dir
for f in os.listdir(indir):
    if matchPatten(f, pattern):
        # Open file
        print "Processing: %s" % (f)
        inputFile = os.path.join(indir, f)
        print "    Reading file: %s" % (inputFile)
        img = IJ.openImage(inputFile)
        # Process image
        convertStackToRGB(img)
        setSpatialCalibration(img, xwidth)
        appendMetadata(img, metaText)
        # Write file
        outputFile = os.path.join(outdir, f)
        print "    Writing file: %s" % (outputFile)
        IJ.save(img, outputFile)
        print ""
        

# Done
t1 = time.time()
print "# Completed processing: %gs" % (t1-t0)
print "# Waiting for ImageJ to close ..."
print "#------------------------------------------------"
IJ.run("Quit")