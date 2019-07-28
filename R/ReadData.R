####################################################
##  Read Data
####################################################
source("./requirements.R")

option_list = list(
  make_option(
    c("-c", "--cores"),  
    type = "integer", 
    default = 1, 
    help = "Number of cores to use by biocparallel", 
    metavar = "integer"
  ), 
  make_option(
    c("-d", "--dataDir"),  
    type = "character", 
    default = "data/raw", 
    help = "Path to raw data directory", 
    metavar = "character"
  )
)
opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)

register(MulticoreParam(workers = opt$cores, progress = TRUE))#Linux

experimentalConditions <- list.dirs(path = opt$dataDir)
experimentalConditions <- gsub(
  pattern = opt$dataDir, 
  replacement = "",
  experimentalConditions
)
experimentalConditions <- gsub(
  pattern = "^/", 
  replacement = "",
  experimentalConditions
)
experimentalConditions <- experimentalConditions[
  !experimentalConditions %in% c("", "manifest")
]

getExperimentalConditionData <- function(expCondition, dataDir) {
  
  conditionFiles <- dir(full.names = TRUE, pattern = "*.htseq.counts",
                     path = paste(dataDir, expCondition, sep = "/"))
  countData <- lapply(conditionFiles, read.delim, sep="\t", header=F, 
                   col.names = c("EnsemblID", "raw_counts"))
  
  ## Check if all samples have the same size
  size <- unique(do.call(rbind, lapply(countData, dim)))
  message("Checking that all samples have the same size.")
  stopifnot(nrow(size) == 1)
  
  ##Check if the genes match positions
  genes <- do.call(
    cbind, 
    lapply(countData, function(x){
        as.character(x[,1])
    })
  )
  genes <- t(unique(t(genes)))
  message("Checking that genes match positions.")
  stopifnot(dim(genes) == c(size[1,1], 1))
  
  ##Let's keep only the raw counts
  countData <- do.call(
      cbind, 
      lapply(countData, function(x){
        x[,"raw_counts"]
      })
  )
  targets <- data.frame(File = conditionFiles, 
                        ID = paste(expCondition, 1:length(conditionFiles), sep = "-"))
  colnames(countData) <- targets$ID
  
  ##Let's change the annotation 
  genes <- do.call(rbind,
                   sapply(genes[,1], strsplit, split=".", fixed=TRUE))
  colnames(genes) <- c("EnsemblID", "version")
  
  ##Save clean data
  countData <- list(Counts = countData, Annot = genes, Targets = targets)
  return(countData)
}

countDataAllConditions <- lapply(experimentalConditions, 
                                 getExperimentalConditionData, 
                                 dataDir = opt$dataDir)
### Check all Annot
allAnnotations <- lapply(countDataAllConditions, "[[", "Annot")

##Check if the genes match positions
genes <- do.call(
  cbind, 
  lapply(allAnnotations, function(x){
    as.character(x[,1])
  })
)
genes <- t(unique(t(genes)))
message("Checking that genes match positions in all conditions.")
stopifnot(dim(genes) == c(size[1,1], 1))

annot <- allAnnotations[[1]]

targets <- lapply(countDataAllConditions, "[[", "Targets")
targets <- do.call(rbind, targets)

counts <- lapply(countDataAllConditions, "[[", "Counts")
counts <- do.call(cbind, counts)

rnaSeq <- SummarizedExperiment(assays=list(counts=counts),
                     rowData=annot, colData=targets)
metadata(rnaSeq) <- list(RnaSeq=MIAME(
  contact = "DianaGarcia@inmegen.edu.mx",
  title = "RNA-seq experiment", 
  lab = "INMEGEN/CSB-IG",
  name = "Counts",
  url = "https://github.com/CSB-IG/RNA-seq",
  abstract = "RNA-seq trainnig"
))
rnaSeq
