# Doing Meta-Analysis in R
[Tutorial](https://bookdown.org/MathiasHarrer/Doing_Meta_Analysis_in_R/detecting-outliers-influential-cases.html)

## Data Input
* It needs the following information for case and control group.  

**Type 1**:Standard effect size data (Mean,Standard deviation, SampleCount).   
**Type 2**:Event rate data (EventCount,SampleCount)  
**Type 3**:Incidence rate data (EventCount,TimePeriod)


## Pooling Effect Sizes
* Fixed-Effects-Model  
	- The fixed-effects-model assumes that all studies along with their effect sizes stem from a single homogeneous population. So there is a fixed-true effect, all the effects from different study is just a different deviation(due to sampling error) from it.  
	![4.1](https://github.com/zhukuixi/AshenOne/blob/master/MetaAnalysisInR/img/4.1.png)  
    ![4.2](https://github.com/zhukuixi/AshenOne/blob/master/MetaAnalysisInR/img/4.2.png)

* Random-Effects-Model
	- There is no fixed true effect. True effect itself got a distribution. This extra
	- This extra source of variance introduced by the fact that the studies do not stem from one single population,     but are drawn from a “universe” of populations.
	- It can estimate the variance of the distribution of true effect sizes ( Between-study Heterogeneity).  
	![4.3](https://github.com/zhukuixi/AshenOne/blob/master/MetaAnalysisInR/img/4.3.png)    
	![4.4](https://github.com/zhukuixi/AshenOne/blob/master/MetaAnalysisInR/img/4.4.png)  
# 
	meta::metacont() # Raw effect size data
	meta::metagen()  # Pre-calculated effect size data

* Effect size  
	- For continuous data, it is mean difference and correlation.
	- For binary data, it could be odds ratio, relative risk.

## Forest Plot 
* The visualization of "Pooling Effect Sizes".

![5.1](https://github.com/zhukuixi/AshenOne/blob/master/MetaAnalysisInR/img/5.1.png)  


## Between-study Heterogeneity
 -  Pooling is only meaningful when we pooled from a bunch of Apple but not from a bunch of Apple and Orange!
 -  The source of heterogenity:
	 -  1.Data Collection
	 -  2.Other sources of heterogeneity, such as design-related heterogeneity.
	 -  3.Statistical heterogenity  
	For 1 and 2, we need to change our data scope.
	For 3, we handle it in this section.
 - Three heteogeneity metrics:
	- Cochran’s Q
	- Higgin’s & Thompson’s I2
	- Tau-squared

### Assessing the heterogeneity of your pooled effect size
	print(m.hksj)  ## Just print the object and you can see all 3 heterogeneity metrics. Also pay attention to the prediction interval.


### Detecting outliers & influential cases
	find.outliers(m.hksj) ## It mainly compare the 95%CI of pooling effect size with the 95%CI of effect size of each study. 