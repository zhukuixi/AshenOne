# Doing Meta-Analysis in R
[Tutorial](https://bookdown.org/MathiasHarrer/Doing_Meta_Analysis_in_R/detecting-outliers-influential-cases.html)

## Data Input
* It needs the following information for case and control group.  

**Type 1**:Standard effect size data (Mean,Standard deviation, SampleCount).   
**Type 2**:Event rate data (EventCount,SampleCount)  
**Type 3**:Incidence rate data (EventCount,TimePeriod)


## Pooling Effect Sizes
* Fixed-Effects-Model  
	- The fixed-effects-model assumes that all studies along with their effect sizes stem from a single homogeneous population. So there is a fixed-true effect, all the effects from different study is just a different deviation from it.  
	![4.1](https://github.com/zhukuixi/AshenOne/blob/master/MetaAnalysisInR/img/4.1.png)  
    ![4.2](https://github.com/zhukuixi/AshenOne/blob/master/MetaAnalysisInR/img/4.2.png)

* Random-Effects-Model
-   
Raw effect size data:   meta::metacont()
Pre-calculated effect size data:  meta::metagen