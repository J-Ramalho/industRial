

# DOE - Design of Experiments {#DOE}

## One factor two levels

### Two means comparison

#### t-test one sample {#tTest}

Comparing mean to specification

An engineer working the winter sports clothing industry has established a contract for PET textile raw material supply based on the following specification: the average tensile strength has to be greater than 69.0 $Mpa$ for each delivery. In the contract is also specified that the test protocol which is based on a 30 samples.

<div class="figure" style="text-align: center">
<img src="img/tensile_test_bw.jpg" alt="PET tensile test" width="60%" />
<p class="caption">(\#fig:unnamed-chunk-2)PET tensile test</p>
</div>

A first delivery is submited and the customer wants to know if the lot average tensile strength exceeds the agreed level and if so, she wants to accept the lot.

We start by loading the first packages we will need:


```r
library(tidyverse)
library(readxl)
library(stats)

filter <- dplyr::filter
select <- dplyr::select
```


```r
library(industRial)
pet_delivery <- industRial::pet_delivery
```

The Quality Control department specialist at the reception starts by calcultating the average, a first criteria to reject the batch:


```r
mean(pet_delivery$strength)
```

```
[1] 68.46429
```

The average is itself below the spec and the engineer could reject the batch right away. She decides nevertheless to observe the variability and for this she decides to plot the raw data on an histogram. An histogram is a very common plot showing counts for selected intervals.


```r
pet_delivery %>% 
  ggplot(aes(x = strength)) +
  geom_histogram(fill = "cadetblue", 
                 color = "grey20") +
  theme_light() +
  # scale_x_continuous(breaks = seq(62, 74, 0.5)) +
  theme(legend.position = "none") +
  labs(title = "PET clothing case study",
       subtitle = "Raw data plot",
       x = "Treatment",
       y = "Tensile strength [MPa]")
```

<img src="two_means_comparison_files/figure-html/unnamed-chunk-6-1.png" width="80%" />


The mean is just slightly below the specification for acceptance and she also observes a certain variability in the batch. She decides then to perform a t-test to assess if the average calculated can be really be considered statistically smaller than the target value:


```r
t.test(x = pet_delivery$strength, mu = 69, alternative = "less")
```

```

	One Sample t-test

data:  pet_delivery$strength
t = -1.5906, df = 27, p-value = 0.06167
alternative hypothesis: true mean is less than 69
95 percent confidence interval:
     -Inf 69.03795
sample estimates:
mean of x 
 68.46429 
```

The basic assumption of the test is that the means are equal and the alternative hypothesis is that the sample mean is smaller than the spec. The confidence interval selected is 95%. The test gives her a p value of 6.2 % above the 5% threshold she had defined. The test confirms thus that she cannot exclude the basic assumption (the null hypotheses) and thus she cannot conclude that the sample mean is smaller.

#### t-test two samples

Comparing means

In order to avoid similar situations in the future the development engineer considers a new chemical compositions of cement that potentially increases the levels of strenght.

**Data loading**


```r
cement <- read_csv("../industRial/data-raw/2_cement.csv")
cement_long <- cement %>%
  pivot_longer(
    cols = everything(), names_to = "treatment", values_to = "y"
  )
```

**Raw data plot**

In data analysis it is good practice to start by plotting the raw data and have a first open look at what the first plots tell us.


```r
cement_long %>% 
  ggplot(aes(x = treatment, y = y, fill = treatment)) +
  geom_point() +
  theme_light() +
  theme(legend.position = "none") +
  labs(title = "Cement mortar case study",
       subtitle = "Raw data plot",
       x = "Treatment",
       y = "Bond strength")
```

<img src="two_means_comparison_files/figure-html/unnamed-chunk-9-1.png" width="80%" />

Another way to better understanding the bond distributions is to plot a box plot. This type of plot is somehow like the histogram seen before but more compact when several groups are required to be plotted.


```r
cement_long %>% 
  ggplot(aes(x = treatment, y = y, fill = treatment)) +
  geom_boxplot(width = 0.3) +
  theme_light() +
  theme(legend.position = "none") +
  labs(title = "Cement mortar case study",
       subtitle = "Raw data plot",
       x = "Treatment",
       y = "Bond strength")
```

<img src="two_means_comparison_files/figure-html/unnamed-chunk-10-1.png" width="80%" />

We would like to understand if the treatment has an effect. Thus we want to compare the two population means. For that we use a t test using samples obtained independently and randomly. Before running the test we also have to check the normality of the samples distributions and equality of their variances.

To do these checks we're using the stat_qq functions from the ggplot package and plotting the qq plots for both levels in the same plot:


```r
cement_long %>%
  ggplot(aes(sample = y, color = treatment)) +
  geom_qq() +
  geom_qq_line() +
  coord_flip() +
  theme_light() +
  labs(title = "Cement mortar case study",
       subtitle = "Raw data plot",
       x = "Treatment",
       y = "Bond strength")
```

<img src="two_means_comparison_files/figure-html/unnamed-chunk-11-1.png" width="80%" />

We observe that for both levels of treatment the data is adhering to the straight line thus we can assume they follow a normal distribution. Also both lines in the qq plot before have equivalent slopes indicating that the assumption of variances is a reasonable one. These verifications are summary ones. We review in subsequent sessions other deeper verifications of such as the shapiro-wilk normality test.

We're now going to apply the t-test:


```r
library(stats)
```


```r
t.test(y ~ treatment, data = cement_long, var.equal = TRUE)
```

```

	Two Sample t-test

data:  y by treatment
t = -2.1869, df = 18, p-value = 0.0422
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -0.54507339 -0.01092661
sample estimates:
  mean in group Modified mean in group Unmodified 
                  16.764                   17.042 
```

We see that p \< 0.05 thus the means differ significantly. Furthemore the mean difference is estimated with 95% confidence, to be between -0.55 and -0.01 (to be noted that zero is obviously not included in this interval). There is an effect in our treatment that explains the difference in means between the two samples.

#### t-test two samples paired


```r
hardness <- read_csv("../industRial/data-raw/2_hardness.csv")
t.test(x = hardness$Tip1, y = hardness$Tip2, paired = TRUE)
```

```

	Paired t-test

data:  hardness$Tip1 and hardness$Tip2
t = -0.26414, df = 9, p-value = 0.7976
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -0.9564389  0.7564389
sample estimates:
mean of the differences 
                   -0.1 
```

p \> 0.05 thus the means cannot be considered different (we cannot reject the null hypothesis) The mean difference is with 95% confidence between -0.96 and 0.76.

Note that because it is paired although there are 20 measurements there are only 9 degrees of freedom (10 times the differences between the measurements, minus 1).

Randomization of the test sequence is a required practice, not only because of operator effects but also due to other potentially unknown effects like machine warm up.
