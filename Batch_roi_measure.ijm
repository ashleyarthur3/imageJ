
mainDir = getDirectory("Choose a main directory "); 
mainList = getFileList(mainDir); 
run("Set Measurements...", "area mean centroid perimeter stack redirect=None decimal=3");   
run("Input/Output...", "jpeg=85 gif=-1 file=.csv save_column");

for (i=0; i<mainList.length; i++) {  // for loop to parse through names in main folder 
 
      if(endsWith(mainList[i], "/")){   // a '/" indicates that the name is a subfolder... 
   
           subDir = mainDir + mainList[i]; 
           subList = getFileList(subDir); 
           
			for (j=0; j<subList.length; j++) { //clunky, loops thru all items in folder looking for image
		    	if (endsWith(subList[j], "_bleachcorr.tif")) { 
		   	 	open(subDir+subList[j]);
		   
		   	 	im_title = getTitle();
		   	 	open(subDir+"CytoplasmRoiSet.zip");
				array1 = newArray("0");; //all this array1 is to "select all in ROI manager
					for (k=1;k<roiManager("count");k++){ 
        				array1 = Array.concat(array1,k); 
        					//Array.print(array1); 
						} 
						roiManager("select", array1); //after creaing array, select all

		   	 	
		   	 	roiManager("Measure"); //measure
		   	
		   	 	saveAs("Results", subDir+im_title+"Results.csv");//save
				//saveAs("tiff", subDir+im_title+"loop_test");

				selectWindow("Results"); 
  		 		run("Close"); //close
				selectWindow("ROI Manager"); 
				run("Close"); //close
				close();


//another kind of ROI here

		    	}
      } 
 } 
      }
