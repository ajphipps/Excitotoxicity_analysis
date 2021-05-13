//Prompts the user to choose a folder with the images.
dir1 = getDirectory("Select the source directory ");
//Prompts user to choose destination folder for saving post-analyzed images.
dir2 = getDirectory("Select the destination directory ");
//Numbers each file in dir1 and puts these numbers into a list. 
list = getFileList(dir1);
setBatchMode(true)
//Analyzes each image based on the number that each file has been assigned.
for (i=0; i<list.length; i++) {
//Following "if" statements creates condition for which files to process in the folder.
	if (endsWith(list[i], ".tif")) {
		showProgress(i+1, list.length);
		open(dir1+list[i]);
		run("8-bit");
		run("Set Scale...", "distance=0 known=0 unit=pixel");
		FileName=dir2+File.separator+File.nameWithoutExtension+File.separator;
		File.makeDirectory(FileName);
		FileName=FileName+File.separator+"Classified";
		File.makeDirectory(FileName);

//Grid and selection of random squares
roiManager("reset");
mainWindow = getTitle();
h = getHeight;
w = getWidth;
area = w*h;
//Generates grid
gridNum = 450;
boxArea = area/gridNum; // area of each grid box
boxSide = sqrt(boxArea); // side length of each grid box
numBoxY = floor(h/boxSide); // number of boxes that will fit along the width
numBoxX = floor(w/boxSide); // "" height
remainX = (w - (numBoxX*boxSide))/2; // remainder distance left when all boxes fit
remainY = (h - (numBoxY*boxSide))/2;
for (k=0; k<numBoxY; k++) { // draws rectangles in a grid, centred on the X and Y axes and adds to ROI manager
    for (j=0; j<numBoxX; j++) {
        makeRectangle((remainX + (j*boxSide)), (remainY+(k*boxSide)), boxSide, boxSide);
        roiManager("add");
   }
}
//Defines grid selection

gridTotal = roiManager("count"); // not neccessarily as many boxes in the grid as specified due to the constraint of # squares not fitting the width/height
boxID = newArray(gridTotal);

for (m=0; m<gridTotal; m++) { // generate random number to select a square in the grid, makes sure the square has not already been chosen
    
selectWindow(mainWindow);
roiManager("select", m);
run("Duplicate...", "duplicate"); // duplicates the random square in the grid box
rename("Grid " + m);
}

for (n=0; n<gridTotal; n++) {
    selectWindow("Grid " + n);
    pointX = round(random*boxSide); // random X coord
    pointY = round(random*boxSide); // random Y coord
    makePoint(pointX, pointY);
    FolderName=dir2+File.separator+File.nameWithoutExtension+File.separator;
saveAs("Tiff", FolderName + File.nameWithoutExtension + "Grid" + n);
 		}
	}
}