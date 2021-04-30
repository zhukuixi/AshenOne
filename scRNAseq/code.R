


library(Seurat)
library(tidyverse)
library(patchwork)

rm(list=ls())
setwd("D:/JooGitRepo/RainyNight/scRNAseq/")
dir.create("QC")

##########################
## create Seurat object ##
##########################

scRNA.counts <- Read10X(data.dir = "./input/pbmc_10k_v3_filtered_feature_bc_matrix/filtered_feature_bc_matrix")    
try({scRNA = CreateSeuratObject(scRNA.counts[['Gene Expression']])},silent=T)
if(exists('scRNA')){} else {scRNA = CreateSeuratObject(scRNA.counts)}
#table(scRNA@meta.data$orig.ident)         #check cell number

####################################
## Computation metrics used in QC ##
############################################################################################################
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
############################################################################################################


## Compute the proportion of mitochondrial gene
scRNA[["percent.mt"]] <- PercentageFeatureSet(scRNA, pattern = "^MT-")

## Compute the proportion of red cell
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
                  pt.size = 0.01, # If you dont want to show dots，set pt.size = 0
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

####################################################################################
## Set up filtering cutoff for QC                                                  #
## Here you need to observe the graph generated above first and determine a cutoff #
####################################################################################
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

###################
## Normalization ##
###################
scRNA <- NormalizeData(scRNA, normalization.method = "LogNormalize", scale.factor = 10000)

## Save the intermediate result
saveRDS(scRNA, file="scRNA.rds")

#######################################
## Identify genes with high variance ##
#######################################

dir.create("cluster")
if(exists('scRNA')){} else {scRNA = readRDS("scRNA.rds")}

scRNA <- FindVariableFeatures(scRNA, selection.method = "vst", nfeatures = 2000) 
top10 <- head(VariableFeatures(scRNA), 10) 
plot1 <- VariableFeaturePlot(scRNA) 
plot2 <- LabelPoints(plot = plot1, points = top10, repel = TRUE, size=2.5) 
plot <- CombinePlots(plots = list(plot1, plot2),legend="bottom") 
ggsave("./cluster/VariableFeatures.pdf", plot = plot, width = 8, height = 6) 
ggsave("./cluster/VariableFeatures.png", plot = plot, width = 8, height = 6)

#############
## Scaling ##
#############

## If you have big memory, it is better to scale every gene
## This step is a must as we need to run PCA.
scale.genes <-  rownames(scRNA)
scRNA <- ScaleData(scRNA, features = scale.genes)
## Otherwise, you can just normalize genes with high varaince
#scale.genes <-  VariableFeatures(scRNA)
#scRNA <- ScaleData(scRNA, features = scale.genes)

##########################################################################################################################
## After normalization and scaling, we already generate 3 sets of data and we can get them by the following commands:    #
##Get the original matrix                                                                                                #
#GetAssayData(scRNA,slot="counts",assay="RNA")                                                                           #
                                                                                                                         #
##Get the normalized matrix                                                                                              #
#GetAssayData(scRNA,slot="data",assay="RNA")                                                                             #
                                                                                                                         #
##Get the scaled matrix                                                                                                  #  
#GetAssayData(scRNA,slot="scale.data",assay="RNA")                                                                       #
##########################################################################################################################


###############################################################################################
## Cell cycle scoring (This step is optional)                                                 #  
## Why we do this?                                                                            #        
## Because cells with same type can be separated in clustering due to difference in cell cycle#
###############################################################################################

## 1. Collect cell cycle related genes and mapped them to our data
## 2. Get the cell cycle scoring for each cell
## 3. Run PCA on cell cylce related genes and check the graph. Determine if it is necessary to remove the effect from cell cycle and do step 4.
## 4. Remove the cell cycle effect by regression. (Optional)

## Scoring
## After this block, there will be 3 more columns describing cell cycle info in scRNA@meta.data (S.Score,G2M.Score and Phase).
g2m_genes = cc.genes$g2m.genes
g2m_genes = CaseMatch(search = g2m_genes, match = rownames(scRNA))
s_genes = cc.genes$s.genes
s_genes = CaseMatch(search = s_genes, match = rownames(scRNA))
scRNA <- CellCycleScoring(object=scRNA,  g2m.features=g2m_genes,  s.features=s_genes)

## Determine the effect from cell cycle
scRNA_forCC <- RunPCA(scRNA, features = c(s_genes, g2m_genes))
p <- DimPlot(scRNA_forCC, reduction = "pca", group.by = "Phase")
ggsave("cluster/cellcycle_pca.png", p, width = 8, height = 6)

## Now we need to take a look at the graph. If cells get separated widely in the graph,it suggests we need to
## remove the effect of cell cycle by doing the following command :

#scRNA <- ScaleData(scRNA, vars.to.regress = c("S.Score", "G2M.Score"), features = rownames(scRNA))


############################################################################################################
## PCA for dimension reduction.                                                                            #
## You should observe the  ElbowPlot and identiy the ideal number of Top PCs used in following clustering  #
############################################################################################################

scRNA <- RunPCA(scRNA, features = VariableFeatures(scRNA)) 
plot1 <- DimPlot(scRNA, reduction = "pca", group.by="orig.ident") 
plot2 <- ElbowPlot(scRNA, ndims=20, reduction="pca") 
plotc <- plot1+plot2
ggsave("cluster/pca.pdf", plot = plotc, width = 8, height = 4) 
ggsave("cluster/pca.png", plot = plotc, width = 8, height = 4)
pc.num=1:18

##########################################################################
### Now you can observe the ElbowPlot and identiy the number of Top PCs ##
##########################################################################

##########################################################################################################################
## This section is a set of exploration. You can skip it.
## Get genes' coordiante on principle components
#Loadings(object = scRNA[["pca"]])
## Get cells' coordiante on principle components
#Embeddings(object = scRNA[["pca"]])
## Obtain the standard deviation of principle components
#Stdev(scRNA)
## Check the top 10 members of each principle component. Here we check the top 5 principle components
#print(scRNA[["pca"]], dims = 1:5, nfeatures = 10) 
## Plot the heatmap of top 10 genes of each principle component in 500 cells. Here we show the top 9 principle components
#DimHeatmap(scRNA, dims = 1:9, nfeatures=10, cells = 500, balanced = TRUE)
###########################################################################################################################

################################################################################################################################
## Cell clustering  (it is based on the coordinate of cells on PC)                                                             #    
## There are 2 parameter you need to pay attention here.                                                                       #  
## The first one is pc.num used in FindNeighbors()                                                                             #
## The second one is resolution used in FindClusters(). The larger resolution(0.1-0.9) is, the more cluster it will generate.  #
## The output csv file is the mapping between each cell and cluster.                                                           #
################################################################################################################################
scRNA <- FindNeighbors(scRNA, dims = pc.num,nn.method = 'rann') 
scRNA <- FindClusters(scRNA, resolution = 0.5)
table(scRNA@meta.data$seurat_clusters)
metadata <- scRNA@meta.data
cell_cluster <- data.frame(cell_ID=rownames(metadata), cluster_ID=metadata$seurat_clusters)
write.csv(cell_cluster,'cluster/cell_cluster.csv',row.names = F)


##########################################################################################################
## tSNE and UMAP [non-linear dimension reduction]  (it is also based on the coordinate of cells on PC)   # 
## It can visually represent the clusters computed in the last step in a 2d graph.                       #
##########################################################################################################

##tSNE
scRNA = RunTSNE(scRNA, dims = pc.num)
embed_tsne <- Embeddings(scRNA, 'tsne')
write.csv(embed_tsne,'cluster/embed_tsne.csv')
plot1 = DimPlot(scRNA, reduction = "tsne") 
ggsave("cluster/tSNE.pdf", plot = plot1, width = 8, height = 7)
ggsave("cluster/tSNE.png", plot = plot1, width = 8, height = 7)
##UMAP
scRNA <- RunUMAP(scRNA, dims = pc.num)
embed_umap <- Embeddings(scRNA, 'umap')
write.csv(embed_umap,'cluster/embed_umap.csv') 
plot2 = DimPlot(scRNA, reduction = "umap") 
ggsave("cluster/UMAP.pdf", plot = plot2, width = 8, height = 7)
ggsave("cluster/UMAP.png", plot = plot2, width = 8, height = 7)
##Combine tSNE and UMAP
plotc <- plot1+plot2+ plot_layout(guides = 'collect')
ggsave("cluster/tSNE_UMAP.pdf", plot = plotc, width = 10, height = 5)
ggsave("cluster/tSNE_UMAP.png", plot = plotc, width = 10, height = 5)
## Save the data
saveRDS(scRNA, file="scRNA.rds")


####################################################################################################################
# Identify the cell type of each cluster                                                                           #
# The heterogeneity of cells show up after clustering and dimension reduction based visulization (tSNE and UMAP).  #
# There are two ways to identiy the cell type.                                                                     #   
# 1.Using cell type specific biomarkers and see if them significantly highly expressed in a cluster.               #  
# 2.Using cell type specific transcriptome database and do the comparison. [Use SingleR package here]              #
# Overall, we need to take use two methods and finally determine the cell type of each cluster from their results  #
####################################################################################################################

############################
## Do DE for each cluster ##
############################
dir.create("cell_identify")

## Use one of the method. Recommend the first default method.
# Default method: wilcox
diff.wilcox = FindAllMarkers(scRNA)
all.markers = diff.wilcox %>% subset(p_val<0.05)
top10 = all.markers %>% group_by(cluster) %>% top_n(n = 10, wt = avg_log2FC)
write.csv(all.markers, "cell_identify/diff_genes_wilcox.csv", row.names = F)
write.csv(top10, "cell_identify/top10_diff_genes_wilcox.csv", row.names = F)


# method:MAST (specifically designed for scRNAseq)
#diff.mast = FindAllMarkers(scRNA, test.use = 'MAST')
#all.markers = diff.mast %>% select(gene, everything()) %>% subset(p_val<0.05)
#top10 = all.markers %>% group_by(cluster) %>% top_n(n = 10, wt = avg_logFC)
#write.csv(all.markers, "cell_identify/diff_genes_mast.csv", row.names = F)
#write.csv(top10, "cell_identify/top10_diff_genes_mast.csv", row.names = F)

# method: Deseq2
#diff.deseq2 = FindAllMarkers(scRNA, test.use = 'DESeq2', slot = 'counts')
#all.markers = diff.deseq2 %>% select(gene, everything()) %>% subset(p_val<0.05)
#top10 = all.markers %>% group_by(cluster) %>% top_n(n = 10, wt = avg_logFC)
#write.csv(all.markers, "cell_identify/diff_genes_deseq2.csv", row.names = F)
#write.csv(top10, "cell_identify/top10_diff_genes_deseq2.csv", row.names = F)

## Draw heatmap for top10 DE gene 
top10_genes <- read.csv("cell_identify/top10_diff_genes_wilcox.csv")
top10_genes = CaseMatch(search = as.vector(top10_genes$gene), match = rownames(scRNA)) 
plot1 = DoHeatmap(scRNA, features = top10_genes, group.by = "seurat_clusters", group.bar = T, size = 4)
ggsave("cell_identify/top10_markers.pdf", plot=plot1, width=8, height=6) 
ggsave("cell_identify/top10_markers.png", plot=plot1, width=8, height=6)

################################################################################################################################
## Method 1:1.Using cell type specific biomarkers and see if them significantly highly expressed in a cluster.                 #
## Here you can manually identify the cell type of each cluster by overlap top DE of each group to cell type specific markers  #
## For example, you can do some enrichment test against the markers in CellMarker database                                     #                                   
                                                                                                                               #
## Sources:                                                                                                                    #
## CellMarker：http://biocc.hrbmu.edu.cn/CellMarker/index.jsp                                                                  #     
## PanglaoDB：https://panglaodb.se/index.html                                                                                  #
                                                                                                                               #
################################################################################################################################

# Pick up biomarker genes
select_genes <- c('LYZ','CD79A','CD8A','CD8B','GZMB','FCGR3A')
#vlnplot
p1 <- VlnPlot(scRNA, features = select_genes, pt.size=0, group.by="celltype", ncol=2)
ggsave("cell_identify/selectgenes_VlnPlot.png", p1, width=6 ,height=8)
#featureplot
p2 <- FeaturePlot(scRNA, features = select_genes, reduction = "tsne", label=T, ncol=2)
ggsave("cell_identify/selectgenes_FeaturePlot.png", p2, width=8 ,height=12)
p3=p1|p2
ggsave("cell_identify/selectgenes.png", p3, width=10 ,height=8)

################################################################################################################################
## Method 2: Using cell type specific transcriptome database and do the comparison. [Use SingleR package here]                ##
################################################################################################################################

library(SingleR)
library(celldex)

refdata <- HumanPrimaryCellAtlasData()
testdata <- GetAssayData(scRNA, slot="data")
clusters <- scRNA@meta.data$seurat_clusters
cellpred <- SingleR(test = testdata, ref = refdata, labels = refdata$label.main, 
                    method = "cluster", clusters = clusters, 
                    assay.type.test = "logcounts", assay.type.ref = "logcounts")

celltype = data.frame(ClusterID=rownames(cellpred), celltype=cellpred$labels, stringsAsFactors = F)
write.csv(celltype,"cell_identify/celltype_singleR.csv",row.names = F)
scRNA@meta.data$celltype = "NA"
for(i in 1:nrow(celltype)){
  scRNA@meta.data[which(scRNA@meta.data$seurat_clusters == celltype$ClusterID[i]),'celltype'] <- celltype$celltype[i]
}

######################################################### 
## Visulize the cell type of clusters in tSNE and UMAP ##
######################################################### 

p1 = DimPlot(scRNA, group.by="celltype", label=T, label.size=5, reduction='tsne')
p2 = DimPlot(scRNA, group.by="celltype", label=T, label.size=5, reduction='umap')
p3 = plotc <- p1+p2+ plot_layout(guides = 'collect')
ggsave("cell_identify/tSNE_celltype.pdf", p1, width=7 ,height=6)
ggsave("cell_identify/UMAP_celltype.pdf", p2, width=7 ,height=6)
ggsave("cell_identify/celltype.pdf", p3, width=10 ,height=5)
ggsave("cell_identify/celltype.png", p3, width=10 ,height=5)


