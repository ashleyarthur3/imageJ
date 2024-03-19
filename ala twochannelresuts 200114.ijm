	



im_title = getTitle();
im_dir = getDirectory(im_title);

			run("Split Channels");
           		
		   	 			
		   	 			selectWindow('C3-'+im_title);
 						run("Subtract Background...", "rolling=50 stack");
						run("Despeckle", "stack");
						run("Gaussian Blur...", "sigma=3 stack");
						run("8-bit");
						setAutoThreshold("Li dark");;
						setOption("BlackBackground", true);
						run("Convert to Mask", "method=Li background=Dark black");
						//run("Fill Holes", "stack");
						setAutoThreshold("Li dark");
						saveAs("tiff", im_title+"_mask");			    		
		    			     						    
				run("Set Measurements...", "area mean min integrated stack redirect=None decimal=3");
				selectWindow(im_title+"_mask.tif");
				run("Analyze Particles...", "size=30-400000 clear add stack");

				array1 = newArray("0");; //all this array1 is to "select all in ROI manager
					for (k=1;k<roiManager("count");k++){ 
        				array1 = Array.concat(array1,k); 
        					//Array.print(array1); 
						} 
						roiManager("select", array1); //after creaing array, select all
						
				selectWindow(im_title+"_mask.tif");
		   	 	roiManager("Measure"); //measure
		   	 	roiManager("Save", im_dir+im_title+"ROI.zip");
		   	 	saveAs("Results", im_dir+im_title+"Results-C3.csv");
				run("Clear Results");
				selectWindow('C1-'+im_title);
				
				roiManager("Measure"); //measure
		   	 	//roiManager("Save", im_dir+im_title+"ROI-.zip");
		   	 	saveAs("Results", im_dir+im_title+"Results-C1.csv");
			   	 	
		   	 	
run("Close All");