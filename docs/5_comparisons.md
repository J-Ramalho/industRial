


# Design of Experiments {#DOE}

Companies manufacturing goods in industrial quantities have a permanent need to improve the features of their products. This is visible in any such industry be it car parts, watches, electronic components for cell phones, chocolates, clothing, medical devices, medicine, ... the list could go on forever. As consumers we expect flawless quality at affordable price and we want to remain free to choose another brand if our confidence has been damaged due to a defective product. Adding to this fortunately the last decades have seen an increasing pressure to develop sustainable products that are responsibly sourced, meet stringent regulations and can last for many years and be properly disposable. Another constraint that can be observed in Research and Development is the growing awareness of the public on ethical issues. There is an increasing expectation that trials generate minimal waste and are done in a way respectful of test subjects human and animal.

Experiment design provides ways to meet these important requirements by making us think upfront on what is required and how to best approach a test. Integrated in a complete solid design for quality approach it can provide deep insights on the principles of a system and support decision making based on data. A well prepared test plan minimizes trial and error and reduces the number of prototypes, measurements and time required. 

There are many well tested approaches, the domain is very large and our textbook can only cover a subset of the many types of DoEs used in the industry. For all these cases statistical notions are key to have a minimal preparation of the test and a valid interpretation of the results. Some statistical concepts every engineer, technician or scientist has to understand go around sampling, sample size, probability, correlation and variability. It is important to be clear about the vocabulary and the mathematics that are behind the constantly used statistics such as the mean, median, variance, standard deviation and so on. We provide a glossary and good bibliography that can be both a good starting point or a refresher. In particular the text and the case studies follow what we consider to be the most important book in this the domain, the *Design and Analysis of Experiments* by @Montgomery2012.

## Direct comparisons

<div class="marginnote">

<b class="highlight">Case study: winter sports clothing</b>

All winter sports clothing are virtually made with a mix of natural fibers and synthetic polymers. Upgrading to recyclable polymers while keeping performance requires extensive testing of raw material characteristics such as the tensile strength.

<img src="img/tensile_test_bw.jpg" width="100%" />

</div>

We start by exploring simple tests that compare results obtained in two samples. These cases happen all the time as everyone needs one moment or another to compare things. It can be the result of a test before and after an improvement, it can be two different materials applied in the same assembly or still different results obtained by different teams at different moments. 

In this case, a materials engineer working in the <b class="highlight">winter sports clothing industry</b> is working with a polymer company to develop a textile raw material based on PET for which the mean tensile strength has to be greater than 69.0 MPa. A first delivery of samples arrives, the materials laboratory measures 28 samples and reports that the test result is not meeting the contract specification. The materials engineer is informed and get hold of the raw data, in the lab system she can see the measurement summary:


```r
summary(pet_delivery$A)
```

```
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   64.5    68.2    68.8    68.7    69.4    72.0 
```

The mean is in fact slightly lower that the specified contract value of 69 and the materials engineer could think to confirm the rejection the batch right away. She decides nevertheless to observe how do the measurements vary. She plots the raw data on an histogram which is a very common plot showing counts for selected intervals.

### Histogram {#histogram}


```r
pet_spec <- 69
pet_mean <- mean(pet_delivery$A)

pet_delivery %>% 
  ggplot(aes(x = A)) +
  geom_histogram(color = viridis(12)[4], fill = "grey90") +
  scale_x_continuous(n.breaks = 10) +
  geom_vline(xintercept = pet_mean, color = "darkblue", linetype = 2, size = 1) +
  geom_vline(xintercept = pet_spec, color = "darkred", linetype = 2, 
             show.legend = TRUE) +
  labs(title = "PET raw material delivery",
       subtitle = "Histogram of resistance measurements",
       y = "Count",
       x = "Tensile strength [MPa]", 
       caption = "Specification min in red, Batch mean in blue¨")
```

<img src="5_comparisons_files/figure-html/fig-pethistogram-1.png" width="100%" />

She also observes a certain variability in the batch with many samples with measurements below specification getting close to 64 MPa. She remembers that in this case a t-test could help assessing if the mean that was obtained can be really be considered statistically different from the target value.

### t-test one sample {#t.test}


```r
t.test(x = pet_delivery$A, mu = pet_spec)
```

```

	One Sample t-test

data:  pet_delivery$A
t = -1.08, df = 27, p-value = 0.29
alternative hypothesis: true mean is not equal to 69
95 percent confidence interval:
 68.157 69.263
sample estimates:
mean of x 
    68.71 
```

The basic assumption of the test is that the mean and the reference value are identical and the alternative hypothesis is that their different. The confidence interval selected is 95% as it is common practice in the laboratory. The test result tells us that for a population average of 69, the probability of obtaining a sample with a value as extreme as 68.71 is 29% (p = 0.29). This probability value higher than the limit of 5% that she usually uses to reject the null hypothesis. In fact she cannot conclude that the sample comes from a population with a mean different than 69.

She's not sure what to do of this result and decides asking help to a colleague statistician from R&D: has she applied the right? is the specification correctly defined or should it refer to the minimum sample value? Her colleague confirms that to compare means this is a good approach and as the standard deviation of the production is not available it is reasonable to use the standard deviation from the sample. This is an important detail that was not introduced explicitly as an argument in the R function. As we they are still in the initial steps of the new development they agree that it is a good idea to accept the batch. For the next deliveries the statistic recommends to try to improve the tensile strength average and reduce the variability. For the next delivery she also recommends to agree on a minimum sample size of 30 parts and to redo the t.test but for regular production the team should consider implementing a proper AQL protocol.

Improving recyclability while keeping current performance is no easy task. Often novel materials are expensive as their commercial volumes are small and suppliers claim a premium on their own R&D efforts. Consumers of clothing are getting more and more sensitive to waste and to recycling but they don't always choose products with a higher price to compensate.

Following the not fully successful experience with the first delivery of  recyclable PET our materials engineer considers a new chemical composition that potentially increases the levels of strength. When the second delivery arrives she establishes a simple plot with the raw data to have a first grasp of the expected improvement.


```r
pet_delivery_long <- pet_delivery %>%
  pivot_longer(
    cols = everything(), names_to = "sample", values_to = "tensile_strength"
  )

pet_delivery_long %>% 
  ggplot(aes(x = sample, y = tensile_strength)) +
  geom_jitter(width = 0.1, size = 0.8) +
  theme(legend.position = "none") +
  labs(title = "PET clothing case study",
       subtitle = "Raw data plot",
       x = "Sample",
       y = "Tensile strength [MPa]")
```

<img src="5_comparisons_files/figure-html/fig-PETjitterplot-1.png" width="100%" />

Choosing `geom_jitter()` instead of simply `geom_point()` avoids overlapping of the dots but has to used with caution as sometimes for precise reading can lead to mistakes. Dot plots also lack information sample statistics and a way to better understanding the bond distributions is to go for a box plot. This type of plot is somehow like the histogram seen before but more compact when several groups are required to be plotted.


```r
pet_delivery_long %>% 
  ggplot(aes(x = sample, y = tensile_strength, fill = sample)) +
  geom_boxplot(width = 0.3) +
  geom_jitter(width = 0.1, size = 0.8) +
  scale_fill_viridis_d(begin = 0.5, end = 0.9) +
  scale_y_continuous(n.breaks = 10) +
  theme(legend.position = "none") +
  labs(title = "PET clothing case study",
       subtitle = "Box plot",
       x = "Sample",
       y = "Tensile strength [MPa]")
```

<img src="5_comparisons_files/figure-html/fig-PETboxplot-1.png" width="100%" />

In this case she has simply added another layer to the previous plot getting both the dots and the boxes. Now she can see the median and the quantiles. The new sample has clearly higher values and she would like to confirm if the new formulation has a significant effect. While before she was comparing the sample mean with the specification, here she wants to compare the means of the two samples. A direct calculation of this difference gives:


```r
PET_meandiff <- mean(pet_delivery$A) - mean(pet_delivery$B)
PET_meandiff
```

```
[1] -0.86286
```

To use the t.test it is important to have samples obtained independently and randomly, to check the normality of their distributions and the equality of their variances.

To do these checks our materials engineer is using the `geom_qq()` function from the `{ggplot}` package and gets directly the normality plots for both samples in the same plot:

### Normality plot {#geom_qq}


```r
pet_delivery_long %>%
  ggplot(aes(sample = tensile_strength, color = sample)) +
  geom_qq() +
  geom_qq_line() +
  coord_flip() +
  scale_color_viridis_d(begin = 0.1, end = 0.7) +
  labs(title = "PET clothing case study",
       subtitle = "Q-Q plot",
       x = "Residuals",
       y = "Tensile strength [MPa]")
```

<img src="5_comparisons_files/figure-html/fit-PETqqplot-1.png" width="100%" />

We observe that for both formulation the data is adhering to the straight line thus we consider that it follows a normal distribution. We also see that both lines in the qq plot  have equivalent slopes indicating that the assumption of variances is a reasonable one. Visual observations are often better supported by tests such as the variance test.

### F-test {#var.test}


```r
var.test(tensile_strength ~ sample, pet_delivery_long)
```

```

	F test to compare two variances

data:  tensile_strength by sample
F = 1.28, num df = 27, denom df = 27, p-value = 0.53
alternative hypothesis: true ratio of variances is not equal to 1
95 percent confidence interval:
 0.59026 2.75635
sample estimates:
ratio of variances 
            1.2755 
```

The `var.test()` from the `{stats}` package us a simple and direct way to compare variances. The F-test is accurate only for normally distributed data. Any small deviation from normality can cause the F-test to be inaccurate, even with large samples. However, if the data conform well to the normal distribution, then the F-test is usually more powerful than Levene's test. The test null hypothesis is that the variances are equal. Since the p value is much greater than 0.05 we cannot reject the null hypotheses meaning that we can consider them equal.

### Levene test {#levene.test}


```r
library(car)
leveneTest(tensile_strength ~ sample, data = pet_delivery_long)
```

```
Levene's Test for Homogeneity of Variance (center = median)
      Df F value Pr(>F)
group  1    0.01   0.91
      54               
```

We had considered the samples to be normally distributed but we can be more conservative and use the `leveneTest()` function from the `{car}` package. In this case we get a p > 0.05 thus again we see that there is homogeneity of the variances (they do not differ significantly). Further elaborations on the variance can be found under @minitab_variances.

The clothing sports materials engineer has now a view on the samples distribution and homogeneity of variances and can apply t.test to compare the sample means. She takes care to specify the `var.equal` argument as TRUE (by default it is FALSE).

### t-test two samples


```r
t.test(
  tensile_strength ~ sample, 
  data = pet_delivery_long, var.equal = TRUE
  )
```

```

	Two Sample t-test

data:  tensile_strength by sample
t = -2.4, df = 54, p-value = 0.02
alternative hypothesis: true difference in means between group A and group B is not equal to 0
95 percent confidence interval:
 -1.58500 -0.14072
sample estimates:
mean in group A mean in group B 
         68.710          69.573 
```

She sees that p < 0.05 and confirms the means differ significantly. The test output has also provided a confidence interval for the difference between the means at 95% probability and the mean difference calculated directly of -0.86286 falls inside this interval (to be noted that zero is obviously not included in this interval). Things look promising in the new recyclable PET formulation.
