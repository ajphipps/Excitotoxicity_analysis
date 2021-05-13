//Ask the user to select the source and destination directories

inputdir = getDirectory("Select the source directory");
outputDir = getDirectory("Select the destination directory");


//Generate a list of the files in the selected directory
list = getFileList(inputdir);
Array.sort(list)

for (i=0; i<list.length; i++) {
		filename = inputdir + list[i];
		if (endsWith(filename, "tif")){
			open(filename);
			nameStore = File.nameWithoutExtension;
			run("8-bit");
			run("Set Scale...", "distance=0 known=0 unit=pixel");
			saveAs("Tiff", outputDir+nameStore+"_8bit");
			run("Close All");
		}
}