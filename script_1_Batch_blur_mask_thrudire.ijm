//run this on a list of directories where the subdirectorise have a raw image and create a mask
//cannot tolerate subfolders without an image with the suffix 


mainDir = getDirectory("Choose a main directory "); 
mainList = getFileList(mainDir); 


Dialog.create("Create Masks on a Directory of Sub Directories");
Dialog.addString("image Suffix:", "counts");


Dialog.show();
imageSuffix = Dialog.getString() + ".tif";


for (i=0; i<mainList.length; i++) {  // for loop to parse through names in main folder 

      if(endsWith(mainList[i], "/")){   // a '/" indicates that the name is a subfolder... 
   
           subDir = mainDir + mainList[i]; 
           subList = getFileList(subDir); 
			
           		for (m=0; m<subList.length; m++) { //clunky, loops thru all items in folder looking for image
		    		if (endsWith(subList[m], imageSuffix)) { 
		   	 			open(subDir+subList[m]);
		   	 			im_title = getTitle();
 						run("Subtract Background...", "rolling=50 stack");
						run("Despeckle", "stack");
						run("Gaussian Blur...", "sigma=3 stack");
						run("8-bit");
						setAutoThreshold("Huang dark");
						setOption("BlackBackground", true);
						run("Convert to Mask", "method=Huang background=Dark black");
						run("Fill Holes", "stack");
						run("Erode", "stack");
						run("Erode", "stack");
	    				run("Erode", "stack");
						saveAs("tiff", subDir+im_title+"_mask");			    		
		    			}
           			}          						    
			    im_title = getTitle();	    		
		    }// execute all tasks while in subfolder
		    		selectWindow(im_title);
 					close();
}//all images in main directory	



