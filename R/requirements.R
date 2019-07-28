#############################################################
## R scripts requirements
#############################################################
## IDEA: Test if the required packages are installed and 
##       install the missing packages.
## Final: The script should end without 
#############################################################
##Required packages  
rPackages <- c(
  "tidyverse",
  "optparse",
  "jsonlite"
)
bioconductorPackages <- c(
  "BiocParallel",
  "SummarizedExperiment",
  "biomaRt",
  "Biobase"
)

##Test packages
testPackage <- function(x){
  result <- lapply(x, require, character.only = TRUE)
  result <- unlist(result)
  return(result)
}

#Checking Packages
resultR <- testPackage(rPackages)
resultBioconductor <- testPackage(bioconductorPackages)

##Install R Packages
if(any(resultR == FALSE)){
  out <- lapply(
    rPackages[resultR == FALSE], 
    install.packages
  )
  resultR <- testPackage(rPackages)
}
stopifnot(resultR)

##Install Bioconductor Packages
if(any(resultBioconductor == FALSE)){
  out <- lapply(
    bioconductorPackages[resultBioconductor == FALSE], 
    BiocManager::install
  )
  resultBioconductor <- testPackage(bioconductorPackages)
}

stopifnot(resultBioconductor)
#############################################################