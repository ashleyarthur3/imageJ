// "Batch RGB Merge"

  Dialog.create("Batch Convert");
  Dialog.addString("image Suffix:", " Z");
  Dialog.addString("mask Suffix:", "_mask");
  //Dialog.addString("Blue Suffix:", "d0");
 // Dialog.addCheckbox("Open as Stack", false);
  Dialog.show();
  redSuffix = Dialog.getString() + ".";
  greenSuffix = Dialog.getString() + ".";
  //blueSuffix = Dialog.getString() + ".";
  //openAsStack = Dialog.getCheckbox();
 // if (openAsStack)
     // openImagesAsStack();
  //else
      batchConvert();
  //exit;

 
  function batchConvert() {
      dir1 = getDirectory("Choose Source Directory ");
      dir2 = getDirectory("Choose Destination Directory ");
      list = getFileList(dir1);
      setBatchMode(true);
      n = list.length;
      if ((n%2)!=0)
         exit("The number of files must be a multiple of 2");
      first = 0;
      for (i=0; i<n/2; i++) {
          showProgress(i+1, n/2);
          red="?"; green="?";
          for (j=first; j<first+2; j++) {
              if (indexOf(list[j], redSuffix)!=-1)
                  red = list[j];
              if (indexOf(list[j], greenSuffix)!=-1)
                  green = list[j];
          }
          //open(dir1 +red);
          open(dir1 +green);
          index = indexOf(red, redSuffix);
          name = substring(red, 0, index);
          
          run("Analyze Particles...", "size=40-10000 clear add");
          close();
        array1 = newArray("0"); 
		for (i=1;i<roiManager("count");i++){ 
        array1 = Array.concat(array1,i); 
        Array.print(array1); 
		} 
		roiManager("select", array1); 
          
       	roiManager("save selected", dir2+name+"_roimask.zip");

		open(dir1 +green);
		for (k=0; k<roiManager("count");k++){ 
        	roiManager("Select", k); 
        	run("Make Band...", "band=5"); 
        	roiManager("Update"); //In case you want to have the band selection replacing the original selection, otherwise delete the line 
	}	
        
roiManager("select", array1); 
          
          roiManager("save selected", dir2+name+"_roiband.zip");	

          first += 2;
      }
  }
