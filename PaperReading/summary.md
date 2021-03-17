## Viper
a tool for scRNAseq imputation based on regression.

Since cell_i,gene_j's value is dropout. We do the regression on other genes of cell_i, where the predictors are the gene values from other cells. The beta value is fixed which stands for the predictive a cell is for cell_i.

![](https://github.com/zhukuixi/RainyNight/blob/master/PaperReading/singleCell/image//viper.png)