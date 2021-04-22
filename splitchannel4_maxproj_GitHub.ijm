//April 22, 2021 Macro to open .nd2 files, create maximum intensity projections and then split the channels. Note the Window names may vary between
//Mac and PCs so that may need to be modified
//Created by Megan Cleland Harwig, research scientist @ the Medical College of Wisconsin

//prompt to select for where your files are stored, ensure they are the only files in the directory
_RootFolder = getDirectory("Choose a Directory");

// Creating a directory where the files are saved
outputfolder1 = _RootFolder + "/channel1";
File.makeDirectory(outputfolder1);
outputfolder2 = _RootFolder + "/channel2";
File.makeDirectory(outputfolder2);
outputfolder3 = _RootFolder + "/channel3";
File.makeDirectory(outputfolder3);
outputfolder4 = _RootFolder + "/channel4";
File.makeDirectory(outputfolder4);


//Loop to open and process .nd2 files within your directory, NOTE that the max projection is currently set to only use the first 7 z-slices
setBatchMode(true);

list_of_files = getFileList(_RootFolder);

for (i = 0; i < list_of_files.length; i++) {
filename = list_of_files[i];
if (endsWith(filename, ".nd2")) {
run("Bio-Formats Importer", "open=" + _RootFolder + filename + " color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT use_virtual_stack");
run("Z Project...", "stop=7 projection=[Max Intensity]");
run("Split Channels"); 
               selectWindow("C1-MAX_"+filename); 
               save(_RootFolder + "/channel1/" + replace(filename,".nd2","_ch1.tif"));
               close(); 
               selectWindow("C2-MAX_"+filename); 
               save(_RootFolder + "/channel2/" + replace(filename,".nd2","_ch2.tif"));
               close(); 
               selectWindow("C3-MAX_"+filename); 
               save(_RootFolder + "/channel3/" + replace(filename,".nd2","_ch3.tif"));
               close(); 
               selectWindow("C4-MAX_"+filename); 
               save(_RootFolder + "/channel4/" + replace(filename,".nd2","_ch4.tif"));
               close(); 
               write("Conversion Complete"); 
       
}
}