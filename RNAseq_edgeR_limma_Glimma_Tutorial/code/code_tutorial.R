library(limma)
library(Glimma)
library(edgeR)
library(Mus.musculus)

## source:https://bioconductor.org/packages/release/workflows/vignettes/RNAseq123/inst/doc/limmaWorkflow_CHN.html#%E6%95%B0%E6%8D%AE%E9%A2%84%E5%A4%84%E7%90%86
####################################################
#                     1.数据整合                       #
#                                                    #
#1.1读入计数数据                                      #   
#1.2组织样品信息                                      #
#1.3 组织基因注释                                     #

#                     2.数据预处理                     #
#                                                    #
#2.1原始数据尺度转换  (cpm,lcpm)                    #   
#2.2删除低表达基因    (filterByExpr)                 #
#2.3归一化基因表达分布 (TMM)                        #
#2.4对样本的无监督聚类 (MDS,可以探求将那些covariate加入线性模型) #

#                     3.差异表达分析                   
#3.1创建设计矩阵和对比 model.matrix(), makeContrasts()     
#3.2从表达计数数据中删除异方差+拟合线性模型以进行比较 voom->lmfit->contrasts.fit->eBayes() | treat()
#3.3检查DE基因数量  summary(decideTests())          
#3.4从头到尾检查单个DE基因  topTreat(),topTable()   
#3.5实用的差异表达结果可视化                     
#3.6使用camera的基因集检验
######################################################



####################################################
#                     数据整合                       #
#                                                    #
#1.1读入计数数据                                      #   
#1.2组织样品信息                                      #
#1.3 组织基因注释                                     #
######################################################

##################
## 1.1读入计数数据 ##
##################

setwd("D:/JooGitRepo/RainyNight/RNAseq_edgeR_limma_Glimma_Tutorial/")
url <- "https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE63310&format=file"
utils::download.file(url, destfile="GSE63310_RAW.tar", mode="wb") 
utils::untar("GSE63310_RAW.tar", exdir = ".")
files <- c("GSM1545535_10_6_5_11.txt", "GSM1545536_9_6_5_11.txt", "GSM1545538_purep53.txt",
           "GSM1545539_JMS8-2.txt", "GSM1545540_JMS8-3.txt", "GSM1545541_JMS8-4.txt",
           "GSM1545542_JMS8-5.txt", "GSM1545544_JMS9-P7c.txt", "GSM1545545_JMS9-P8c.txt")
for(i in paste(files, ".gz", sep=""))
  R.utils::gunzip(i, overwrite=TRUE)

files <- c("GSM1545535_10_6_5_11.txt", "GSM1545536_9_6_5_11.txt", 
           "GSM1545538_purep53.txt", "GSM1545539_JMS8-2.txt", 
           "GSM1545540_JMS8-3.txt", "GSM1545541_JMS8-4.txt", 
           "GSM1545542_JMS8-5.txt", "GSM1545544_JMS9-P7c.txt", 
           "GSM1545545_JMS9-P8c.txt")

#read.delim(files[1], nrow=5)

##    EntrezID GeneLength Count
## 1    497097       3634     1
## 2 100503874       3259     0
## 3 100038431       1634     0
## 4     19888       9747     0
## 5     20671       3130     1

# use readDGE() function from edgeR to combine samples and convert to DEGList object
# 如果数据不是每个样品一个文件的形式，而是一个包含所有样品的计数的文件，
# 则可以先将文件读入R，再使用DGEList()函数转换为一个DGEList对象。
# Example: x = DGEList(counts=input_matrix, genes=rownames(input_matrix))
x <- readDGE(files, columns=c(1,3))
class(x)


##################
## 1.2组织样品信息 ##
##################

samplenames <- substring(colnames(x), 12, nchar(colnames(x)))
samplenames

## group:cell type
## lane:batch
colnames(x) <- samplenames
group <- as.factor(c("LP", "ML", "Basal", "Basal", "ML", "LP", 
                     "Basal", "ML", "LP"))
x$samples$group <- group
lane <- as.factor(rep(c("L004","L006","L008"), c(3,4,2)))
x$samples$lane <- lane
x$samples


##################
## 1.3组织基因注释 ##
##################
geneid <- rownames(x)
genes <- select(Mus.musculus, keys=geneid, columns=c("SYMBOL", "TXCHROM"), 
                keytype="ENTREZID")
head(genes)

##为了简单起见，我们保留每个基因ID第一次出现的信息。(一些EntrezID能映射到多个symbol,chrome)
genes <- genes[!duplicated(genes$ENTREZID),]
## 在此例子中，注释与数据对象中的基因顺序是相同的。
## 如果由于缺失和／或重新排列基因ID导致其顺序不一致，我们可以用match函数来正确排序基因。
x$genes <- genes ##注释成功！


######################################################
#                     数据预处理                     #
#                                                    #
#2.1原始数据尺度转换  (cpm,lcpm)                    #   
#2.2删除低表达基因    (filterByExpr)                 #
#2.3归一化基因表达分布 (TMM)                        #
#2.4对样本的无监督聚类 (MDS,可以探求将那些covariate加入线性模型) #
######################################################

#######################
## 2.1原始数据尺度转换  ##
#######################
cpm <- cpm(x)

# log-CPM值将被用于探索性图表中.当设置log=TRUE时，cpm函数会给CPM值加上一个弥补值并进行log2转换。
# 默认的弥补值是2/L，其中2是“预先计数”，而L是样本文库大小（以百万计）的平均值，
# 所以log-CPM值是根据CPM值通过log2(CPM + 2/L)计算得到的。
# 在接下来的线性模型分析中，使用limma的voom函数时也会用到log-CPM值，
#  但voom会默认使用更小的预先计数重新计算自己的log-CPM值。
lcpm <- cpm(x, log=TRUE, prior.count=2)
L <- mean(x$samples$lib.size) * 1e-6
M <- median(x$samples$lib.size) * 1e-6

#######################
## 2.2 删除低表达基因    ##
#######################

# 在任何样本中都没有足够多的序列片段的基因应该从下游分析中过滤掉。这样做的原因有好几个。
# 从生物学的角度来看，在任何条件下的表达水平都不具有生物学意义的基因都不值得关注，因此最好忽略。 
# 从统计学的角度来看，去除低表达计数基因使数据中的均值 - 方差关系可以得到更精确的估计，
# 并且还减少了下游的差异表达分析中需要进行的统计检验的数量。
table(rowSums(x$counts==0)==9)

# 此函数默认选取最小的组内的样本数量为最小样本数，保留至少在这个数量的样本中有10个或更多计数的基因。
# 实际进行过滤时，使用的是CPM值而不是表达计数，以避免对总序列数大的样本的偏向性。
keep.exprs <- filterByExpr(x, group=group)
x <- x[keep.exprs,, keep.lib.sizes=FALSE]

## 作图比较过滤前后基因CPM分布
lcpm.cutoff <- log2(10/M + 2/L)
library(RColorBrewer)
nsamples <- ncol(x)
col <- brewer.pal(nsamples, "Paired")
par(mfrow=c(1,2))
plot(density(lcpm[,1]), col=col[1], lwd=2, ylim=c(0,0.26), las=2, main="", xlab="")
title(main="A. Raw data", xlab="Log-cpm")
abline(v=lcpm.cutoff, lty=3)
for (i in 2:nsamples){
  den <- density(lcpm[,i])
  lines(den$x, den$y, col=col[i], lwd=2)
}
legend("topright", samplenames, text.col=col, bty="n")
lcpm <- cpm(x, log=TRUE)
plot(density(lcpm[,1]), col=col[1], lwd=2, ylim=c(0,0.26), las=2, main="", xlab="")
title(main="B. Filtered data", xlab="Log-cpm")
abline(v=lcpm.cutoff, lty=3)
for (i in 2:nsamples){
  den <- density(lcpm[,i])
  lines(den$x, den$y, col=col[i], lwd=2)
}
legend("topright", samplenames, text.col=col, bty="n")

#############################
## 2.3 归一化基因表达分布     ##
#############################

x <- calcNormFactors(x, method = "TMM")

## 为了更好地展示出归一化的效果，我们复制了数据并进行了人工调整，
## 使得第一个样品的计数减少到了其原始值的5%，而第二个样品增大到了5倍。
## 要注意在实际的数据分析流程中，不应当进行这样的操作
x2 <- x
x2$samples$norm.factors <- 1
x2$counts[,1] <- ceiling(x2$counts[,1]*0.05)
x2$counts[,2] <- x2$counts[,2]*5

par(mfrow=c(1,2))
lcpm <- cpm(x2, log=TRUE)
boxplot(lcpm, las=2, col=col, main="")
title(main="A. Example: Unnormalised data",ylab="Log-cpm")
x2 <- calcNormFactors(x2)  
x2$samples$norm.factors

lcpm <- cpm(x2, log=TRUE)
boxplot(lcpm, las=2, col=col, main="")
title(main="B. Example: Normalised data",ylab="Log-cpm")



#############################
## 2.4 对样本的无监督聚类  ##
#############################

# 在我们看来，用于检查基因表达分析的最重要的探索性图表之一便是MDS图，或类似的图
# 这样的图可以用limma中的plotMDS函数绘制。第一个维度表示能够最好地分离样品且解释最大比例的方差的领先倍数变化（leading-fold-change），
# 而后续的维度的影响更小，并与之前的维度正交。

##[重要]## 当实验设计涉及到多个因子时，建议在多个维度上检查每个因子。如果在其中一些维度上样本可按照某因子聚类，####
##[重要]## 这说明该因子对于表达差异有影响，在线性模型中应当将其包括进去。反之，没有或者仅有微小影响的因子在下游分析时应当被剔除。####

# PCA构建二维坐标图的方法基础是不同样本之间的相关性，而MDS和PCoA构建二维坐标图的方法基础则是基于不同样本之间的距离.

#为绘制MDS图，我们为不同的因子设立不同的配色。维度1和2以细胞类型上色，而维度3和4以测序泳道（批次）上色。
lcpm <- cpm(x, log=TRUE)
par(mfrow=c(1,2))
col.group <- group
levels(col.group) <-  brewer.pal(nlevels(col.group), "Set1")
col.group <- as.character(col.group)
col.lane <- lane
levels(col.lane) <-  brewer.pal(nlevels(col.lane), "Set2")
col.lane <- as.character(col.lane)
plotMDS(lcpm, labels=group, col=col.group)
title(main="A. Sample groups")
plotMDS(lcpm, labels=lane, col=col.lane, dim=c(3,4))
title(main="B. Sequencing lanes")

## Glimma包的函数，生成交互式mds图存于html文件
glMDSPlot(lcpm, labels=paste(group, lane, sep="_"), 
          groups=x$samples[,c(2,5)], launch=FALSE)


######################################################
#                     差异表达分析                   
#3.1创建设计矩阵和对比 model.matrix(), makeContrasts()     
#3.2从表达计数数据中删除异方差+拟合线性模型以进行比较 voom->lmfit->contrasts.fit->eBayes() | treat()
#3.3检查DE基因数量  summary(decideTests())          
#3.4从头到尾检查单个DE基因  topTreat(),topTable()   
#3.5实用的差异表达结果可视化                     
#3.6使用camera的基因集检验
######################################################


#############################
## 3.1 创建设计矩阵和对比  ##
#############################


#在此研究中，我们想知道哪些基因在我们研究的三组细胞之间以不同水平表达。我们的分析中所用到的线性模型假设数据是正态分布的。
#首先，我们要创建一个包含细胞类型以及测序泳道（批次）信息的设计矩阵。

# 对于一个给定的实验，通常有多种等价的方法都能用来创建合适的设计矩阵。 比如说，~0+group+lane去除了第一个因子group的截距,
# 但第二个因子lane的截距被保留。 此外也可以使用~group+lane，来自group和lane的截距均被保留。 理解如何解释模型中估计的系数是创建合适的设计矩阵的关键。
# 我们在此分析中选取第一种模型，因为在没有group的截距的情况下能更直截了当地设定模型中的对比。

#设计矩阵
design <- model.matrix(~0+group+lane)
colnames(design) <- gsub("group", "", colnames(design))
design

#对比
contr.matrix <- makeContrasts(
  BasalvsLP = Basal-LP, 
  BasalvsML = Basal - ML, 
  LPvsML = LP - ML, 
  levels = colnames(design))
contr.matrix


########################################################
## 3.2从表达计数数据中删除异方差+拟合线性模型以进行比较#
########################################################



par(mfrow=c(1,2))
v <- voom(x, design, plot=TRUE)
#线性模型拟合
vfit <- lmFit(v, design)
#根据对比模型进行系数差值计算,不改变拟合本身
vfit <- contrasts.fit(vfit, contrasts=contr.matrix)
#贝叶斯检验
efit <- eBayes(vfit)
plotSA(efit, main="Final model: Mean-variance trend")


###############################
## 3.3 检查DE基因数量        ##
###############################

# 默认p.adjust<0.05
summary(decideTests(efit))

# 不但卡p.adjust，还卡logFC:
# 在某些时候，不仅仅需要用到校正p值阈值，还需要差异倍数的对数（log-FCs）
# 也高于某个最小值来更为严格地定义显著性。treat方法可以按照对最小log-FC值的要求，
# 使用经过经验贝叶斯调整的t统计值计算p值。
tfit <- treat(vfit, lfc=1)
dt <- decideTests(tfit)
summary(dt)

# 在多个对比中皆差异表达的基因可以从decideTests的结果中提取，
# 其中的0代表不差异表达的基因，1代表上调的基因，-1代表下调的基因。
de.common <- which(dt[,1]!=0 & dt[,2]!=0)
head(tfit$genes$SYMBOL[de.common], n=20)
vennDiagram(dt[,1:2], circle.col=c("turquoise", "salmon"))


###############################
# 3.4 从头到尾检查单个DE基因  #
###############################

# 使用topTreat函数可以列举出使用treat得到的结果中靠前的DE基因（对于eBayes的结果则应使用topTable函数）
basal.vs.lp <- topTreat(tfit, coef=1, n=Inf)
basal.vs.ml <- topTreat(tfit, coef=2, n=Inf)
head(basal.vs.lp)

###############################
# 3.5 实用的差异表达结果可视化#
###############################

# 绘制每个基因log-FC与log-CPM平均值间的关系
plotMD(tfit, column=1, status=dt[,1], main=colnames(tfit)[1], 
       xlim=c(-8,13))

# Glimma包的交互式图
glMDPlot(tfit, coef=1, status=dt, main=colnames(tfit)[1],
         side.main="ENTREZID", counts=lcpm, groups=group, launch=TRUE)
# heatmap
library(gplots)
basal.vs.lp.topgenes <- basal.vs.lp$ENTREZID[1:100]
i <- which(v$genes$ENTREZID %in% basal.vs.lp.topgenes)
mycol <- colorpanel(1000,"blue","white","red")
heatmap.2(lcpm[i,], scale="row",
          labRow=v$genes$SYMBOL[i], labCol=group, 
          col=mycol, trace="none", density.info="none", 
          margin=c(8,6), lhei=c(2,10), dendrogram="column")


#################################
## 3.6 使用camera的基因集检验  ##
#################################
# camera函数通过比较假设检验来评估一个给定基因集中的基因是否相对于不在集内的基因
# 而言在差异表达基因的排序中更靠前
load(system.file("extdata", "mouse_c2_v5p1.rda", package = "RNAseq123"))
idx <- ids2indices(Mm.c2,id=rownames(v))
cam.BasalvsLP <- camera(v,idx,design,contrast=contr.matrix[,1])
head(cam.BasalvsLP,5)
cam.BasalvsML <- camera(v,idx,design,contrast=contr.matrix[,2])
head(cam.BasalvsML,5)
cam.LPvsML <- camera(v,idx,design,contrast=contr.matrix[,3])
head(cam.LPvsML,5)

barcodeplot(efit$t[,3], index=idx$LIM_MAMMARY_LUMINAL_MATURE_UP, 
            index2=idx$LIM_MAMMARY_LUMINAL_MATURE_DN, main="LPvsML")