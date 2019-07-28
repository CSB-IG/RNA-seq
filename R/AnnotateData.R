####################################################
##  Annotation Biomart
####################################################

source("./requirements.R")

option_list = list(
  make_option(
    c("-b", "--biomaRt"),  
    type = "integer", 
    default = 94, 
    help = "Ensembl version", 
    metavar = "integer"
  )
)
opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)