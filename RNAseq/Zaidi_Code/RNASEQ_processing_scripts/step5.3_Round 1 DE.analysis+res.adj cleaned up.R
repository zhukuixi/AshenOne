library(variancePartition)
library(tidyverse)
library(edgeR)
library(doParallel)
library(biomaRt)


#Module function for filtering low expressed genes
source("D:/JooGitRepo/RainyNight/RNAseq/Zaidi_Code/RNASEQ_processing_scripts/step4.2.1_getGeneFilteredGeneExprMatrix.R")


# Read in count matrix and covariates table
counts = read.csv("D:/JooGitRepo/RainyNight/RNAseq/Zaidi_Code/playground/983.sample.count.matrix.csv", row.names = 1)
cov.table = read.csv("D:/JooGitRepo/RainyNight/RNAseq/Zaidi_Code/playground/cov.table.ALSvsCN.983.samples.csv")

# Make sure the covariates are formatted correctly, this will be important when creating the design matrix
# factor 
cov.table$Site.Specimen.Collected = as.factor(cov.table$Site.Specimen.Collected)
cov.table$Sex = as.factor(cov.table$Sex)
cov.table$Ethnicity = as.factor(cov.table$Ethnicity)
cov.table$Subject.Group = as.factor(cov.table$Subject.Group)
cov.table$Family.History.of.ALS.FTD. = as.factor(cov.table$Family.History.of.ALS.FTD.)
cov.table$MND.with.FTD. = as.factor(cov.table$MND.with.FTD.)
cov.table$MND.with.Dementia. = as.factor(cov.table$MND.with.Dementia.)
cov.table$Site.of.Motor.Onset = as.factor(cov.table$Site.of.Motor.Onset)
cov.table$Sample.Source = as.factor(cov.table$Sample.Source)
cov.table$Reported.Genomic.Mutations..from.sites...NOT.in.any.way.associated.with.WGS.data.from.NYGC. = as.factor(cov.table$Reported.Genomic.Mutations..from.sites...NOT.in.any.way.associated.with.WGS.data.from.NYGC.)
cov.table$C9orf72.Repeat.Expansion..Data.from.CUMC. = as.factor(cov.table$C9orf72.Repeat.Expansion..Data.from.CUMC.)
cov.table$ATXN2.Repeat.Expansion..Data.from.CUMC. = as.factor(cov.table$ATXN2.Repeat.Expansion..Data.from.CUMC.)
cov.table$Cause.of.Death = as.factor(cov.table$Cause.of.Death)
cov.table$Revised.El.Escorial.Criteria = as.factor(cov.table$Revised.El.Escorial.Criteria)
cov.table$Comorbidities = as.factor(cov.table$Comorbidities)
cov.table$Platform = as.factor(cov.table$Platform)
cov.table$Expanded....30 = as.factor(cov.table$Expanded....30)
cov.table$Intermediate..30.33 = as.factor(cov.table$Intermediate..30.33)
cov.table$FlowCell.Lane = as.factor(cov.table$FlowCell.Lane)
# numeric
cov.table$Age.at.Symptom.Onset = as.numeric(cov.table$Age.at.Symptom.Onset)
cov.table$Age.at.Death = as.numeric(cov.table$Age.at.Death)
cov.table$RIN = as.numeric(cov.table$RIN)
cov.table$Disease.Duration.in.Months = as.numeric(cov.table$Disease.Duration.in.Months)
cov.table$Post.Mortem.Interval.in.Hours = as.numeric(cov.table$Post.Mortem.Interval.in.Hours)
cov.table$pct_african = as.numeric(cov.table$pct_african)
cov.table$pct_americas = as.numeric(cov.table$pct_americas)
cov.table$pct_south_asian = as.numeric(cov.table$pct_south_asian)
cov.table$pct_east_asian = as.numeric(cov.table$pct_east_asian)
cov.table$pct_european = as.numeric(cov.table$pct_european)
cov.table$C9.repeat.size = as.numeric(cov.table$C9.repeat.size)
cov.table$ATXN2.repeat.size = as.numeric(cov.table$ATXN2.repeat.size)
cov.table$Exonic.Rate = as.numeric(cov.table$Exonic.Rate)


# Remove low expressed genes
MIN_GENE_CPM=1
MIN_SAMPLE_PERCENT_WITH_MIN_GENE_CPM=0.3
filteredMatPlot = getGeneFilteredGeneExprMatrix(counts)

TRUE.GENE_EXPRESSION_DGELIST_MAT = filteredMatPlot$filteredExprMatrix
#write.table(rownames(TRUE.GENE_EXPRESSION_DGELIST_MAT),quote=FALSE,sep="\t",file=paste("../counts.ALSvsCN","CPMcut=",MIN_GENE_CPM,"Percent=",MIN_SAMPLE_PERCENT_WITH_MIN_GENE_CPM,"txt",sep="."),col.names=F,row.names=F)

#------------# TMM normalization for effective library size-----------------#
TRUE.GENE_EXPRESSION_DGELIST_MAT.NORM <-calcNormFactors(TRUE.GENE_EXPRESSION_DGELIST_MAT,method='TMM')

design <- model.matrix(~cov.table$Site.Specimen.Collected + 
                         cov.table$Sex + 
                         cov.table$Ethnicity + 
                         cov.table$Family.History.of.ALS.FTD. +
                         cov.table$Site.of.Motor.Onset + 
                         cov.table$Age.at.Death + 
                         cov.table$RIN + 
                         cov.table$Post.Mortem.Interval.in.Hours +
                         cov.table$Reported.Genomic.Mutations..from.sites...NOT.in.any.way.associated.with.WGS.data.from.NYGC. +
                         cov.table$C9orf72.Repeat.Expansion..Data.from.CUMC. + 
                         cov.table$ATXN2.Repeat.Expansion..Data.from.CUMC. +
                         cov.table$Prep + 
                         #cov.table$C9.repeat.size + 
                         cov.table$Expanded....30 +
                         #cov.table$ATXN2.repeat.size + 
                         cov.table$Intermediate..30.33 + 
                         cov.table$Exonic.Rate +
                         cov.table$FlowCell.Lane,
                       cov.table)

dim(design)
PRED.GENE_EXPRESSION_MAT<- voom(TRUE.GENE_EXPRESSION_DGELIST_MAT.NORM,
                                design=design,
                                plot=TRUE) # col numb. of sample=row# of design matrix

# Coefficients not estimable: 
#cov.table$Intermediate..30.33Yes 

# Remove non-estimable covariate - redo design
Non.est<-c('cov.table$Intermediate..30.33Yes')
Non.est.idx<-which(colnames(design)%in%Non.est)
design.new<-design[,-Non.est.idx]


PRED.GENE_EXPRESSION_MAT<- voom(TRUE.GENE_EXPRESSION_DGELIST_MAT.NORM,
                                design=design.new,
                                plot=TRUE) # col numb. of sample=row# of design matrix



#Get the numeric matrix of normalized expression values on the log2 scale
VOOM_NORMALIZED_LOG_EXPRESSION_MAT = PRED.GENE_EXPRESSION_MAT$E
#Get the numeric matrix of inverse variance weights
VOOM_WEIGHTS_MAT = PRED.GENE_EXPRESSION_MAT$weights

#Residual adjustment
fit=lmFit(VOOM_NORMALIZED_LOG_EXPRESSION_MAT, design.new, weights=VOOM_WEIGHTS_MAT)

low_expression_cutoff=paste("cutoff",paste("cpm=",MIN_GENE_CPM,sep=''),paste("sample=",MIN_SAMPLE_PERCENT_WITH_MIN_GENE_CPM,sep=''),sep='_')
#adjusted_covariates="Site.Specimen.Collected+Sex+Ethnicity+Family.History+Site.of.Motor.Onset+Age.at.Death+RIN+PMI+Reported.Genomic.Mutations+C9.Repeat.Exp+ATXN2.Repeat.Exp+Prep+C9.Expanded.30+ATXN2.Intermediate.30.33+Exonic.Rate+Batch"
residual_analysis="TargetALS.Round1"


Res.KNOWN.AllKNOWN = residuals(fit, VOOM_NORMALIZED_LOG_EXPRESSION_MAT)
write.table(Res.KNOWN.AllKNOWN,quote=FALSE,sep="\t",col.names=TRUE,row.names=TRUE,file=paste("Res.KNOWN",residual_analysis,low_expression_cutoff,"txt",sep="."))
save(Res.KNOWN.AllKNOWN,file=paste("Res.KNOWN",residual_analysis,low_expression_cutoff,"RData",sep="."))

#Res.KNOWN.AllKNOWN.scale=t(scale(t(Res.KNOWN.AllKNOWN),scale = FALSE, center = TRUE))
#save(Res.KNOWN.AllKNOWN.scale,file=paste("Res.KNOWN",residual_analysis,adjusted_covariates,dataversion,low_expression_cutoff,"RData",sep="."))
#write.table(Res.KNOWN.AllKNOWN.scale,quote=FALSE,sep="\t",col.names=TRUE,row.names=TRUE,file=paste("Res.KNOWN",residual_analysis,low_expression_cutoff,"txt",sep="."))






######## DIFFERENTIAL EXPRESSION ##########
cov.table$Subject.Group = as.factor(cov.table$Subject.Group)
cov.table$Subject.Group = relevel(cov.table$Subject.Group, ref = "Non-Neurological Control")

design.DE <- model.matrix(~cov.table$Subject.Group + 
                            cov.table$Site.Specimen.Collected + 
                            cov.table$Sex + 
                            cov.table$Ethnicity + 
                            cov.table$Family.History.of.ALS.FTD. +
                            cov.table$Site.of.Motor.Onset + 
                            cov.table$Age.at.Death + 
                            cov.table$RIN + 
                            cov.table$Post.Mortem.Interval.in.Hours +
                            cov.table$Reported.Genomic.Mutations..from.sites...NOT.in.any.way.associated.with.WGS.data.from.NYGC. +
                            cov.table$C9orf72.Repeat.Expansion..Data.from.CUMC. + 
                            cov.table$ATXN2.Repeat.Expansion..Data.from.CUMC. +
                            cov.table$Prep + 
                            #cov.table$C9.repeat.size + 
                            cov.table$Expanded....30 +
                            #cov.table$ATXN2.repeat.size + 
                            cov.table$Intermediate..30.33 + 
                            cov.table$Exonic.Rate +
                            cov.table$FlowCell.Lane,
                          cov.table)

ANALY.GENE_EXPRESSION_MAT<- voom(TRUE.GENE_EXPRESSION_DGELIST_MAT.NORM,design=design.DE,plot=TRUE)

# Coefficients not estimable: 
# cov.table$Site.of.Motor.OnsetNot Applicable 
# cov.table$Intermediate..30.33Yes 

# Remove non-estimable covariate - redo design
Non.est<-c('cov.table$Intermediate..30.33Yes','cov.table$Site.of.Motor.OnsetNot Applicable')
Non.est.idx<-which(colnames(design.DE)%in%Non.est)
design.DE.new<-design.DE[,-Non.est.idx]

# Use voom function to fit data for linear modeling
ANALY.GENE_EXPRESSION_MAT<- voom(TRUE.GENE_EXPRESSION_DGELIST_MAT.NORM,design=design.DE.new,plot=TRUE)

fit=lmFit(ANALY.GENE_EXPRESSION_MAT, design.DE.new) 
#fit2 <- eBayes(fit, trend=TRUE)
fit2 <- eBayes(fit)

#summary(decideTests(fit2))
#summary(decideTests(fit2, `adjust.method` = "none", p.value = 0.05))

ALS.deg = topTable(fit2, 
                   coef = "cov.table$Subject.GroupALS Spectrum MND", 
                   number = Inf, 
                   adjust.method = "BH")

ALS.plus.deg = topTable(fit2, 
                        coef = "cov.table$Subject.GroupALS Spectrum MND, Other Neurological Disorders", 
                        number = Inf, 
                        adjust.method = "BH")

ALS.deg = ALS.deg %>% arrange(ALS.deg, ALS.deg$genes)
ALS.plus.deg = ALS.plus.deg %>% arrange(ALS.plus.deg, ALS.deg$genes)

# Annotate Ensembl gene IDs using biomaRt package
geneset<-rownames(ALS.deg)
genename<-unlist(lapply(geneset,function (x) {unlist(strsplit(x,"[.]"))[1]}))
ensembl <- useMart(host='www.ensembl.org', biomart='ENSEMBL_MART_ENSEMBL', dataset = "hsapiens_gene_ensembl")
bm <- getBM(attributes=c("ensembl_gene_id", "external_gene_name", "description","gene_biotype"), 
            filter="ensembl_gene_id", values= genename, mart=ensembl)

ALS.deg = cbind(genename, ALS.deg)
colnames(ALS.deg)[1] <- "ensembl_gene_id"
colnames(ALS.deg)[2] <- "ensembl_gene_id_version"
ALS.deg <- merge(bm, ALS.deg, by ="ensembl_gene_id", all.y = TRUE)
write.csv(ALS.deg, "ALS.vs.CN.Round1.DE.csv", row.names = F)

ALS.plus.deg = cbind(genename, ALS.plus.deg)
colnames(ALS.plus.deg)[1] <- "ensembl_gene_id"
colnames(ALS.plus.deg)[2] <- "ensembl_gene_id_version"
ALS.plus.deg <- merge(bm, ALS.plus.deg, by ="ensembl_gene_id", all.y = TRUE)
write.csv(ALS.plus.deg, "ALS.plus.vs.CN.Round1.DE.csv", row.names = F)


