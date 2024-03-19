run("Line Width...", "line=10"); //width in pixels
for (i=0; i<roiManager("count");i++){ 
        roiManager("Select", i); 
        run("Area to Line");
		roiManager("Update")
}