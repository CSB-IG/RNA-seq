####################################################
##  Annotation Biomart
####################################################

source("./requirements.R")

option_list = list(
  make_option(
    c("-b", "--biomaRt"),  
    type = "character", 
    default = NULL, 
    help = "Ensembl host", 
    metavar = "integer"
  )
)
opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)

ensembl <- useMart(biomart = "ensembl",
                   host = opt$biomaRt, 
                   dataset = "hsapiens_gene_ensembl")

attributes <- c("ensembl_gene_id",
                "hgnc_symbol",
                "chromosome_name", 
                "start_position", 
                "end_position", 
                "percentage_gene_gc_content",
                "band",
                "gene_biotype")

annot <- getBM(mart = ensembl, attributes = attributes)


