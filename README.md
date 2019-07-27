# IDEA
Unified pipeline for RNA-seq data procesing:

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
|--Data
|     | - Raw
|     |     |- md5.txt
|     |     |-> Manifest
|     |     |    |- Experimental_Condition_1.manifest
|     |     |    |- Experimental_Condition_1.manifest
|     |     |    ...
|     |     |    |- Experimental_Condition_N.manifest
|     |     |-> Experimental_Condition_1
|     |     |    |- ID_bla-bla.htseq.counts
|     |     |-> Experimental_Condition_2
|     |     |    |- ID_bla-bla.htseq.counts
|     |     |...
|     |     |-> Experimental_Condition_N
|     |          |- ID_bla-bla.htseq.counts
|     | - Summarized_Experiment                  
|           |- Out.RData
|--R
   |- ReadData.R
```

- The md5.txt contains the md5 data for each file.
- The Manifest folder contains the respective sample metadata in a tab separeted format.
- The Experimental-Condition-X folder contains the respective htseq.counts data files. For example:
``` 
  Ensembl_ID.Version \t Raw_Counts
  ENSG000000003.13      25
```
- The Summarized_Experiment folder contains the RData object.
- The R directory contains the different R files.







         
