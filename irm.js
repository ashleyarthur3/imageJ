importPackage(Packages.ij);
importPackage(Packages.ij.measure);
var opener = new Packages.ij.io.OpenDialog("Choose an image stack:");
importPackage(Packages.java.io);
var format = "zip"; // file extension for input stack
var imagefile = new File(opener.getPath());
var imagename = opener.getFileName();
if (!imagefile.exists())
	IJ.showMessage("Image file is not valid!");
var resultsdir = new File(opener.getDirectory(), "/Analysis/");
if (!resultsdir.isDirectory()) 
	resultsdir.mkdir();
var prefix = resultsdir.getCanonicalPath()+File.separator+opener.getFileName();
var resultsfile = new File(prefix+"_Results.csv");
var dx = 0.114; // 1x1 binning, 63X + 1X optovar
var minsizemicron = 1; // 1sq um ~ 76 sq pixels
var minsize = minsizemicron/(dx*dx); // minsize in pixels squared
var maxsize = 50000; // maxsize in pixels squared
var mincirc = 0.10; // minimum circularity ratio
var nCells=0;
var meanArea=0;
var logmeanArea=0;
var stderr=0;
var useirm=true;
var digits = 6; // number of significant digits
var DEBUG = true;

// Process mask
var mask = IJ.openImage(imagefile);
var irm = mask.duplicate();						
IJ.run(mask, "Z Project...", "stack projection=Median");
mask = IJ.getImage();

// Flat field correction
//irm.show();
var ic = new Packages.ij.plugin.ImageCalculator();
if (useirm) {
	thresh = ic.run("Divide create 32-bit stack", irm, mask);
} else {
	thresh = irm;
}
//thresh.show();
saveIf(mask, format, prefix+"_Flatten");
mask.changes = false;
mask.close();
irm.changes = false;
irm.close();

// Process image
var mask_width = 2;
var radius_med = Math.ceil(mask_width/dx);
if (useirm) {
	IJ.run(thresh, "Convert to Mask", "method=Default background=Dark calculate");
	IJ.run(thresh, "Invert", "stack");
} else {
	IJ.run(thresh, "Median...", "radius="+IJ.d2s(radius_med,0)+" slice stack");
	// Input image is 16-bit, but some methods need 8-bit image, 
	// so the image lookup table must be normalized before processing
	IJ.run(thresh, "Enhance Contrast", "saturated=0.35"); 
	IJ.log("now in local thresholding mode ...");
	
	// Apply threshold to create the mask 
	IJ.run(thresh, "8-bit", ""); 
	// Length scale for local thresholds = the mask radius
	var bernsen_width = mask_width;
	var radius_th = Math.ceil(bernsen_width/dx);
	IJ.run(thresh, "Auto Local Threshold", "method=Bernsen radius="+
		IJ.d2s(radius_th,0)+" parameter_1=0 parameter_2=0 white stack");
	IJ.run(thresh, "Convert to Mask", "method=Moments background=Light stack");
				
}
saveIf(thresh, format, prefix+"_Thresholded_circ"+IJ.d2s(mincirc, 1));

// run particle analysis
var rs = new RoiSet();
var resultstable = ResultsTable.getResultsTable();
resultstable.reset(); // clear the results table
IJ.run("Set Measurements...", "area perimeter shape redirect=None decimal="+IJ.d2s(digits, 0));
IJ.run(thresh, "Analyze Particles...", "size=" + IJ.d2s(minsize,0) + "-" + IJ.d2s(maxsize,0) +
	" circularity=" + IJ.d2s(mincirc, digits) + "-1.0 show=Outlines display exclude stack add");
outimage = IJ.getImage();
saveIf(outimage, format, prefix+"_Particles_circ"+IJ.d2s(mincirc, 1));
thresh.changes = false;
thresh.close();
if (!DEBUG) {
	outimage.changes = false;
	outimage.close();
}

// Save results as text
var textfile = prefix+"_Results_circ"+IJ.d2s(mincirc, 1)+".csv";
resultstable.save(textfile);

// save rois
rs.runCommand("Select All");
rs.runCommand("Save", prefix+"_RoiSet_circ"+IJ.d2s(mincirc,1)+".zip");

// IJ.setColumnHeadings(resultstable.getColumnHeadings()); only clears window

function saveIf(img, format, path) {
	// save image one time only
	var f = new File(path);
	if (!f.exists())
		IJ.saveAs(img, format, path);
}

function RoiSet() {
	// Open the ROI manager and reset it
	importClass(Packages.ij.plugin.frame.RoiManager);
	var r = RoiManager.getInstance();

	if (r != null) {
		r.close();
	}
	r = new RoiManager();
	return r;
}

