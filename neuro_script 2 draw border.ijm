//this macro runs a folder if .tif images and first allows user to crop the image with a freehand pologon,
//then allows user to set the rotation of the image
//it saves the cropped image in a new directory (create ahead of time)
//it also saves a text file with the angle degree of rotation -180 - 180 deg


run("Close All");


drawBorderandCrop();

exit;


function drawBorderandCrop () {
	dir1 = getDirectory("Choose Source Directory "); // specify source files
	//dir2 = dir1+"/tiffs/";
	//File.makeDirectory(dir2); //create output directory
   
    dir2 = getDirectory("Choose Destination Directory "); // specify output directory
    
    list = getFileList(dir1); // list of images in source
 
    Array.sort(list) 
    setBatchMode(false); //show image = false 
    n = list.length; 
    // loop through files in source
    for (j=0; j<n; j++){
		name = list[j];
		open(dir1 + name);
		title = getTitle(); 
        index = indexOf(title, ".tif"); // remove files suffix for saving
        
        savename = substring(title, 0, index);
        
		run("Enhance Contrast", "saturated=0.35"); //autoscale image

// outline
        setTool("polygon");
        //run("Threshold...");  // open Threshold tool
        
  		titleDialog = "WaitForUser";
  		msg = "Outline the Neuron";
  		waitForUser(titleDialog, msg);	
		setBackgroundColor(0, 0, 0);
		run("Clear Outside");
		run("Select All");

//end outline

//rotate
		s = newArray(22);
		s[21] = 0;

		rotationOK = false;

		snapshot();

		do {
			ChosenAngle = getNumber("Enter the rotation angle in degrees",0);
			//print( "Angle = " + ChosenAngle);
			run("Rotate...", "angle="+ChosenAngle+" grid=1 interpolation=Bilinear enlarge");
			rotationOK = getBoolean("Are you satisfied with the rotation ?");
		
				if(rotationOK == false) {
				run("Undo");
				}// reset rotation if it was not good

		} while (rotationOK == false); //finish rotation
		
		print(ChosenAngle);

		selectWindow("Log");		
		saveAs("Text", dir2+"Angle_rotation_LOG"+savename+".txt");
		print("\\Clear"); 
		
		selectWindow(title);
		saveAs("tiff", dir2+"CROP_"+savename);
		close();
		
    }//end loop
} // end function
		
