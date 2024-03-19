// "Batch RGB Merge"


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
 // Dialog.addCheckbox("Open as Stack", false);
  Dialog.show();
  redSuffix = Dialog.getString() + ".";
  greenSuffix = Dialog.getString() + ".";
  //blueSuffix = Dialog.getString() + ".";
 // openAsStack = Dialog.getCheckbox();
 // if (openAsStack)
     // openImagesAsStack();
 // else
      batchConvert();
  //exit;

 // function openImagesAsStack() {
   //   dir = getDirectory("Choose Source Directory ");
 //     list = getFileList(dir);
  //    setBatchMode(true);
  //    n = list.length;
   //   if ((n%3)!=0)
  //       exit("The number of files must be a multiple of 3");
 //     stack = 0;
 //     first = 0;
 //     for (i=0; i<n/3; i++) {
 //         showProgress(i+1, n/3);
 //         red="?"; green="?"; blue="?";
 //         for (j=first; j<first+3; j++) {
 //             if (indexOf(list[j], redSuffix)!=-1)
 //                 red = list[j];
 //             if (indexOf(list[j], greenSuffix)!=-1)
 //                 green = list[j];
 //             if (indexOf(list[j], blueSuffix)!=-1)
 //                 blue = list[j];
//          }
//          open(dir+red);
 //         open(dir+green);
 //         open(dir+blue);
//          run("RGB Merge...", "red=["+red+"] green=["+green+"] blue=["+blue+"]");
//          width=getWidth; height=getHeight;
//          run("Copy");
//          close();
//          if (stack==0) {
 //             newImage("RGB Stack", "RGB Black", width, height, n/3);
 //             stack = getImageID;
//          }
 //         selectImage(stack);
 //         setSlice(i+1);
 //         run("Paste");
 //         index = indexOf(red, redSuffix);
 //         name = substring(red, 0, index);
 //         setMetadata(name);
 //         first += 3;
  //    }
  //    setSlice(1);
//      run("Select None");
 //     setBatchMode(false);
 // }

  function batchConvert() {
      dir1 = getDirectory("Choose Source Directory ");
      dir2 = getDirectory("Choose Destination Directory ");
      list = getFileList(dir1);
      setBatchMode(true);
      n = list.length;
      if ((n%2)!=0)
         exit("The number of files must be a multiple of 3");
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
          open(dir1 +green);

          run("RGB Merge...", "red=["+red+"] green=["+green+"]");
          
          index = indexOf(red, redSuffix);
          name = substring(red, 0, index);
          saveAs("tiff", dir2+name);
		
		run("Gaussian Blur...", "sigma=3 stack");
		run("8-bit");
		setAutoThreshold("Default dark stack");

		setOption("BlackBackground", true);
		run("Convert to Mask", "method=Default background=Dark calculate black");
		run("Erode", "stack");
		run("Erode", "stack");
		run("Erode", "stack");
		run("Erode", "stack");
		run("Erode", "stack");
          saveAs("tiff", dir2+name+"_mask");

          first += 2;
      }
  }
