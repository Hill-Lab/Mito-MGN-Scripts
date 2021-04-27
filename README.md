# Mito-MGN-Scripts 
Created by Megan Cleland Harwig for the following article in submission:
> "Synchronous Effects of Targeted Mitochondrial Complex I Inhibitors on Tumor and Immune Cells Abrogate Melanoma Progression"

Mahmoud Abu Eid, Donna M. McAllister, Laura McOlash, Megan Cleland Harwig, Gang Cheng,  Donovan Drouillard, Kathleen A. Boyle, Jacek Zielonka, Bryon D. Johnson, R Blake Hill, Balaraman Kalyanaraman and Michael B. Dwinell


**Files Included**
>*ImageJ macros*:
1. splitchannel4_maxproj_GitHub.ijm (prepare single channel maximum intensity projections
2. CellProfiler_output_stacks_GitHub.ijm (compile CellProfiler output images)</li>

>*CellProfile pipeline*:
1. cytoplasm_nuclear_FOXO_github.cpproj</li>
2. test images: 
  * DAPIb_FOXOg_Actinr_vehicle_N1_1003_ch1.tif (DAPI channel)
  * DAPIb_FOXOg_Actinr_vehicle_N1_1003_ch2.tif (FOXO channel)
  * DAPIb_FOXOg_Actinr_vehicle_N1_1003_ch3.tif (Actin channel)
  * DAPIb_FOXOg_Actinr_vehicle_N1_1003_ch4.tif (DIC channel)
 
>*Rscripts*:
1.  nuclear_v_cyto.R (R script to process CellProfiler output)
2.  nuclear_v_cyto.html (html file for output of experiment collected for the Mito-MGN manuscript)

**Process Images for Analysis of Nuclear and Cytoplasmic Means**

>*Prepare images for processing*: 

4 channel .nd2 images (DAPI, anti-FOX-O (alex-488), alexa-568 phalloidin and DIC were processed into Maximum Intensity Projections (first 7 slices; to avoid out of focus/below nuclei portion) single channel TIFF files using *splitchannel4_maxproj_GitHub.ijm*
  
>*CellProfiler pipeline*: 

All 4 channel single channel TIFF files were set as input images for the CellProfiler script. Note that this script was modified from the CellProfiler example that demonstrated the quantification of cytosol to nuclear translocation (https://cellprofiler.org/examples). 

screenshot of CellProfiler pipeline
<img width="1287" alt="Screen Shot 2021-04-27 at 3 29 15 PM" src="https://user-images.githubusercontent.com/34748371/116308700-74ee9a00-a76d-11eb-8a1c-834547f30916.png">


>*Compile images from CellProfiler pipeline*:

Cropped/illumination corrected single channels DAPI/FOX-O/ACTIN/DIC and object masks (Nuclei,Cell & Cytoplasm) were compiled using ImageJ macro *CellProfiler_output_stack_GitHub.ijm*

Example of CellProfiler Output files compiled using ImageJ macro:
![image](https://user-images.githubusercontent.com/34748371/115754563-ef7c7b80-a361-11eb-8320-79e5caad6542.png)

>Calculate nuclear mean FOX-O / cytoplasmic mean FOX-O ratio*: 
1. .csv files for the objects (cell, nuclei & cytoplasm) were calculated using R
2. Boxplots were generated from the dataset
3. nuclear_v_cyto.R is the R script used to process the CellProfiler output .csv files
4. nuclear_v_cyto.html is the compiled HTML report from all 6 replicates tested for this manuscript
 

