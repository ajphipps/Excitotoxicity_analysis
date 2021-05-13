input = getDirectory("Input directory");
output = getDirectory("Output directory");

list = getFileList(input);
Array.sort(list)

run("Image Sequence...", "open=["+input+"] file=.tif sort");
run("Make Montage...", "columns=21 rows=21 scale=1");

getRawStatistics(nPixels, mean, min, max); 

setBatchMode( true );
run("Set Measurements...", "area_fraction redirect=None decimal=3");

for( i=min, n=0; i <= max; i++, n++ )
{	
	selectWindow("Montage");
	run("Duplicate...", "title=[to-be-thresholded]");
	selectWindow("to-be-thresholded");
	setThreshold( i, i );
	run("Convert to Mask");
	run("Measure");
	setResult("Label", n, i ); 
	saveAs("results", output+File.nameWithoutExtension+".csv");
	close();
}

selectWindow("Montage");
saveAs("tiff", output+File.nameWithoutExtension+"montage");

run("Clear Results");
run("Close All");

