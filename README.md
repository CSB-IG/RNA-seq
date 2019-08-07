# IDEA
Unified pipeline for RNA-seq data procesing:

# Contribuing
Please check our [Contribuing](https://github.com/CSB-IG/RNA-seq/blob/master/CONTRIBUTING.md) page.

# Warning
All scripts should be executed from `RNA-seq` (main directory).
  - e.g. `$ Rscript ./R/ReadData.R` 

# Pre-conditions
- The raw data files are already downloaded from [GDC](https://gdc.cancer.gov).
- The raw data is organized accorgding to the Data Structure section.
- The raw data has been cuantified using htseq for hg38.pXX Human genome. 
- R required packages according to respective section.

# Post-conditions
- Obtain the normalized expression matrix.
- The data is stored in a [Summarized Experiment object](https://bioconductor.org/packages/release/bioc/vignettes/SummarizedExperiment/inst/doc/SummarizedExperiment.html).

## Data Structure

The data follows this directory structure

```
The data follows this directory structure
|--data
|     | - raw
|     |     |- metadata.txt
|     |     |-> manifest
|     |     |    |- experimentalcondition1.manifest
|     |     |    |- experimentalcondition1.manifest
|     |     |    ...
|     |     |    |- experimentalconditionN.manifest
|     |     |-> experimentalcondition1
|     |     |    |- ID_bla-bla.htseq.counts
|     |     |-> experimentalcondition2
|     |     |    |- ID_bla-bla.htseq.counts
|     |     |...
|     |     |-> experimentalconditionN
|     |          |- ID_bla-bla.htseq.counts
|     | - summarized_experiment                  
|           |- Out.RData
|--R
   |- ReadData.R
```

- The md5.txt contains the md5 data for each file.
- The metadata.txt file contains all metadata for each sample.
- The Manifest folder contains the respective sample metadata in a tab separeted format.
- The Experimental-Condition-X folder contains the respective htseq.counts data files. For example:
``` 
  Ensembl_ID.Version \t Raw_Counts
  ENSG000000003.13      25
```
- The Summarized_Experiment folder contains the RData object.
- The R directory contains the different R files.

## R

__requirements.R__
- Check if the required R and Bioconductor packages are installed
- Install the R and Bioconductor missing packages

__ReadData.R__
1. Read Experimental Data
3. Read Biomart Data
4. Merge count and annotations

# Conventions

 - Variable and function names: camel case.
 - Column names: lower case and underscore notation.
 - Experimental condition names: lower case without underscore.
 - Folder names: lower case with underscore. 
 - 80 characters per line.
 - Function definition: above. 
 - Source code file name: lower case without underscore. 
 


         
