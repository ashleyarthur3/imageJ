str = split(getTitle(), ".");
str = str[0]+"_roi-"

n = roiManager("count");
for ( i=0; i<n; i++ ) { 
	roiManager("select", i);
	outline2results(str+(i+1));
}
setBatchMode(false);
exit();
function outline2results(lbl) {
	nR = nResults;
	Roi.getCoordinates(x, y);
	for (i=0; i<x.length; i++) {
		setResult("Label", i+nR, lbl);
		setResult("X", i+nR, x[i]);
		setResult("Y", i+nR, y[i]);
	}
}