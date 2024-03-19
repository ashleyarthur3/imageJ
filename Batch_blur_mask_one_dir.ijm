//run this on a  directories of raw data to blur and create a mask


mainDir = getDirectory("Choose a main directory "); 
mainList = getFileList(mainDir); 

Dialog.create("Create Masks on a Directory of Sub Directories");
Dialog.addString("image Suffix:", ".czi");

Dialog.show();
imageSuffix = Dialog.getString();

			
           		for (m=0; m<mainList.length; m++) { //clunky, loops thru all items in folder looking for image
		    		if (endsWith(mainList[m], imageSuffix)) { 
		   	 			open(mainDir+mainList[m]);
		   	 			
		   	 			
		   	 			im_title = getTitle();
			    		index = indexOf(im_title, imageSuffix);
         				name = substring(im_title, 0, index);
         				
 						run("Subtract Background...", "rolling=50 stack");
						run("Despeckle", "stack");
						//run("Gaussian Blur...", "sigma=3 stack");
						run("Gaussian Blur...", "sigma=2 stack");  // can try for less blur
						run("8-bit");
						setAutoThreshold("Huang dark");
						setOption("BlackBackground", true);
						run("Convert to Mask", "method=Huang background=Dark black");
						run("Fill Holes", "stack");
						run("Erode", "stack");
						run("Erode", "stack");
    					run("Erode", "stack");
    					run("Erode", "stack");
						run("Erode", "stack");
   						run("Erode", "stack");
    					run("Erode", "stack");
						saveAs("tiff", mainDir+name+"_mask")
						close();
		    			}
           			}          						    
			    im_title = getTitle();	    		
				selectWindow(im_title);
 				close();    

//all images in main directory	



