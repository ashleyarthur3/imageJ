// "Batch RGB Merge"



  Dialog.create("RGB Batch Convert");
  Dialog.addString("Red Suffix:", "_C561");
 
  Dialog.show();
  redSuffix = Dialog.getString() + ".";
  
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
		run("Bleach Correction", "correction=[Exponential Fit]");

	//	run("Erode", "stack");
		//run("Erode", "stack");
          saveAs("tiff", dir2+name+"_bleachcorr");
			selectWindow("y = a*exp(-bx) + c");
			saveAs("tiff", dir2+name+"_fit");
			
          first += 1;
      }
  }
