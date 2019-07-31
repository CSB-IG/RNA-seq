####################################################
##  Annotation Biomart
####################################################

source("R/requirements.R")
tryCatch({
  load("output/summarized_experiment/SE_RNAseq.RData")
  }, error = function(e) {
    stop("SummirizedExperiment object not found")
  }
)

option_list = list(
  make_option(
    c("-b", "--biomaRt"),  
    type = "character", 
    default = "www.ensembl.org", 
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
annot <- annot[!duplicated(annot$ensembl_gene_id), ]
row.names(annot) <- annot$ensembl_gene_id
inter <- intersect(rnaSeq@NAMES, annot$ensembl_gene_id)
rnaSeq <- rnaSeq[inter,]
annot <- annot[inter,]
annotData <- merge(annot, rowData(rnaSeq), by = "row.names")
rownames(annotData) <- annotData$ensembl_gene_id
rowData(rnaSeq) <- annotData

