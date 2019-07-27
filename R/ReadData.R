####################################################
##  Read Data
####################################################
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



