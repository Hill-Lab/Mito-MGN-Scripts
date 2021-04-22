// April 22, 2021 created by Megan Cleland Harwig (mcharwigh@mcw.edu), research scientist @ Medical College of Wisconsin 
// portions of the script were from GenFramesMaxProjs.ijm by Matheus Viana - vianamp@gmail.com - 7.29.2013
// ==========================================================================

// This macro can be used to generate a stacks of PNGs or TIFFs. Names of files are specific for the CellProfiler script "cytoplasm_nuclear_FOXO_github.cpproj"

// Selecting the folder that contains the PNG frame files
_RootFolder = getDirectory("Choose a Directory");

// Creating a directory where the files are saved
outputfolder1 = _RootFolder + "/input_output";
File.makeDirectory(outputfolder1);

////////////////////////////////////////////////////////
// Selecting PNG images with the cell outline and save as a stack
////////////////////////////////////////////////////////
item = 0;
nPNG = 0;
_List = getFileList(_RootFolder);
while (item < _List.length)  {
	if ( endsWith(_List[item],"_ch1.png") ) {
		if (nPNG==0) {
			open(_RootFolder + _List[item]);
			w = getWidth();
			h = getHeight();
			close();
		}
		nPNG++;
	}
	item++;
}
if (nPNG== 0) {
	showMessage("No PNG files were found.");
} else {
	print("Number of PNG files: " + nPNG);
}

// Generating the PNG stack

newImage("stackPNG", "8-bit black", w, h, nPNG);

item = 0; im = 0;
while (item < _List.length)  {
	if ( endsWith(_List[item],"_ch1.png") ) {
		im++;
		open(_RootFolder + _List[item]);
		_FileName = split(_List[item],"."); 
		_FileName = _FileName[0];
		print(_FileName);
		
		run("Copy");
		close();
		
		selectWindow("stackPNG");
		setSlice(im);
		run("Paste");
		setMetadata("Label",_FileName);
	}
	item++;
}

// Saving PNG stack

run("Save", "save=" +  _RootFolder + "/input_output/" + "stackPNGs.tif");
selectWindow("stackPNGs.tif");
close();

////////////////////////////////////////////////////////
// Selecting PNG images with the Nuclei Overlay outline and save as a stack
////////////////////////////////////////////////////////

item = 0;
nPNG = 0;
_List = getFileList(_RootFolder);
while (item < _List.length)  {
	if ( endsWith(_List[item],"_ch1_nuclei_overlay.png") ) {
		if (nPNG==0) {
			open(_RootFolder + _List[item]);
			w = getWidth();
			h = getHeight();
			close();
		}
		nPNG++;
	}
	item++;
}
if (nPNG== 0) {
	showMessage("No PNG files were found.");
} else {
	print("Number of PNG files: " + nPNG);
}

// Generating the PNG stack

newImage("stackPNG", "RGB black", w, h, nPNG);

item = 0; im = 0;
while (item < _List.length)  {
	if ( endsWith(_List[item],"_ch1_nuclei_overlay.png") ) {
		im++;
		open(_RootFolder + _List[item]);
		_FileName = split(_List[item],"."); 
		_FileName = _FileName[0];
		print(_FileName);
		
		run("Copy");
		close();
		
		selectWindow("stackPNG");
		setSlice(im);
		run("Paste");
		setMetadata("Label",_FileName);
	}
	item++;
}

// Saving PNG stack

run("Save", "save=" +  _RootFolder + "/input_output/" + "stacknucPNGs.tif");
selectWindow("stacknucPNGs.tif");
close();

////////////////////////////////////////////////////////
/// Selecting PNG images with the Cytoplasm overlay and save as a stack
////////////////////////////////////////////////////////

item = 0;
nPNG = 0;
_List = getFileList(_RootFolder);
while (item < _List.length)  {
	if ( endsWith(_List[item],"_ch1_cytoplasm_overlay.png") ) {
		if (nPNG==0) {
			open(_RootFolder + _List[item]);
			w = getWidth();
			h = getHeight();
			close();
		}
		nPNG++;
	}
	item++;
}
if (nPNG== 0) {
	showMessage("No PNG files were found.");
} else {
	print("Number of PNG files: " + nPNG);
}

// Generating the PNG stack

newImage("stackPNG", "RGB black", w, h, nPNG);

item = 0; im = 0;
while (item < _List.length)  {
	if ( endsWith(_List[item],"_ch1_cytoplasm_overlay.png") ) {
		im++;
		open(_RootFolder + _List[item]);
		_FileName = split(_List[item],"."); 
		_FileName = _FileName[0];
		print(_FileName);
		
		run("Copy");
		close();
		
		selectWindow("stackPNG");
		setSlice(im);
		run("Paste");
		setMetadata("Label",_FileName);
	}
	item++;
}

// Saving PNG stack

run("Save", "save=" +  _RootFolder + "/input_output/" + "stackcytoPNGs.tif");
selectWindow("stackcytoPNGs.tif");
close();

////////////////////////////////////////////////////////
/// Selecting TIFF images for DAPI and save as a stack
////////////////////////////////////////////////////////

item = 0;
ntiff = 0;
_List = getFileList(_RootFolder);
while (item < _List.length)  {
	if ( endsWith(_List[item],"_DAPI_cropped.tiff") ) {
		if (ntiff==0) {
			open(_RootFolder + _List[item]);
			w = getWidth();
			h = getHeight();
			close();
		}
		ntiff++;
	}
	item++;
}
if (ntiff== 0) {
	showMessage("No TIFF files were found.");
} else {
	print("Number of TIFF files: " + ntiff);
}

// Generating the max projection stack

newImage("MaxProjs", "16-bit black", w, h, ntiff);

item = 0; im = 0;
while (item < _List.length)  {
	if ( endsWith(_List[item],"_DAPI_cropped.tiff") ) {
		im++;
		open(_RootFolder + _List[item]);
		_FileName = split(_List[item],"."); 
		_FileName = _FileName[0];
		print(_FileName);
		
		//run("Z Project...", "start=1 stop=500 projection=[Max Intensity]");
		run("Copy");
		//close();
		close();
		
		selectWindow("MaxProjs");
		setSlice(im);
		run("Paste");
		setMetadata("Label",_FileName);
	}
	item++;
}

// Saving max projection stack

run("Save", "save=" +  _RootFolder + "/input_output/" + "DAPI_MaxProjs.tif");
selectWindow("DAPI_MaxProjs.tif");
close();

////////////////////////////////////////////////////////
/// Selecting TIFF images for FOX-O and save as a stack
////////////////////////////////////////////////////////


item = 0;
ntiff = 0;
_List = getFileList(_RootFolder);
while (item < _List.length)  {
	if ( endsWith(_List[item],"_FOXO_cropped.tiff") ) {
		if (ntiff==0) {
			open(_RootFolder + _List[item]);
			w = getWidth();
			h = getHeight();
			close();
		}
		ntiff++;
	}
	item++;
}
if (ntiff== 0) {
	showMessage("No TIFF files were found.");
} else {
	print("Number of TIFF files: " + ntiff);
}

// Generating the max projection stack

newImage("MaxProjs", "16-bit black", w, h, ntiff);

item = 0; im = 0;
while (item < _List.length)  {
	if ( endsWith(_List[item],"_FOXO_cropped.tiff") ) {
		im++;
		open(_RootFolder + _List[item]);
		_FileName = split(_List[item],"."); 
		_FileName = _FileName[0];
		print(_FileName);
		
		//run("Z Project...", "start=1 stop=500 projection=[Max Intensity]");
		run("Copy");
		close();
		//close();
		
		selectWindow("MaxProjs");
		setSlice(im);
		run("Paste");
		setMetadata("Label",_FileName);
	}
	item++;
}



// Saving max projection stack

run("Save", "save=" +  _RootFolder + "/input_output/" + "FOXO_MaxProjs.tif");
selectWindow("FOXO_MaxProjs.tif");
close();

////////////////////////////////////////////////////////
/// Selecting TIFF images for DIC and save as a stack
////////////////////////////////////////////////////////


item = 0;
ntiff = 0;
_List = getFileList(_RootFolder);
while (item < _List.length)  {
	if ( endsWith(_List[item],"_DIC_cropped.tiff") ) {
		if (ntiff==0) {
			open(_RootFolder + _List[item]);
			w = getWidth();
			h = getHeight();
			close();
		}
		ntiff++;
	}
	item++;
}
if (ntiff== 0) {
	showMessage("No TIFF files were found.");
} else {
	print("Number of TIFF files: " + ntiff);
}

// Generating the max projection stack

newImage("MaxProjs", "16-bit black", w, h, ntiff);

item = 0; im = 0;
while (item < _List.length)  {
	if ( endsWith(_List[item],"_DIC_cropped.tiff") ) {
		im++;
		open(_RootFolder + _List[item]);
		_FileName = split(_List[item],"."); 
		_FileName = _FileName[0];
		print(_FileName);
		
		//run("Z Project...", "start=1 stop=500 projection=[Max Intensity]");
		run("Copy");
		close();
		//close();
		
		selectWindow("MaxProjs");
		setSlice(im);
		run("Paste");
		setMetadata("Label",_FileName);
	}
	item++;
}


// Saving max projection stack

run("Save", "save=" +  _RootFolder + "/input_output/" + "DIC_MaxProjs.tif");
selectWindow("DIC_MaxProjs.tif");
close();


////////////////////////////////////////////////////////
/// Selecting TIFF images for Actin and save as a stack
////////////////////////////////////////////////////////


item = 0;
ntiff = 0;
_List = getFileList(_RootFolder);
while (item < _List.length)  {
	if ( endsWith(_List[item],"_Actin_cropped.tiff") ) {
		if (ntiff==0) {
			open(_RootFolder + _List[item]);
			w = getWidth();
			h = getHeight();
			close();
		}
		ntiff++;
	}
	item++;
}
if (ntiff== 0) {
	showMessage("No TIFF files were found.");
} else {
	print("Number of TIFF files: " + ntiff);
}

// Generating the max projection stack

newImage("MaxProjs", "16-bit black", w, h, ntiff);

item = 0; im = 0;
while (item < _List.length)  {
	if ( endsWith(_List[item],"_Actin_cropped.tiff") ) {
		im++;
		open(_RootFolder + _List[item]);
		_FileName = split(_List[item],"."); 
		_FileName = _FileName[0];
		print(_FileName);
		
		//run("Z Project...", "start=1 stop=500 projection=[Max Intensity]");
		run("Copy");
		close();
		//close();
		
		selectWindow("MaxProjs");
		setSlice(im);
		run("Paste");
		setMetadata("Label",_FileName);
	}
	item++;
}


// Saving max projection stack

run("Save", "save=" +  _RootFolder + "/input_output/" + "Actin_MaxProjs.tif");
selectWindow("Actin_MaxProjs.tif");
close();

////////////////////////////////////////////////////////
/// This portion adjust LUTs in slices of MaxProjs file to a set value
////////////////////////////////////////////////////////

//DAPI

open(_RootFolder + "/input_output/" + "DAPI_MaxProjs.tif");
for (i=1; i<= nSlices; i++) {
      showProgress(i, nSlices);
      run("Enhance Contrast", "saturated=0.012"); //CAN ADJUST THE SATURATED VALUE HERE TO WHAT SUITS YOUR EXPERIMENT
      run("Apply LUT", "slice");
      run("Next Slice [>]");
}
save(_RootFolder + "/input_output/" + "DAPI_MaxProjs_individual_slice_LUTS.tif");
selectWindow("DAPI_MaxProjs.tif");
close();


//FOX-O

open(_RootFolder + "/input_output/" + "FOXO_MaxProjs.tif");
for (i=1; i<= nSlices; i++) {
      showProgress(i, nSlices);
      run("Enhance Contrast", "saturated=0.015"); //CAN ADJUST THE SATURATED VALUE HERE TO WHAT SUITS YOUR EXPERIMENT
      run("Apply LUT", "slice");
      run("Next Slice [>]");
}
save(_RootFolder + "/input_output/" + "FOXO_MaxProjs_individual_slice_LUTS.tif");
selectWindow("FOXO_MaxProjs.tif");
close();

//DIC

open(_RootFolder + "/input_output/" + "DIC_MaxProjs.tif");
for (i=1; i<= nSlices; i++) {
      showProgress(i, nSlices);
      run("Enhance Contrast", "saturated=0.012"); //CAN ADJUST THE SATURATED VALUE HERE TO WHAT SUITS YOUR EXPERIMENT
      run("Apply LUT", "slice");
      run("Next Slice [>]");
}
save(_RootFolder + "/input_output/" + "DIC_MaxProjs_individual_slice_LUTS.tif");
selectWindow("DIC_MaxProjs.tif");
close();

//Actin

open(_RootFolder + "/input_output/" + "Actin_MaxProjs.tif");
for (i=1; i<= nSlices; i++) {
      showProgress(i, nSlices);
      run("Enhance Contrast", "saturated=0.2"); //CAN ADJUST THE SATURATED VALUE HERE TO WHAT SUITS YOUR EXPERIMENT
      run("Apply LUT", "slice");
      run("Next Slice [>]");
}
save(_RootFolder + "/input_output/" + "Actin_MaxProjs_individual_slice_LUTS.tif");
selectWindow("Actin_MaxProjs.tif");
close();

////////////////////////////////////////////////////////
//Combine PNG & TIFFs into one stack, label each slices
////////////////////////////////////////////////////////

//open stacks created above

open(_RootFolder + "/input_output/" + "DAPI_MaxProjs_individual_slice_LUTS.tif");
open(_RootFolder + "/input_output/" + "FOXO_MaxProjs_individual_slice_LUTS.tif");
open(_RootFolder + "/input_output/" + "DIC_MaxProjs_individual_slice_LUTS.tif");
open(_RootFolder + "/input_output/" + "Actin_MaxProjs_individual_slice_LUTS.tif");
open(_RootFolder + "/input_output/" + "stackPNGs.tif");
open(_RootFolder + "/input_output/" + "stacknucPNGs.tif");
open(_RootFolder + "/input_output/" + "stackcytoPNGs.tif");


//label the DIC stack & merge with DAPI, change type to RGB
selectWindow("DIC_MaxProjs_individual_slice_LUTS.tif");
run("Set Label...");
run("Label...", "format=Label starting=0 interval=1 x=5 y=20 font=40 text=[] range=1-1073");

run("Merge Channels...", "c3=DAPI_MaxProjs_individual_slice_LUTS.tif c4=DIC_MaxProjs_individual_slice_LUTS.tif create");
run("RGB Color", "slices keep");
rename("DAPI_DIC");

//label the Actin stack & change type to RGB
selectWindow("Actin_MaxProjs_individual_slice_LUTS.tif");
run("RGB Color");
selectWindow("Actin_MaxProjs_individual_slice_LUTS.tif");
run("Set Label...");
run("Label...", "format=Label starting=0 interval=1 x=5 y=20 font=40 text=[] range=1-1073");

//label the FOXO stack & change type to RGB
selectWindow("FOXO_MaxProjs_individual_slice_LUTS.tif");
run("RGB Color");
selectWindow("FOXO_MaxProjs_individual_slice_LUTS.tif");
run("Set Label...");
run("Label...", "format=Label starting=0 interval=1 x=5 y=20 font=40 text=[] range=1-1073");

//label the cell stack & change type to RGB
selectWindow("stackPNGs.tif");
run("RGB Color");
run("Label...", "format=Label starting=0 interval=1 x=5 y=45 font=40 text=[] range=1-1073");

//label the nuclear stack & change type to RGB
selectWindow("stacknucPNGs.tif");
run("RGB Color");
run("Label...", "format=Label starting=0 interval=1 x=5 y=45 font=40 text=[] range=1-1073");

//label the cytosol stack & change type to RGB
selectWindow("stackcytoPNGs.tif");
run("RGB Color");
run("Label...", "format=Label starting=0 interval=1 x=5 y=45 font=40 text=[] range=1-1073");



//combine stacks into one file & save
run("Combine...", "stack1=DAPI_DIC stack2=FOXO_MaxProjs_individual_slice_LUTS.tif");
run("Combine...", "stack1=[Combined Stacks] stack2=Actin_MaxProjs_individual_slice_LUTS.tif");
rename("stack");
run("Combine...", "stack1=stacknucPNGs.tif stack2=stackcytoPNGs.tif");
run("Combine...", "stack1=[Combined Stacks] stack2=stackPNGs.tif");
run("Combine...", "stack1=stack stack2=[Combined Stacks] combine");


save(_RootFolder + "/input_output/" + "CellProfiler_output.tif");


//

