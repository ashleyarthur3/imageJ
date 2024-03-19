run("Close All");
	var file1
	var list1
	var file2
	var list2
macro "merge channels"{
    setBatchMode(true);
    file1= getDirectory("Choose a Directory -Channel 488");
    list1= getFileList(file1); 
    file2= getDirectory("Choose a Directory -Channel 561");
    list2= getFileList(file2); 
    open(file1+list1[1]);
    open(file2+list2[1]);
    run("Merge Channels...", "c6=" + list2[1] + " c2=" + list1[1] + " keep");
    //setBatchMode(false);

}
