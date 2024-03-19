run("Close All");
Dialog.create("ND2 to Composite");
Dialog.addCheckbox("Z project Stack: ", true)
Dialog.show();
zProject =Dialog.getCheckbox()
ND2toComposite();    
exit;

function ND2toComposite () {
	dir1 = getDirectory("Choose Source Directory ");
    dir2 = getDirectory("Choose Destination Directory ");
    list = getFileList(dir1);
    Array.sort(list);
    setBatchMode(true);
    n = list.length;
    //outputFolder0 = dir1+"output";
	//dir2 = File.makeDirectory(outputFolder0);
    for (j=0; j<n; j++){
		name = list[j];
		open(dir1 + name);
		title = getTitle();
		getDimensions(w, h, channels, slices, frames);
		run("Stack to Hyperstack...", "order=xyczt(default) channels=["+channels+"] slices=["+slices+"] frames=["+frames+"] display=Grayscale");
		run("Split Channels");
		
		selectWindow("C3-"+ title);
		titleRed = getTitle();
		selectWindow("C2-"+ title);
		titleGreen = getTitle();
		selectWindow("C1-"+ title);
		titleBlue = getTitle();
		//run("Merge Channels...", "c6=["+titleRed+"] c2=["+titleGreen+"]create");
		run("Merge Channels...", "c6=["+titleRed+"] c2=["+titleGreen+"] c3=["+titleBlue+"]create");
		
        index = indexOf(title, ".nd2");
        savename = substring(title, 0, index);
		
		if (slices > 1){
			if (zProject == true) {
			run("Z Project...", "projection=[Max Intensity]");
			}
		}
		saveAs("tiff", dir2+savename+"merge");
		close();
		close();
		
}
}