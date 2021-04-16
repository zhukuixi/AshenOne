


library(Seurat)
library(tidyverse)
rm(list=ls())
setwd("D:/JooGitRepo/RainyNight/scRNAseq/")
dir.create("QC")
## create seurat object
scRNA.counts <- Read10X(data.dir = "./input/pbmc_10k_v3_filtered_feature_bc_matrix/filtered_feature_bc_matrix")    

try({scRNA = CreateSeuratObject(scRNA.counts[['Gene Expression']])},silent=T)
if(exists('scRNA')){} else {scRNA = CreateSeuratObject(scRNA.counts)}
#table(scRNA@meta.data$orig.ident)         #check cell number

## Computation metrics used in QC

#
#
#nFeature_RNA is the number of genes detected in each cell. nCount_RNA is the total number of molecules
#detected within a cell. Low nFeature_RNA for a cell indicates that it may be dead/dying or an empty
#droplet. High nCount_RNA and/or nFeature_RNA indicates that the "cell" may in fact be a doublet
#(or multiplet). In combination with %mitochondrial reads, removing outliers from these groups removes
#most doublets/dead cells/empty droplets, hence why filtering is a common pre-processing step.
#
#The NormalizeData step is basically just ensuring expression values across cells are on a comparable 
#scale. By default, it will divide counts for each gene by the total counts in the cell, multiply that
#value for each gene by the scale.factor (10,000 by default), and then natural log-transform them.
#
#


# Compute the proportion of mitochondrial gene
scRNA[["percent.mt"]] <- PercentageFeatureSet(scRNA, pattern = "^MT-")
# Compute the proportion of red cell
HB.genes <- c("HBA1","HBA2","HBB","HBD","HBE1","HBG1","HBG2","HBM","HBQ1","HBZ")
HB_m <- match(HB.genes, rownames(scRNA@assays$RNA)) 
HB.genes <- rownames(scRNA@assays$RNA)[HB_m] 
HB.genes <- HB.genes[!is.na(HB.genes)] 
scRNA[["percent.HB"]]<-PercentageFeatureSet(scRNA, features=HB.genes) 
#head(scRNA@meta.data)

col.num <- length(levels(scRNA@active.ident))
violin <- VlnPlot(scRNA,
                  features = c("nFeature_RNA", "nCount_RNA", "percent.mt","percent.HB"), 
                  cols =rainbow(col.num), 
                  pt.size = 0.01, #不需要显示点，可以设置pt.size = 0
                  ncol = 4) + 
  theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) 

ggsave("./QC/vlnplot_before_qc.pdf", plot = violin, width = 12, height = 6) 
ggsave("./QC/vlnplot_before_qc.png", plot = violin, width = 12, height = 6)  
plot1 <- FeatureScatter(scRNA, feature1 = "nCount_RNA", feature2 = "percent.mt")
plot2 <- FeatureScatter(scRNA, feature1 = "nCount_RNA", feature2 = "nFeature_RNA")
plot3 <- FeatureScatter(scRNA, feature1 = "nCount_RNA", feature2 = "percent.HB")
pearplot <- CombinePlots(plots = list(plot1, plot2, plot3), nrow=1, legend="none") 
ggsave("./QC/pearplot_before_qc.pdf", plot = pearplot, width = 12, height = 5) 
ggsave("./QC/pearplot_before_qc.png", plot = pearplot, width = 12, height = 5)


## Set up filtering cutoff for QC
minGene=500
maxGene=4000
pctMT=15

## QC filtering
scRNA <- subset(scRNA, subset = nFeature_RNA > minGene & nFeature_RNA < maxGene & percent.mt < pctMT)
col.num <- length(levels(scRNA@active.ident))
violin <-VlnPlot(scRNA,
                 features = c("nFeature_RNA", "nCount_RNA", "percent.mt","percent.HB"), 
                 cols =rainbow(col.num), 
                 pt.size = 0.1, 
                 ncol = 4) + 
  theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) 
ggsave("QC/vlnplot_after_qc.pdf", plot = violin, width = 12, height = 6) 
ggsave("QC/vlnplot_after_qc.png", plot = violin, width = 12, height = 6)
scRNA <- NormalizeData(scRNA, normalization.method = "LogNormalize", scale.factor = 10000)

##保存中间结果
saveRDS(scRNA, file="scRNA.rds")
