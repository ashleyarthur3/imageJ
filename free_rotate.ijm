s = newArray(22);
s[21] = 0;

rotationOK = false;

snapshot();

do {
ChosenAngle = getNumber("Enter the rotation angle in degrees",0);
//print( "Angle = " + ChosenAngle);
run("Rotate...", "angle="+ChosenAngle+" grid=1 interpolation=Bilinear");
rotationOK = getBoolean("Are you satisfied with the rotation ?");
if(rotationOK == false) {
run("Undo");
}


} while (rotationOK == false);
close();
print(ChosenAngle);
saveAs("Text", "/Users/ashley/Downloads/Log/, "Final_angle.txt");