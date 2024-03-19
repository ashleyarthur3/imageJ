//run this on a list of directories where the subdirectorise have a raw image and create a mask
//cannot tolerate subfolders without an image with the suffix 

mainDir = getDirectory("Choose a main directory "); 
mainList = getFileList(mainDir); 


Dialog.create("Create Masks on a Directory of Sub Directories");
Dialog.addString("image Suffix:", "_Probabilities");


Dialog.show();
imageSuffix = Dialog.getString() + ".tiff";


//for (i=0; i<mainList.length; i++) {  // for loop to parse through names in main folder 

      //if(endsWith(mainList[i], "/")){   // a '/" indicates that the name is a subfolder... 
   
           //subDir = mainDir + mainList[i]; 
           //subList = getFileList(subDir); 
			
           		for (m=0; m<mainList.length; m++) { //clunky, loops thru all items in folder looking for image
		    		if (endsWith(mainList[m], imageSuffix)) { 
		   	 			open(mainDir+mainList[m]);
		   	 			im_title = getTitle();
			    		index = lastIndexOf(im_title, imageSuffix);
         				name = substring(im_title, 0, index);
         				makeRectangle(318, 153, 1608, 1785);
						run("Crop");
						run("Make Composite", "display=Composite");
						run("Split Channels");
         				selectWindow("C1-"+ im_title);
         				//run("Log");
 						//run("Subtract Background...", "rolling=50 stack");
						run("Despeckle");
						run("Gaussian Blur...", "sigma=2");
						//run("8-bit");
						setAutoThreshold("Huang dark");
						setOption("BlackBackground", true);
						run("Convert to Mask", "method=Huang background=Dark black");
						run("Fill Holes");
						//run("Watershed Irregular Features", "erosion=5 convexity_threshold=0.5 separator_size=100-1000000");
						
						//run("Erode");
						//run("Erode");
	    				//run("Erode");
						selectWindow("C2-"+ im_title);
						setAutoThreshold("Minimum dark no-reset");
						setOption("BlackBackground", true);
						run("Convert to Mask", "method=Minimum background=Dark black");


						//run("Wait For User", "Select Rectangle to Invert");
						run("Speckle Inspector", "big=[C1-"+ im_title+"] small=[C2-"+ im_title+"] redirect=None min_object=4000 min_object_circularity=0.1 max_speckle_number=40 min_speckle_size=400 max_speckle_size=4000 speckle statistic");
						
						saveAs("tiff", mainDir+name+"_Inspector");
						selectWindow("Speckle List C1-"+ im_title);
						saveAs("Results", mainDir+name+"_results.csv");
						run("Merge Channels...", "c1=[C1-"+ im_title+"] c2=[C2-"+ im_title+"] create");	
						saveAs("tiff", mainDir+name+"_mask");

		    			}
           			}          						    

		
 				   
		    // execute all tasks while in subfolder
//all images in main directory	
run("Close All");


