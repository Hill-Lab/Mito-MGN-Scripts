# Mito-MGN-Scripts

Created by Megan Cleland Harwig for the following published article:

Mahmoud AbuEid, Donna M. McAllister, Laura McOlash, Megan Cleland Harwig, Gang Cheng, Donovan Drouillard, Kathleen A. Boyle, Micael Hardy, Jacek Zielonka, Bryon D. Johnson, R. Blake Hill, Balaraman Kalyanaraman, Michael B. Dwinell,

# Synchronous effects of targeted mitochondrial complex I inhibitors on tumor and immune cells abrogate melanoma progression,
iScience,
Volume 24, Issue 6,
2021,
102653,
ISSN 2589-0042,
https://doi.org/10.1016/j.isci.2021.102653.
(https://www.sciencedirect.com/science/article/pii/S2589004221006210)
>Metabolic heterogeneity within the tumor microenvironment promotes cancer cell growth and immune suppression. We determined the impact of mitochondria-targeted complex I inhibitors (Mito-CI) in melanoma. Mito-CI decreased mitochondria complex I oxygen consumption, Akt-FOXO signaling, blocked cell cycle progression, melanoma cell proliferation and tumor progression in an immune competent model system. Immune depletion revealed roles for T cells in the antitumor effects of Mito-CI. While Mito-CI preferentially accumulated within and halted tumor cell proliferation, it also elevated infiltration of activated effector T cells and decreased myeloid-derived suppressor cells (MDSC) as well as tumor-associated macrophages (TAM) in melanoma tumors in vivo. Anti-proliferative doses of Mito-CI inhibited differentiation, viability, and the suppressive function of bone marrow-derived MDSC and increased proliferation-independent activation of T cells. These data indicate that targeted inhibition of complex I has synchronous effects that cumulatively inhibits melanoma growth and promotes immune remodeling.
Keywords: Components of the immune system; Cell biology; Cancer

https://www.sciencedirect.com/science/article/pii/S2589004221006210#:~:text=Mito-CI%20decreased%20mitochondria%20complex%20I%20oxygen%20consumption%2C%20Akt-FOXO,T%20cells%20in%20the%20antitumor%20effects%20of%20Mito-CI.

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
 

