################################################################################
# Functions:
################################################################################
getGeneFilteredGeneExprMatrix <- function(gene_expression_counts) {
  # if (!is.null(ONLY_USE_GENES)) {
  #     useGenes = colnames(gene_expression_counts)
  #     useGenes = useGenes[useGenes %in% ONLY_USE_GENES]
  #     gene_expression_counts = gene_expression_counts[, useGenes]
  #     writeLines(paste("\nLimiting expression data to ", length(useGenes), " genes specified by the ONLY_USE_GENES parameter.", sep=""))
  # }
  
  # Make edgeR object:
  MATRIX.ALL_GENES = DGEList(counts=gene_expression_counts, genes=rownames(gene_expression_counts))
  
  # Keep genes with at least MIN_GENE_CPM count-per-million reads (cpm) in at least (MIN_SAMPLE_PERCENT_WITH_MIN_GENE_CPM)% of the samples:
  #Gabriel: version-2: new low-expression gene cutoff: this is due to PCA test on different cutoff to see the batch effect converge
  fracSamplesWithMinCPM = rowSums(cpm(MATRIX.ALL_GENES) >MIN_GENE_CPM)
  isNonLowExpr = fracSamplesWithMinCPM >= MIN_SAMPLE_PERCENT_WITH_MIN_GENE_CPM*ncol(gene_expression_counts)
  
  #Gabriel: version-1.
  #fracSamplesWithMinCPM = rowSums(cpm(MATRIX.ALL_GENES) >1)
  #isNonLowExpr = fracSamplesWithMinCPM >= 50
  #ORG Menachem
  #fracSamplesWithMinCPM = rowMeans(cpm(MATRIX.ALL_GENES) >=MIN_GENE_CPM)
  #isNonLowExpr = fracSamplesWithMinCPM >= MIN_SAMPLE_PERCENT_WITH_MIN_GENE_CPM
  
  
  
  MATRIX.NON_LOW_GENES = MATRIX.ALL_GENES[isNonLowExpr, ]
  writeLines(paste("\nWill normalize expression counts for ", nrow(MATRIX.NON_LOW_GENES), " genes (those with a minimum of ", MIN_GENE_CPM, " CPM in at least ", sprintf("%.2f", 100 * MIN_SAMPLE_PERCENT_WITH_MIN_GENE_CPM), "% of the ", ncol(MATRIX.NON_LOW_GENES), " samples).", sep=""))
  
  
  # FRACTION_BIN_WIDTH = 0.02
  # plotFracSamplesWithMinCPM = data.frame(GeneFeature=names(fracSamplesWithMinCPM), fracSamplesWithMinCPM=as.numeric(fracSamplesWithMinCPM))
  # gRes = ggplot(plotFracSamplesWithMinCPM, aes(x=fracSamplesWithMinCPM))
  # gRes = gRes + geom_vline(xintercept=MIN_SAMPLE_PERCENT_WITH_MIN_GENE_CPM, linetype="solid", col="red")
  # gRes = gRes + geom_histogram(color="black", fill="white", binwidth=FRACTION_BIN_WIDTH) #+ scale_x_log10()
  # gRes = gRes + xlab(paste("Fraction of samples with at least ", MIN_GENE_CPM, " CPM", sep="")) + ylab("# of genes")
  
  return(list(filteredExprMatrix=MATRIX.NON_LOW_GENES, plotHist=NULL))
}
