# Doing Meta-Analysis in R
[Tutorial](https://bookdown.org/MathiasHarrer/Doing_Meta_Analysis_in_R/detecting-outliers-influential-cases.html)

## Data Input
* It needs the following information for case and control group.  

**Type 1**:Standard effect size data (Mean,Standard deviation, SampleCount).   
**Type 2**:Event rate data (EventCount,SampleCount)  
**Type 3**:Incidence rate data (EventCount,TimePeriod)


## Pooling Effect Sizes
* Fixed-Effects-Model  
	- The fixed-effects-model assumes that all studies along with their effect sizes stem from a single homogeneous population
	[4.1]()

* Random-Effects-Model
-   
Raw effect size data:   meta::metacont()
Pre-calculated effect size data:  meta::metagen