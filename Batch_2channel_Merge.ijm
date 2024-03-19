// "Batch RGB Merge"

// Opens multiple sets of three separate color channels as
// an RGB stack or converts them to RGB images. File names
// ending in "d1", "d2" and "d0" are assumed to be red, green
// and blue channels respectively, but this can be changed in
// the dialog box.

// A sample image set, courtesy of Mikael Bjorklund, is available at:
//    http://rsb.info.nih.gov/ij/macros/images/DrosophilaCells.zip
// It consists of three images of Drosophila S2 cells,
// each with three channels (d0=blue, d1=red and d2=green  
// as indicated by the end of the filename. The staining is
// standard Hoechst, phalloidin, tubulin.

  
  Dialog.create("RGB Batch Convert");
  Dialog.addString("Red Suffix:", "_C561");
  Dialog.addString("Green Suffix:", "_c488");
  //Dialog.addString("Blue Suffix:", "d0");
 
  Dialog.show();
  redSuffix = Dialog.getString() + ".";
  greenSuffix = Dialog.getString() + ".";
  //blueSuffix = Dialog.getString() + ".";
      batchConvert();
  exit;
  call("ij.io.OpenDialog.setDefaultDirectory", dir); 
  function batchConvert() {
      dir1 = getDirectory("Choose Source Directory ");
      dir2 = getDirectory("Choose Destination Directory ");
      list = getFileList(dir1);
      setBatchMode(true);
      n = list.length;
      if ((n%2)!=0)
         exit("The number of files must be a multiple of 2");
      stack = 0;
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
          open(dir1 +red);
          run("Enhance Contrast", "saturated=0.35");
          open(dir1 +green);
          run("Enhance Contrast", "saturated=0.35");
	
		  run("Merge Channels...", "c2=["+green+"] c6=["+red+"] create");
        
          index = indexOf(red, redSuffix);
          name = substring(red, 0, index);
          saveAs("tiff", dir2+name);
          
          run("RGB Color", "slices keep");
		  saveAs("Gif", dir2+name);
		  
          first += 2;
      }
  }
