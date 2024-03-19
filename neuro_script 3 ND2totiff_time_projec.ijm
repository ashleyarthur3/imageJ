run("Close All");

Dialog.create("Convert and Project");
Dialog.addCheckbox("Z Project Max", true);

Dialog.show();
zProject = Dialog.getCheckbox();
ND2toComposite();
exit;




function ND2toComposite () {
	dir1 = getDirectory("Choose Source Directory "); // specify source files
	//dir2 = dir1+"/tiffs/";
	//File.makeDirectory(dir2); //create output directory
   
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
        index = indexOf(title, ".nd2"); // remove files suffix for saving
        savename = substring(title, 0, index);
          if (zProject){
			run("Z Project...", "projection=[Max Intensity]"); // zproject
        	selectWindow("MAX_"+title);
			saveAs("tiff", dir2+"MAX_"+savename);
			close();
          }
		else {
			selectWindow(title);
			saveAs("tiff", dir2+savename);
		} // z project boolean
		
	close();	
		} // end loop

		
} // end function 
