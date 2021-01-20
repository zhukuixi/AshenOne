# [MAFtools (a R package)](https://www.bioconductor.org/packages/devel/bioc/vignettes/maftools/inst/doc/maftools.html)

### 1.MAF field requirements  
MAF files contain many fields ranging from chromosome names to cosmic annotations. However most of the analysis in maftools uses following fields.

**Mandatory fields**: Hugo_Symbol, Chromosome, Start_Position, End_Position, Reference_Allele, Tumor_Seq_Allele2, Variant_Classification, Variant_Type and Tumor_Sample_Barcode.

**Recommended optional fields**: non MAF specific fields containing VAF (Variant Allele Frequecy) and amino acid change information.

### 2.Overview of the package
maftools functions can be categorized into mainly Visualization and Analysis modules. Each of these functions and a short description is summarized as shown below. Usage is simple, just read your MAF file with read.maf (along with copy-number data if available) and pass the resulting MAF object to the desired function for plotting or analysis.  

![](https://github.com/zhukuixi/RainyNight/blob/master/Bioinformatics/image/maf1.png)  

