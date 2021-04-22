# Mito-MGN-Scripts 
Created by Megan Cleland Harwig for the following article in submission:
> "Synchronous Effects of Targeted Mitochondrial Complex I Inhibitors on Tumor and Immune Cells Abrogate Melanoma Progression"
>>Mahmoud Abu Eid, Donna M. McAllister, Laura McOlash, Megan Cleland Harwig, Gang Cheng,  Donovan Drouillard, Kathleen A. Boyle, Jacek Zielonka, Bryon D. Johnson, R Blake Hill, Balaraman Kalyanaraman and Michael B. Dwinell

*Prepare images for processing*: 
>4 channel .nd2 images (DAPI, anti-FOX-O (alex-488), alexa-568 phalloidin and DIC were processed into Maximum Intensity Projections (first 7 slices; to avoid out of focus/below nuclei portion) single channel TIFF files using *splitchannel4_maxproj_GitHub.ijm*
  
*CellProfiler pipeline*: 
>All 4 channel single channel TIFF files were set as input images for the CellProfiler script. Note that this script was modified from the CellProfiler example that demonstrated the quantification of cytosol to nuclear translocation (https://cellprofiler.org/examples). 
>

*Compile images from CellProfiler pipeline*:
>Cropped/illumination corrected single channels DAPI/FOX-O/ACTIN/DIC and object masks (Nuclei,Cell & Cytoplasm) were compiled using ImageJ macro *CellProfiler_output_stack_GitHub.ijm*

Example of CellProfiler Output files:
![image](https://user-images.githubusercontent.com/34748371/115754563-ef7c7b80-a361-11eb-8320-79e5caad6542.png)

*Calculate nuclear mean FOX-O / cytoplasmic mean FOX-O ratio*: 
>.csv files for the objects (cell, nuclei & cytoplasm) were calculated using R
> Boxplots were generated from the dataset
>> nuclear_v_cyto.R is the R script used to process the CellProfiler output .csv files
>> nuclear_v_cyto.html is the compiled HTML report from all 6 replicates tested
