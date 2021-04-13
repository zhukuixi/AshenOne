library(variancePartition)
library(edgeR)
library(doParallel)
library(dplyr)



#Module function for filtering low expressed genes
source("~/Desktop/Organized_data/Target_ALS/temp_htseq_filesNscripts/getGeneFilteredGeneExprMatrix.R")

##################################
##################################
#Combining individual expression files into one matrix
##################################
##################################

setwd("~/Desktop/Organized_data/Target_ALS/temp_htseq_filesNscripts/")

cov.table = read.csv("~/Desktop/Organized_data/Target_ALS/covariates.ALSvsCN.QC_BL_colsEdited.csv")
#cov.table = cov.table[1:43]
#cov.table = cov.table[1:300,]

cov.table.ALSvCN = subset(cov.table, (cov.table$Subject.Group == "ALS Spectrum MND" | cov.table$Subject.Group == "Non-Neurological Control"))
#cov.table.ALSvCN = read.csv("../covariates.ADvsCN.csv")

files = cov.table.ALSvCN$fileName

#files = subset(files, (files %in% cov.table.ALSvCN$fileName))

file1 = read.delim(files[1], row.names = 1, header = F)
file2 = read.delim(files[2], row.names = 1, header = F)

counts = cbind(file1,file2)

for (i in 3:length(files)) {
  file = read.delim(files[i], header = F, row.names = 1)
  counts = cbind(counts, file)
}

colnames(counts) = cov.table.ALSvCN$ExternalSampleId
#write.csv(cov.table.ALSvCN, "../covariates.ADvsCN.csv", row.names = F)

#counts$sums = rowSums(counts)
#counts = counts[,c(830,1:829)]
#counts.edit = subset(counts, (counts$sums > 0))
counts.edit = counts[1:(nrow(counts)-5),] #Removes QC rows at the end of htseq files

# Remove low expressed genes (CPM 0.3 shows that it must appear atleast once/million in 30% samples)
MIN_GENE_CPM=1
MIN_SAMPLE_PERCENT_WITH_MIN_GENE_CPM=0.3
filteredMatPlot = getGeneFilteredGeneExprMatrix(counts.edit)

TRUE.GENE_EXPRESSION_DGELIST_MAT = filteredMatPlot$filteredExprMatrix
#write.table(rownames(TRUE.GENE_EXPRESSION_DGELIST_MAT),quote=FALSE,sep="\t",file=paste("../counts.ALSvsCN","CPMcut=",MIN_GENE_CPM,"Percent=",MIN_SAMPLE_PERCENT_WITH_MIN_GENE_CPM,"txt",sep="."),col.names=F,row.names=F)

TRUE.GENE_EXPRESSION_MAT = TRUE.GENE_EXPRESSION_DGELIST_MAT$counts


##################################
##################################
# Add output files from RNASeqC to covariate files
##################################
##################################

setwd("~/Desktop/Organized_data/Target_ALS/RNASEQc/")

files = cov.table.ALSvCN$rnaseqcFile

#files = subset(files, (files %in% cov.table.ALSvCN$fileName))

file1 = read.delim(files[1], row.names = 1, header = F)
file2 = read.delim(files[2], row.names = 1, header = F)

QC = cbind(file1,file2)

for (i in 3:length(files)) {
  file = read.delim(files[i], header = F, row.names = 1)
  QC = cbind(QC, file)
}

colnames(QC) = cov.table.ALSvCN$ExternalSampleId
QC = t(QC)
QC = as.data.frame(QC)
colnames(QC)[13] = "Exonic.Rate"

cov.table.ALSvCN.QC = cbind(cov.table.ALSvCN, QC)

##################################
##################################
# Variance Partition Plot
##################################
##################################

setwd("~/Desktop/Organized_data/Target_ALS/temp_htseq_filesNscripts/")

# categorical
cov.table.ALSvCN.QC$Site.Specimen.Collected = as.factor(cov.table.ALSvCN.QC$Site.Specimen.Collected)
cov.table.ALSvCN.QC$Sex = as.factor(cov.table.ALSvCN.QC$Sex)
cov.table.ALSvCN.QC$Ethnicity = as.factor(cov.table.ALSvCN.QC$Ethnicity)
cov.table.ALSvCN.QC$Subject.Group = as.factor(cov.table.ALSvCN.QC$Subject.Group)
cov.table.ALSvCN.QC$Family.History.of.ALS.FTD. = as.factor(cov.table.ALSvCN.QC$Family.History.of.ALS.FTD.)
cov.table.ALSvCN.QC$MND.with.FTD. = as.factor(cov.table.ALSvCN.QC$MND.with.FTD.)
cov.table.ALSvCN.QC$MND.with.Dementia. = as.factor(cov.table.ALSvCN.QC$MND.with.Dementia.)
cov.table.ALSvCN.QC$Site.of.Motor.Onset = as.factor(cov.table.ALSvCN.QC$Site.of.Motor.Onset)
cov.table.ALSvCN.QC$Sample.Source = as.factor(cov.table.ALSvCN.QC$Sample.Source)
cov.table.ALSvCN.QC$Reported.Genomic.Mutations..from.sites...NOT.in.any.way.associated.with.WGS.data.from.NYGC. = as.factor(cov.table.ALSvCN.QC$Reported.Genomic.Mutations..from.sites...NOT.in.any.way.associated.with.WGS.data.from.NYGC.)
cov.table.ALSvCN.QC$C9orf72.Repeat.Expansion..Data.from.CUMC. = as.factor(cov.table.ALSvCN.QC$C9orf72.Repeat.Expansion..Data.from.CUMC.)
cov.table.ALSvCN.QC$ATXN2.Repeat.Expansion..Data.from.CUMC. = as.factor(cov.table.ALSvCN.QC$ATXN2.Repeat.Expansion..Data.from.CUMC.)
cov.table.ALSvCN.QC$Cause.of.Death = as.factor(cov.table.ALSvCN.QC$Cause.of.Death)
cov.table.ALSvCN.QC$Revised.El.Escorial.Criteria = as.factor(cov.table.ALSvCN.QC$Revised.El.Escorial.Criteria)
cov.table.ALSvCN.QC$Comorbidities = as.factor(cov.table.ALSvCN.QC$Comorbidities)
cov.table.ALSvCN.QC$Platform = as.factor(cov.table.ALSvCN.QC$Platform)
cov.table.ALSvCN.QC$Expanded....30 = as.factor(cov.table.ALSvCN.QC$Expanded....30)
cov.table.ALSvCN.QC$Intermediate..30.33 = as.factor(cov.table.ALSvCN.QC$Intermediate..30.33)

# numeric
cov.table.ALSvCN.QC$Age.at.Symptom.Onset = as.numeric(cov.table.ALSvCN.QC$Age.at.Symptom.Onset)
cov.table.ALSvCN.QC$Age.at.Death = as.numeric(cov.table.ALSvCN.QC$Age.at.Death)
cov.table.ALSvCN.QC$RIN = as.numeric(cov.table.ALSvCN.QC$RIN)
cov.table.ALSvCN.QC$Disease.Duration.in.Months = as.numeric(cov.table.ALSvCN.QC$Disease.Duration.in.Months)
cov.table.ALSvCN.QC$Post.Mortem.Interval.in.Hours = as.numeric(cov.table.ALSvCN.QC$Post.Mortem.Interval.in.Hours)
cov.table.ALSvCN.QC$pct_african = as.numeric(cov.table.ALSvCN.QC$pct_african)
cov.table.ALSvCN.QC$pct_americas = as.numeric(cov.table.ALSvCN.QC$pct_americas)
cov.table.ALSvCN.QC$pct_south_asian = as.numeric(cov.table.ALSvCN.QC$pct_south_asian)
cov.table.ALSvCN.QC$pct_east_asian = as.numeric(cov.table.ALSvCN.QC$pct_east_asian)
cov.table.ALSvCN.QC$pct_european = as.numeric(cov.table.ALSvCN.QC$pct_european)
cov.table.ALSvCN.QC$C9.repeat.size = as.numeric(cov.table.ALSvCN.QC$C9.repeat.size)
cov.table.ALSvCN.QC$ATXN2.repeat.size = as.numeric(cov.table.ALSvCN.QC$ATXN2.repeat.size)
cov.table.ALSvCN.QC$Exonic.Rate = as.numeric(cov.table.ALSvCN.QC$Exonic.Rate)
        

# form <- ~ (1|Site.Specimen.Collected) + (1|Sex) + (1|Ethnicity) + (1|Subject.Group) + (1|Family.History.of.ALS.FTD.) +
#   (1|MND.with.FTD.) + (1|MND.with.Dementia.) + (1|Site.of.Motor.Onset) + (1|Sample.Source) + (1|Reported.Genomic.Mutations..from.sites...NOT.in.any.way.associated.with.WGS.data.from.NYGC.) + 
#   (1|C9orf72.Repeat.Expansion..Data.from.CUMC.) + (1|ATXN2.Repeat.Expansion..Data.from.CUMC.) + (1|Cause.of.Death) + (1|Revised.El.Escorial.Criteria) + 
#   (1|Comorbidities) + (1|Platform) + (1|Expanded....30) + (1|Intermediate..30.33) + 
#   Age.at.Symptom.Onset + Age.at.Death + RIN + Disease.Duration.in.Months + Post.Mortem.Interval.in.Hours + pct_african + pct_americas +
#   pct_south_asian + pct_east_asian + pct_european + C9.repeat.size + ATXN2.repeat.size + Exonic.Rate


# form <- ~ (1|Site.Specimen.Collected) + (1|Sex) + (1|Ethnicity) + (1|Subject.Group) + (1|Family.History.of.ALS.FTD.) +
#   (1|MND.with.FTD.) + (1|MND.with.Dementia.) + (1|Site.of.Motor.Onset) + (1|Sample.Source) + (1|Reported.Genomic.Mutations..from.sites...NOT.in.any.way.associated.with.WGS.data.from.NYGC.) + 
#   (1|C9orf72.Repeat.Expansion..Data.from.CUMC.) + (1|ATXN2.Repeat.Expansion..Data.from.CUMC.) + (1|Cause.of.Death) + (1|Revised.El.Escorial.Criteria) + 
#   (1|Comorbidities) + (1|Platform) + (1|Expanded....30) + (1|Intermediate..30.33) + Age.at.Death +
#    RIN + Exonic.Rate 

# Create formula for model that'll go into the VP analysis, constructed using covariate variables:
# For categorical variables, write it as (1| *Variable*) 
# For numerical variables, just write the name of the Variable as is
form <- ~ (1|Site.Specimen.Collected) + (1|Sex) + (1|Ethnicity) +
  (1|Subject.Group) + (1|Family.History.of.ALS.FTD.) +
  (1|MND.with.FTD.) + (1|MND.with.Dementia.) + (1|Site.of.Motor.Onset) +
  (1|Sample.Source) + (1|Reported.Genomic.Mutations..from.sites...NOT.in.any.way.associated.with.WGS.data.from.NYGC.) +
  (1|C9orf72.Repeat.Expansion..Data.from.CUMC.) + (1|ATXN2.Repeat.Expansion..Data.from.CUMC.) +
  (1|Cause.of.Death) + (1|Revised.El.Escorial.Criteria) +
  (1|Comorbidities) + (1|Platform) + (1|Expanded....30) +
  (1|Intermediate..30.33) +
  Exonic.Rate + Age.at.Death + RIN +
  Post.Mortem.Interval.in.Hours +
  C9.repeat.size + ATXN2.repeat.size
#  pct_african + pct_americas +
#  pct_south_asian + pct_east_asian + pct_european

# form <- ~ (1|Site.Specimen.Collected) + (1|Sex) + (1|Ethnicity) + 
#   (1|Subject.Group) + (1|Family.History.of.ALS.FTD.) +
#   (1|MND.with.FTD.) + (1|MND.with.Dementia.) + (1|Site.of.Motor.Onset) + 
#   (1|Sample.Source) + (1|Reported.Genomic.Mutations..from.sites...NOT.in.any.way.associated.with.WGS.data.from.NYGC.) +
#   (1|C9orf72.Repeat.Expansion..Data.from.CUMC.) + (1|ATXN2.Repeat.Expansion..Data.from.CUMC.) + 
#   (1|Cause.of.Death) + (1|Revised.El.Escorial.Criteria) +
#   (1|Comorbidities) + (1|Expanded....30) + 
#   (1|Intermediate..30.33) +
#   Exonic.Rate + Age.at.Death + RIN + 
#   Post.Mortem.Interval.in.Hours + 
#   C9.repeat.size + ATXN2.repeat.size 


# Rank deficient
#Age.at.Symptom.Onset
#Disease.Duration.in.Months

## Resource management to do the VPA across multiple cores on the computer
##cl <- makeCluster(4)
cl <- parallel::makeCluster(20, setup_timeout = 0.5)
registerDoParallel(cl)


varPart <- fitExtractVarPartModel(TRUE.GENE_EXPRESSION_MAT, form, cov.table.ALSvCN.QC) #This step took about 6 hrs to process
vp <- sortCols(varPart)

# violin plot of contribution of each variable to total variance
date="09232020"
pdf(paste("TargetALS.ALSvsCN.VPA-BL-Edited_CvT",date,"pdf",sep="."))
plotVarPart(vp,label.angle = 30 )
dev.off()
