####################################################
##  Read Data
####################################################
source("R/requirements.R")

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

experimentalConditions <- list.dirs(path = opt$dataDir, 
                                    recursive = FALSE)
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
                   col.names = c("ensembl_id", "raw_counts"))
  
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
  targets <- data.frame(file = conditionFiles, 
                        "id" = paste(expCondition,
                                   1:length(conditionFiles), 
                                   sep = "_"), 
                        experimetal_condition = expCondition)
  colnames(countData) <- targets$id
  
  ##Let's change the annotation 
  genes <- do.call(rbind,
                   sapply(genes[,1], strsplit, split=".", fixed=TRUE))
  colnames(genes) <- c("ensembl_id", "version")
  rownames(genes) <- genes[,1]
  
  ##Save clean data
  countData <- list(counts = countData, annot = genes, targets = targets)
  return(countData)
}

countDataAllConditions <- lapply(experimentalConditions, 
                                 getExperimentalConditionData, 
                                 dataDir = opt$dataDir)
### Check all annot
allAnnotations <- lapply(countDataAllConditions, "[[", "annot")

##Check if the genes match positions
genes <- do.call(
  cbind, 
  lapply(allAnnotations, function(x){
    as.character(x[,1])
  })
)
genes <- t(unique(t(genes)))
message("Checking that genes match positions in all conditions.")
size <- unique(do.call(rbind, lapply(allAnnotations, dim)))
stopifnot(dim(genes) == c(size[1,1], 1))

annot <- allAnnotations[[1]]

targets <- lapply(countDataAllConditions, "[[", "targets")
targets <- do.call(rbind, targets)

counts <- lapply(countDataAllConditions, "[[", "counts")
counts <- do.call(cbind, counts)

rnaSeq <- SummarizedExperiment(assays=list(counts=counts),
                     rowData=annot, colData=targets)
rnaSeq
