
//mainDir = getDirectory("Choose a main that is only RGB images "); 
//mainList = getFileList(mainDir); 
//File.makeDirectory(mainDir+"Masks");
//saveDir=mainDir+"Masks/"
//Dialog.create("Create Masks on a Directory of Sub Directories");
//Dialog.addString("image Suffix:", "ome");
//saveAs("tiff", saveDir+name+"_tunnel");

run("Set Measurements...", "area mean min centroid perimeter stack redirect=None decimal=3");
setOption("BlackBackground", true);
run("Make Binary", "method=Huang background=Dark calculate black");
str = split(getTitle(), ".");
str = str[0]+"_roi-";

run("Analyze Particles...", "size=1000-100000 clear add stack");

n = roiManager("count");

for ( j=0; j<n; j++ ) { 
	roiManager("select", j);
	outline2results(str+(j+1));
}

setBatchMode(false);
exit();

function outline2results(lbl) {
	nR = nResults;  //Returns the current measurement counter value. The parentheses "()" are optional. See also: getValue("results.count").
	Roi.getCoordinates(x, y);
	for (i=0; i<x.length; i++) {
		setResult("Label", i+nR, j); //col title, row number, row value
		setResult("X", i+nR, x[i]);
		setResult("Y", i+nR, y[i]);
	}
}

saveAs("Results", "C:/Users/arthu038/Desktop/New folder/"+str+"Results.csv");
