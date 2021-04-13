

rm(list = ls()) 

# https://bioconductor.org/packages/release/bioc/html/GEOquery.html
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager") 


# Install
if(!require("KEGG.db")) BiocManager::install("KEGG.db",ask = F,update = F)
if(!require("GSEABase")) BiocManager::install("GSEABase",ask = F,update = F)
if(!require("GSVA")) BiocManager::install("GSVA",ask = F,update = F)
if(!require("clusterProfiler")) BiocManager::install("clusterProfiler",ask = F,update = F)
if(!require("GEOquery")) BiocManager::install("GEOquery",ask = F,update = F)
if(!require("impute")) BiocManager::install("impute",ask = F,update = F)
if(!require("genefu")) BiocManager::install("genefu",ask = F,update = F)
if(!require("org.Hs.eg.db")) BiocManager::install("org.Hs.eg.db",ask = F,update = F)
if(!require("hgu133plus2.db")) BiocManager::install("hgu133plus2.db",ask = F,update = F)
if(!require("ConsensusClusterPlus")) BiocManager::install("ConsensusClusterPlus",ask = F,update = F)


if(!require("maftools")) BiocManager::install("maftools",ask = F,update = F)
if(!require("genefilter")) BiocManager::install("genefilter",ask = F,update = F)
if(!require("CLL")) BiocManager::install("CLL",ask = F,update = F)
if(!require("RTCGA")) BiocManager::install("RTCGA",ask = F,update = F)
if(!require("RTCGA.clinical")) BiocManager::install("RTCGA.clinical",ask = F,update = F)
if(! require("RTCGA.miRNASeq")) BiocManager::install("RTCGA.miRNASeq",ask = F,update = F)



if(!require("airway")) BiocManager::install("airway",update = F,ask = F)
if(!require("DESeq2")) BiocManager::install("DESeq2",update = F,ask = F)
if(!require("edgeR")) BiocManager::install("edgeR",update = F,ask = F)
if(!require("limma")) BiocManager::install("limma",update = F,ask = F)

if(!require("WGCNA")) install.packages("WGCNA",update = F,ask = F)
if(!require("FactoMineR")) install.packages("FactoMineR",update = F,ask = F)
if(!require("factoextra")) install.packages("factoextra",update = F,ask = F)
if(!require("ggplot2")) install.packages("ggplot2",update = F,ask = F)
if(!require("pheatmap")) install.packages("pheatmap",update = F,ask = F)
if(!require("ggpubr")) install.packages("ggpubr",update = F,ask = F)
if(!require("glmnet")) install.packages("glmnet",update = F,ask = F)
if(!require("randomForest")) install.packages("randomForest",update = F,ask = F)

if(!require("devtools")) install.packages("devtools",update = F,ask = F)
if(!require("reshape2")) install.packages("reshape2",update = F,ask = F)
if(!require("ggfortify")) install.packages("ggfortify",update = F,ask = F)
if(!require("stringr")) install.packages("stringr",update = F,ask = F)
if(!require("survival")) install.packages("survival",update = F,ask = F)
if(!require("survminer")) install.packages("survminer",update = F,ask = F)

if(!require("lars")) install.packages("lars",update = F,ask = F)
if(!require("timeROC")) install.packages("timeROC",update = F,ask = F)
if(!require("ROCR")) install.packages("ROCR",update = F,ask = F)
if(!require("Hmisc")) install.packages("Hmisc",update = F,ask = F)
if(!require("caret")) install.packages("caret",update = F,ask = F)
if(!require("ggstatsplot")) install.packages("ggstatsplot",update = F,ask = F)
if(!require("tableone")) install.packages("tableone",update = F,ask = F)



