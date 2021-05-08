

### Sample size


```r
library(tidyverse)
library(readxl)
library(stats)

filter <- dplyr::filter
select <- dplyr::select
```

**Data loading**


```r
cement <- read_csv("../industRial/data-raw/2_cement.csv")
cement_long <- cement %>%
  pivot_longer(
    cols = everything(), names_to = "treatment", values_to = "y"
  )
```


```r
# Calculate the required sample size for a certain t-test power
cohen_d <- 0.27 / 0.25 # Cohen's effect size = difference of means / sd
# A Cohen's d of 2 means that the averages changed by 2 standard deviations, which is very large.
power.t.test(d = cohen_d, power = 0.95)
```

```

     Two-sample t test power calculation 

              n = 23.28802
          delta = 1.08
             sd = 1
      sig.level = 0.05
          power = 0.95
    alternative = two.sided

NOTE: n is number in *each* group
```


```r
library(lsr)
```


```r
# By comparison, calculate Cohen's d for the dataset
cohensD(x = cement$Modified, y = cement$Unmodified)
```

```
[1] 0.9780006
```

In this example if we wanted to detect a significant difference of at least 0.25 in the means with a probability of at least 95% (Power of 0.95) we would need to use 8 (7.6) samples of each (to be)


