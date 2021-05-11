

# Design of Experiments {#DOE}

In a design of experiements we calculate the total number of trials with the expression $n^m$ where n is the number of levels, m the number of factors. A trial represents the number of unique combinations of the factors. To obtain the final number of test runs we have to multiply the number of trials by the number of replicates per trial.

In a design with 4 factors of 2 levels we have then $2^4 = 16$ runs and $16 \times 5 = 80$ replicates. 

If the design has a combination of factors with different number of levels the number of trials is the multiplication of both such as: $n^m \times n^m$. 

For example if we added 2 additional factors with 4 levels each to the previous design we would obtain $2^4 \times 4^2 = 256$ which we would still need to multiply by the number of replicates to obtain the number of runs $256 \times 5 = 1280$.

In the literature we often see the simbolic notation $a^k$ but we've opted for mF-nL (m factors, n levels) in this book for simplification.

## Simple experiments

1 factor 2 levels

In this chapter we cover introductory designs of experiments and take it progressively until the general 2^k factorial designs. In any case this pretends to be an introduction to the topic with only a subset of the many types of DoEs used in the industry.

### Means comparison

#### t-test one sample

**The Winter Sports clothing manufacturer**

Comparing mean to specification

An engineer working the winter sports clothing industry has established a contract for PET textile raw material supply based on the following specification: the average tensile strength has to be greater than 69.0 $Mpa$ for each delivery. In the contract is also specified that the test protocol which is based on a 30 samples.

<div class="marginnote">

<div class="figure" style="text-align: center">
<img src="img/tensile_test_bw.jpg" alt="PET tensile test" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-2)PET tensile test</p>
</div>

</div>

A first delivery is submited and the customer wants to know if the lot average tensile strength exceeds the agreed level and if so, she wants to accept the lot.

We start by loading the first packages we will need:


```r
library(tidyverse)
library(skimr)
library(readxl)
library(stats)
library(viridis)
filter <- dplyr::filter
select <- dplyr::select
```


```r
library(industRial)
```

The Quality Control department specialist at the reception starts by calcultating the average, a first criteria to reject the batch:


```r
pet_spec <- 69
pet_mean <- mean(pet_delivery$A)
pet_mean
```

```
[1] 68.71
```

The average is itself below the spec and the engineer could think to reject the batch right away. She decides nevertheless to observe the variability and for this she decides to plot the raw data on an histogram. An histogram is a very common plot showing counts for selected intervals.


```r
pet_delivery %>% 
  ggplot(aes(x = A)) +
  geom_histogram(color = viridis(12)[4], fill = "grey90") +
  geom_vline(xintercept = pet_mean, color = "darkblue", linetype = 3) +
  geom_vline(xintercept = pet_spec, color = "darkgreen", linetype = 2, 
             show.legend = TRUE) +
  # scale_x_continuous(breaks = seq(62, 74, 0.5)) +
  theme_industRial() +
  labs(title = "PET clothing case study",
       subtitle = "Raw data plot",
       x = "Treatment",
       y = "Tensile strength [MPa]")
```

<img src="5_simpleDOE_files/figure-html/unnamed-chunk-6-1.png" width="80%" />

The mean is just slightly below the target mean defined for acceptance and she also observes a certain variability in the batch. She decides then to perform a t-test to assess if the average calculated can be really be considered statistically different than the target value.

#### t test {#tTest}


```r
t.test(x = pet_delivery$A, mu = pet_spec)
```

```

	One Sample t-test

data:  pet_delivery$A
t = -1.0754, df = 27, p-value = 0.2917
alternative hypothesis: true mean is not equal to 69
95 percent confidence interval:
 68.15668 69.26332
sample estimates:
mean of x 
    68.71 
```

The basic assumption of the test is that the means are equal and the alternative hypothesis is that the sample mean is different than the spec. The confidence interval selected is 95%.

The test result tells us that for a population average of 69, the probability of obtaining a sample with a value as extreme as 68.71 is of 29.17% (p = 0.2917). This probability value higher than the limit of 5% that she had defined to reject the null hypothesis. She cannot conclude that the sample commes from a population with a mean different than 69 and thus decides to accept the batch.

#### t-test two samples

Comparing means

In order to avoid similar situations in the future the development engineer considers a new chemical compositions of pet that potentially increases the levels of strenght.

**Data loading**


```r
pet_delivery_long <- pet_delivery %>%
  pivot_longer(
    cols = everything(), names_to = "sample", values_to = "tensile_strength"
  )
```

**Raw data plot**

In data analysis it is good practice to start by plotting the raw data and have a first open look at what the first plots tell us.


```r
pet_delivery_long %>% 
  ggplot(aes(x = sample, y = tensile_strength)) +
  geom_point() +
  theme_industRial() +
  theme(legend.position = "none") +
  labs(title = "PET clothing case study",
       subtitle = "Raw data plot",
       x = "Sample",
       y = "Tensile strength [MPa]")
```

<img src="5_simpleDOE_files/figure-html/unnamed-chunk-9-1.png" width="80%" />

Another way to better understanding the bond distributions is to plot a box plot. This type of plot is somehow like the histogram seen before but more compact when several groups are required to be plotted.


```r
pet_delivery_long %>% 
  ggplot(aes(x = sample, y = tensile_strength, fill = sample)) +
  geom_boxplot(width = 0.3) +
  scale_fill_viridis_d(begin = 0.5, end = 0.8) +
  theme_industRial() +
  theme(legend.position = "none") +
  labs(title = "PET clothing case study",
       subtitle = "Box plot",
       x = "Sample",
       y = "Tensile strength [MPa]")
```

<img src="5_simpleDOE_files/figure-html/unnamed-chunk-10-1.png" width="80%" />

We would like to understand if the treatment has an effect. Thus we want to compare the two population means. For that we use a t test using samples obtained independently and randomly. Before running the test we also have to check the normality of the samples distributions and equality of their variances.

To do these checks we're using the stat_qq functions from the ggplot package and plotting the qq plots for both levels in the same plot:


```r
pet_delivery_long %>%
  ggplot(aes(sample = tensile_strength, color = sample)) +
  geom_qq() +
  geom_qq_line() +
  coord_flip() +
  scale_color_viridis_d(begin = 0.1, end = 0.7) +
  theme_industRial() +
  labs(title = "PET clothing case study",
       subtitle = "Q-Q plot",
       x = "Residuals",
       y = "Tensile strength [MPa]")
```

<img src="5_simpleDOE_files/figure-html/unnamed-chunk-11-1.png" width="80%" />

We observe that for both levels of treatment the data is adhering to the straight line thus we can assume they follow a normal distribution. Also both lines in the qq plot  have equivalent slopes indicating that the assumption of variances is a reasonable one. These verifications are summary ones. We review in subsequent sessions other deeper verifications of such as the shapiro-wilk normality test.

We're now going to apply the t-test:


```r
library(stats)
```


```r
t.test(tensile_strength ~ sample, data = pet_delivery_long, var.equal = TRUE)
```

```

	Two Sample t-test

data:  tensile_strength by sample
t = -2.3956, df = 54, p-value = 0.02009
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -1.5849965 -0.1407177
sample estimates:
mean in group A mean in group B 
       68.71000        69.57286 
```

We see that p \< 0.05 thus the means differ significantly. Furthemore the mean difference is estimated with 95% confidence, to be between -0.55 and -0.01 (to be noted that zero is obviously not included in this interval). There is an effect in our treatment that explains the difference in means between the two samples.

### Variances comparison

#### F-test {#FTest}

We're now confirming this with a variance test from the stats package.


```r
var.test(tensile_strength ~ sample, pet_delivery_long)
```

```

	F test to compare two variances

data:  tensile_strength by sample
F = 1.2755, num df = 27, denom df = 27, p-value = 0.5315
alternative hypothesis: true ratio of variances is not equal to 1
95 percent confidence interval:
 0.5902643 2.7563454
sample estimates:
ratio of variances 
          1.275528 
```

The test null hypothesis is that the variances are equal. Since the p value is much greater than 0.05 we cannot reject the null hypotheses meaning that we can consider them equal.

The F-test is accurate only for normally distributed data. Any small deviation from normality can cause the F-test to be inaccurate, even with large samples. However, if the data conform well to the normal distribution, then the F-test is usually more powerful than Levene's test.

#### Levene test {#leveneTest}

This test is assessing the homogeneity of variances (homoscedasticity).


```r
library(car)
```


```r
leveneTest(tensile_strength ~ sample, data = pet_delivery_long)
```

```
Levene's Test for Homogeneity of Variance (center = median)
      Df F value Pr(>F)
group  1  0.0118 0.9139
      54               
```

Pr \> 0.05 thus there is homogeneity of the variances (they do not differ significantly).

Further elaborations on the variance can be found under @minitab_variances.
