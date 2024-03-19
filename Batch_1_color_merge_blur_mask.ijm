// "Batch RGB Merge"



  Dialog.create("RGB Batch Convert");
  Dialog.addString("Suffix:", "_c488");
 
  Dialog.show();
  redSuffix = Dialog.getString() + ".tif";
  
      batchConvert();
  //exit;


  function batchConvert() {
      dir1 = getDirectory("Choose Source Directory ");
      dir2 = getDirectory("Choose Destination Directory ");
      list = getFileList(dir1);
      setBatchMode(true);
      n = list.length;
      if ((n%1)!=0)
         exit("The number of files must be a multiple of 1");
      stack = 0;
      first = 0;
      for (i=0; i<n; i++) {
          showProgress(i+1, n);
          red="?";
          
          
          
          for (j=first; j<first+1; j++) {
              if (indexOf(list[j], redSuffix)!=-1)
                  red = list[j];
          }
          open(dir1 +red);     
          index = indexOf(red, redSuffix);
          name = substring(red, 0, index);
          //saveAs("tiff", dir2+name);
          
		run("Subtract Background...", "rolling=50 stack");
		run("Despeckle", "stack");
		run("Gaussian Blur...", "sigma=3 stack");
		run("8-bit");
		setAutoThreshold("Huang dark");

		setOption("BlackBackground", true);
		run("Convert to Mask", "method=Huang background=Dark black");
		run("Fill Holes", "stack");
	//	run("Convert to Mask", "method=Default background=Dark calculate black");
		run("Erode", "stack");
		run("Erode", "stack");
	    run("Erode", "stack");
	//	run("Erode", "stack");
		//run("Erode", "stack");
          saveAs("tiff", dir2+name+"_mask");

          first += 1;
      }
  }
