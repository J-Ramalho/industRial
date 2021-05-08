

### Two variances comparison

Bonett's test is accurate for any continuous distribution and does not require that the data are normal. Bonett's test is usually more reliable than Levene's test.

Levene's test is also accurate with any continuous distribution. For extremely skewed and heavy tailed distributions, Levene's method tends to be more reliable than Bonett's method.

The F-test is accurate only for normally distributed data. Any small deviation from normality can cause the F-test to be inaccurate, even with large samples. However, if the data conform well to the normal distribution, then the F-test is usually more powerful than either Bonett's test or Levene's test.


```r
library(tidyverse)
library(readxl)
library(stats)

filter <- dplyr::filter
select <- dplyr::select
```

#### Bonett's test


#### Levene test {#leveneTest}

Homogeneity of variances test

You want test samples to see for homogeneity of variance (homoscedasticity)

**Data loading**


```r
cement <- read_csv("../industRial/data-raw/2_cement.csv")
cement_long <- cement %>%
  pivot_longer(
    cols = everything(), names_to = "treatment", values_to = "y"
  )
```


```r
library(car)
```


```r
leveneTest(y ~ treatment, data = cement_long)
```

```
Levene's Test for Homogeneity of Variance (center = median)
      Df F value Pr(>F)
group  1  1.9528 0.1793
      18               
```

Pr \> 0.05 thus there is homogeneity of the variances (they do not differ significantly).


#### F-test {#FTest}

We're now confirming this with a variance test from the stats package.


```r
var.test(y ~ treatment, cement_long)
```

```

	F test to compare two variances

data:  y by treatment
F = 1.6293, num df = 9, denom df = 9, p-value = 0.4785
alternative hypothesis: true ratio of variances is not equal to 1
95 percent confidence interval:
 0.4046845 6.5593806
sample estimates:
ratio of variances 
          1.629257 
```

The test null hypothesis is that the variances are equal. Since the p value is much greater than 0.05 we cannot reject the null hypotheses meaning that we can consider them equal.

In other words the probability that the variances are different is 47.85% due to random cause.

