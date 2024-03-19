for (i=0; i<roiManager("count");i++){ 
        roiManager("Select", i); 
        run("Make Band...", "band=0.8"); 
        roiManager("Update"); //In case you want to have the band selection replacing the original selection, otherwise delete the line 
}	