// This macro uses the Find Maxima command to count
// and mark cells in a selection. It assumes the cells
// are lighter than the background. 
//original script here https://imagej.nih.gov/ij/macros/CountAndMarkCells.txt

//Edits made by A. Arthur October 2021

cleanUP();
findROImaxima();

run("Close All");

function findROImaxima() {

	//meanThreshold = 30;
  
       if (selectionType<0 || selectionType>4)
          exit("Area selection required");
         
       setupUndo;
       autoUpdate(false);
       roiManager("Add");
	   run("Set Measurements...", "mean redirect=None decimal=3");
	   run("Measure");
       meanThreshold = getResult("Mean", 0);
      	//print(meanThreshold);
       
	   run("Find Maxima...", "prominence="+meanThreshold+" output=Count");
	   
       im_title = getTitle();
       im_dir=getDir("image");
       roiManager("Save", im_dir+im_title+"ROI.zip");
       saveAs("Results", im_dir+im_title+" Find_Maxima_Results.csv");
     
}

function cleanUP(){

if (isOpen("Results")) {
         selectWindow("Results"); 
    run("Close" );
}
}

