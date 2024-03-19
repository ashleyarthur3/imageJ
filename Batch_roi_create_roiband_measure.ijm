//run this on a list of directories where the subdirectors have a raw image and a mask


mainDir = getDirectory("Choose a main directory "); 
mainList = getFileList(mainDir); 


Dialog.create("Create and Measure Cytoplasm ROIs");
Dialog.addString("image Suffix:", "tau");
Dialog.addString("mask Suffix:", "_mask");
//Dialog.addNumber("Band Size (um)", 0.8);

Dialog.show();
imageSuffix = Dialog.getString() + ".tif";
maskSuffix = Dialog.getString() + ".tif";
//cortexBand = Dialog.getNumber();


run("Set Measurements...", "area mean centroid perimeter stack redirect=None decimal=3");   
run("Input/Output...", "jpeg=85 gif=-1 file=.csv save_column");

for (i=0; i<mainList.length; i++) {  // for loop to parse through names in main folder 

      if(endsWith(mainList[i], "/")){   // a '/" indicates that the name is a subfolder... 
   
           subDir = mainDir + mainList[i]; 
           subList = getFileList(subDir); 
			
           		for (m=0; m<subList.length; m++) { //clunky, loops thru all items in folder looking for image
		    		if (endsWith(subList[m], maskSuffix)) { 
		   	 		open(subDir+subList[m]);
		    		}
           		}          					
 				
 				run("Analyze Particles...", "size=10-400 clear add stack");
 				close();
 				
				for (j=0; j<subList.length; j++) { //clunky, loops thru all items in folder looking for image
		    		if (endsWith(subList[j], imageSuffix)) { 
		   	 			
		   	 			open(subDir+subList[j]);
			    		im_title = getTitle();
			    		index = indexOf(im_title, imageSuffix);
         				name = substring(im_title, 0, index);
		    			
		    			array1 = newArray("0"); 
						for (array1i=1;array1i<roiManager("count");array1i++){ 
        					array1 = Array.concat(array1,array1i); 
        		 			} //array1i is an iterator ('i')
        		 	
						roiManager("select", array1);
						selectWindow(im_title);
						roiManager("Measure"); //measure   	 
		   	 			saveAs("Results", subDir+name+"Results.csv");//save
       					selectWindow("Results");  
       					run("Close"); //close
       					roiManager("save selected", subDir+"RoiSet.zip");
       					selectWindow(im_title);       		
		    		}

		    		}// execute all tasks while in subfolder
		    		
		}// execute all tasks while in subfolder	
		//close();
} 
           		
//all images in main directory


