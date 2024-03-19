run("Close All");
Dialog.create("ND2 to Composite");
Dialog.addCheckbox("Z project Stack: ", false)
Dialog.show();
zProject =Dialog.getCheckbox()
ND2toComposite();    
exit;

function ND2toComposite () {
	dir1 = getDirectory("Choose Source Directory "); // specify source files
    dir2 = getDirectory("Choose Destination Directory "); // specify output directory
    list = getFileList(dir1); // list of images in source
    Array.sort(list) 
    setBatchMode(true);
    n = list.length; 
    // loop through files in source
    for (j=0; j<n; j++){
		name = list[j];
		open(dir1 + name);
		title = getTitle(); 
		run("Split Channels");
		
		selectWindow("C1-"+ title);
		titleRed = getTitle();
		("C2-"+ title);
		titleGreen = getTitle();
		//selectWindow("C3-"+ title);
		//titleBlue = getTitle();
		run("Merge Channels...", "c1=["+titleRed+"] c3=["+titleGreen+"] create");
		//run("Merge Channels...", "c1=["+titleRed+"] c2=["+titleGreen+"] c3=["+titleBlue+"] create");
        index = indexOf(title, ".nd2"); // remove files suffix for saving
        savename = substring(title, 0, index);
		
		if (zProject == false) {
        	//saveAs("tiff", dir2+savename+"merge");
				run("Grays");
				saveAs("tiff", dir2+savename);
				saveAs("BMP", dir2+savename);
		} else {
			run("Z Project...", "projection=[Max Intensity]");
			saveAs("tiff", dir2+savename+"merge");
			
		}
	close();	
		} // end loop

		
} // end function 
