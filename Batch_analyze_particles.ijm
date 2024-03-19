 Dialog.create("Creat ROI ");
  Dialog.addString("Red Suffix:", "_C561");
 // Dialog.addString("Green Suffix:", "_c488");
  Dialog.addString("Mask Suffix:", "_mask");
  //Dialog.addCheckbox("Open as Stack", false);
  Dialog.show();
  redSuffix = Dialog.getString() + ".";
//  greenSuffix = Dialog.getString() + ".";
  maskSuffix = Dialog.getString() + ".";


batchConvert()

 function batchConvert() {
      dir1 = getDirectory("Choose  Directory ");
      list = getFileList(dir1);
      setBatchMode(true);
n=list.length;
first = 0;
for (i=0; i<n/2; i++) {
          showProgress(i+1, n/2);
          red="?"; green="?"; mask="?";
          for (j=first; j<first+2; j++) {
              if (indexOf(list[j], redSuffix)!=-1)
                  red = list[j];
             if (indexOf(list[j], maskSuffix)!=-1)
                  mask = list[j];
          }
          open(dir1 +mask);
         // open(dir1 +green);
          
          index = indexOf(mask, maskSuffix);
          name = substring(mask, 0, index);

            
run("Analyze Particles...", "size=40-10000 clear add");
      
//roiManager("select", [0,roiManager("count")])
//roiManager("Save", dir1+name+".zip");

  
//for (i=0; i<roiManager("count");i++){ 
       // roiManager("Select", i); 
       // run("Make Band...", "band=0.8"); 
       // roiManager("Update"); //In case you want to have the band selection replacing the original selection, otherwise delete the line 
//}	
count = roiManager("count")-1;
name=getTitle();

roiManager("Select", newArray(0,"count"));

 close();

}
 }