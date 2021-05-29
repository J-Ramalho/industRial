


## Linear regression

One factor multiple levels

**The e-bike frame hardening process**

Mountain bikes frames are submitted to many different efforts, namely bending, compression and vibration. Although no one expects the frame to break in regular usage, manufacturers reputation is made on less visible performance features. One of them is the duration of the bike or in more technical terms in the number of cycles of such efforts that the frame resists. 

<div class="marginnote">

<div class="figure" style="text-align: center">
<img src="img/bike_frames_bw.jpg" alt="e-bike frames entering hardening treatment" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-2)e-bike frames entering hardening treatment</p>
</div>

</div>

We will present here a first example of the utilisation of linear regression techniques and establish a linear model. These models are going to be used extensively in the upcoming cases.


```r
ebike_narrow <- ebike_hardening %>%
  pivot_longer(
    cols = starts_with("g"),
    names_to = "observation",
    values_to = "cycles"
  ) %>%
  group_by(temperature) %>%
  mutate(cycles_mean = mean(cycles)) %>%
  ungroup()
```


```r
slice_head(.data = ebike_narrow, n = 5) %>% 
  kable(align = "c", 
        caption = "e-bike hardening experiment data")
```



Table: (\#tab:unnamed-chunk-4)e-bike hardening experiment data

| temperature | observation | cycles | cycles_mean |
|:-----------:|:-----------:|:------:|:-----------:|
|     160     |     g1      | 575000 |   551200    |
|     160     |     g2      | 542000 |   551200    |
|     160     |     g3      | 530000 |   551200    |
|     160     |     g4      | 539000 |   551200    |
|     160     |     g5      | 570000 |   551200    |



```r
ggplot(data = ebike_narrow) +
  geom_point(aes(x = temperature, y = cycles)) +
  geom_point(aes(x = temperature, y = cycles_mean), color = "red") +
  scale_y_continuous(n.breaks = 10, labels = label_number(big.mark = "'")) +
  theme(legend.position = "none") +
  labs(title = "e-bike frame hardening process",
       subtitle = "Raw data plot",
       x = "Furnace Temperature [°C]",
       y = "Cycles to failure [n]")
```

<img src="6_regression_files/figure-html/unnamed-chunk-5-1.png" width="100%" />

### Linear model {#lm}

We start by establishing the model, ensuring for now that we leave the variable `temperature` as a numeric vector. 


```r
ebike_lm <- lm(cycles ~ temperature, data = ebike_narrow)
summary(ebike_lm)
```

```

Call:
lm(formula = cycles ~ temperature, data = ebike_narrow)

Residuals:
   Min     1Q Median     3Q    Max 
-43020 -12325  -1210  16710  33060 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) 137620.0    41210.8   3.339  0.00365 ** 
temperature   2527.0      215.4  11.731 7.26e-10 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 21540 on 18 degrees of freedom
Multiple R-squared:  0.8843,	Adjusted R-squared:  0.8779 
F-statistic: 137.6 on 1 and 18 DF,  p-value: 7.263e-10
```

With the summary function we can many different outputs such as the coefficients and the R-squared which we will look into more detail now. As usual, we first inspect the data with a first plot. In this case we're adding a smoothing geometry with the lm method:


```r
ggplot(ebike_narrow) +
  geom_point(aes(x = temperature, y = cycles)) +
  geom_smooth(aes(x = temperature, y = cycles), method = "lm") +
  geom_point(aes(x = temperature, y = cycles_mean), color = "red") +
  scale_y_continuous(n.breaks = 10, labels = label_number(big.mark = "'")) +
  theme(legend.position = "none") +
  labs(title = "e-bike frame hardening process",
       subtitle = "Raw data plot",
       x = "Furnace Temperature [°C]",
       y = "Cycles to failure [n]")
```

<img src="6_regression_files/figure-html/unnamed-chunk-7-1.png" width="100%" />

### Contrasts treatment {#contr.treatment}

In our case the experiementer has selected to control the levels of the temperature variable in what is called a fixed effects model, accepting that conclusions in the comparisons of the levels cannot be extended to levels that were not tested. For this we're now going to convert the variable to a factor and establish again the model and note that it will give the same R squared but naturally different coefficients. 


```r
ebike_factor <- ebike_narrow %>%
  mutate(temperature = as_factor(temperature))
ebike_lm_factor <- lm(
  cycles ~ temperature, 
  data = ebike_factor,
  contrasts = list(temperature = "contr.treatment")
  )
summary(ebike_lm_factor)
```

```

Call:
lm(formula = cycles ~ temperature, data = ebike_factor, contrasts = list(temperature = "contr.treatment"))

Residuals:
   Min     1Q Median     3Q    Max 
-25400 -13000   2800  13200  25600 

Coefficients:
               Estimate Std. Error t value Pr(>|t|)    
(Intercept)      551200       8170  67.471  < 2e-16 ***
temperature180    36200      11553   3.133  0.00642 ** 
temperature200    74200      11553   6.422 8.44e-06 ***
temperature220   155800      11553  13.485 3.73e-10 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 18270 on 16 degrees of freedom
Multiple R-squared:  0.9261,	Adjusted R-squared:  0.9122 
F-statistic:  66.8 on 3 and 16 DF,  p-value: 2.883e-09
```

In order to be precise, we're making explicit in the lm function that the contrasts argument is "contr.treatment", although this is the default in R. More on contrasts on the Case Study on $2^k$ designs. The current contrasts settings can be seen as follows:


```r
getOption("contrasts")
```

```
        unordered           ordered 
"contr.treatment"      "contr.poly" 
```

We're now ready to assess the validity of the model in order to be ready for our main task which is the comparison of the means using an anova.

## Residuals analysis

In order to assess the model performance we're going to look into the residuals. R provides direct ploting functions with the base and stats packages but in this first example we're going to break down the analysis and further customise the plots. We are also going to make usage of some additional statistical tests to confirm our observations from the plots. In subsequent chapters we'll have a more selective approach, where plots and tests are made on a needed basis.

We start by loading the package broom which will help us retrieving the data from the lm object into a data frame.

Now we build and show below an extract of the "augmented" dataframe

### Model augment {#augment}


```r
library(broom)
```


```r
ebike_aug <- augment(ebike_lm_factor) %>%
  mutate(index = row_number())
ebike_aug %>%
  head() %>%
  kable(align = "c")
```



| cycles | temperature | .fitted | .resid | .hat |  .sigma  |  .cooksd  | .std.resid | index |
|:------:|:-----------:|:-------:|:------:|:----:|:--------:|:---------:|:----------:|:-----:|
| 575000 |     160     | 551200  | 23800  | 0.2  | 17571.09 | 0.1326135 | 1.4566455  |   1   |
| 542000 |     160     | 551200  | -9200  | 0.2  | 18678.69 | 0.0198157 | -0.5630730 |   2   |
| 530000 |     160     | 551200  | -21200 | 0.2  | 17846.38 | 0.1052218 | -1.2975161 |   3   |
| 539000 |     160     | 551200  | -12200 | 0.2  | 18534.92 | 0.0348460 | -0.7466838 |   4   |
| 570000 |     160     | 551200  | 18800  | 0.2  | 18069.13 | 0.0827465 | 1.1506275  |   5   |
| 565000 |     180     | 587400  | -22400 | 0.2  | 17723.81 | 0.1174708 | -1.3709604 |   6   |

We can see we've obtained detailed model parameters such us fitted values and residuals for each DOE run.

### Timeseries plot {#residuals_timeseries}

For this plot we need to ensure that the order of plotting in the x axis corresponds exactly to the original data collection order. This plot allows us to assess for strange patterns such as a  tendency to have runs of positive of negative results which indicates that the independency assumption does not hold. If patterns emerge then there may be correlation in the residuals.


```r
ebike_aug %>%
  ggplot(aes(x = index, y = .resid)) +
  geom_point() +
  scale_y_continuous(n.breaks = 10, labels = label_number(big.mark = "'")) +
  labs(
    title = "e-bike frame hardening process",
    subtitle = "Linear model - Residuals timeseries",
    y = "Index",
    x = "Fitted values"
  )
```

<img src="6_regression_files/figure-html/unnamed-chunk-12-1.png" width="100%" />

Nothing pattern emerges from the current plot and the design presents itself ^well randomised.

### Autocorrelation test {#autocorrelation}

It is always good to keep in mind that all visual observations can be complemented with a statistical test. In this case we're going to use the durbinWatson test from the car package (Companion to Applied Regression).


```r
library(car)
```


```r
durbinWatsonTest(ebike_lm_factor)
```

```
 lag Autocorrelation D-W Statistic p-value
   1      -0.5343347      2.960893   0.104
 Alternative hypothesis: rho != 0
```

Although the output shows Autocorrelation of -0.53 we have to consider that the p value is greater than 0.05 thus there is not enough significance to say that there is autocorrelation. 

### Residuals-Fit plot {#residuals_fit}

If the model is correct and the assumptions hold, the residuals should be structureless. In particular they should be unrelated to any other variable including the predicted response.


```r
ebike_aug %>%
  ggplot(aes(x = .fitted, y = .resid)) +
  geom_point() +
  geom_smooth(method = "loess", se = FALSE, color = "red") +
  scale_y_continuous(n.breaks = 10, labels = label_number(big.mark = "'")) +
  labs(
    title = "e-bike frame hardening process",
    subtitle = "Linear model - Residuals vs Fitted values",
    y = "Residuals",
    x = "Fitted values"
  )
```

<img src="6_regression_files/figure-html/unnamed-chunk-15-1.png" width="100%" />

In this plot we see no variance anomalies such as a higher variance for a certain factor level or other types of skweness.

### Homocedasticity {#homocedasticity}

Equality of variances

In the e-bike hardening process, the normality assumption is not in question, so we can apply Bartlett’s test to the etch rate data.



```r
bartlett.test(cycles ~ temperature, data = ebike_factor)
```

```

	Bartlett test of homogeneity of variances

data:  cycles by temperature
Bartlett's K-squared = 0.43349, df = 3, p-value = 0.9332
```

The P-value is P = 0.934, so we cannot reject the null hypothesis. There is no evidence to counter the claim that all five variances are the same. This is the same conclusion reached by analyzing the plot of residuals versus fitted values.

Notes: 
* the var.test function cannot be used here as it applies to the two levels case only
* this test is sensitive to the normality assumption, consequently, when the validity of this assumption is doubtful, the Bartlett test should not be used and replace by the modified Levene test for example

### Normality plot {#geom_qq}

As the sample size is relatively small we're going to use a qq plot instead of an histogram to assess the normality of the residuals.


```r
ebike_aug %>%
  ggplot(aes(sample = .resid)) +
  geom_qq() +
  geom_qq_line() +
  scale_y_continuous(n.breaks = 10, labels = label_number(big.mark = "'")) +
  labs(
    title = "e-bike frame hardening process",
    subtitle = "Linear model - qq plot",
    y = "Residuals",
    x = "Fitted values"
  )
```

<img src="6_regression_files/figure-html/unnamed-chunk-17-1.png" width="100%" />

The plot suggests normal distribution. We see that the error distribution is aproximately normal. In the fixed effects model we give more importance to the center of the values and here we consider acceptable that the extremes of the data tend to bend away from the straight line.
The verification can be completed by a test. For populations < 50 use the shapiro-wilk normality test.

### Normality test {#shapiroTest}


```r
shapiro.test(ebike_aug$.resid)
```

```

	Shapiro-Wilk normality test

data:  ebike_aug$.resid
W = 0.93752, p-value = 0.2152
```

p > 0.05 indicates that the residuals do not differ significantly from a normally distributed population.

### Standard Residuals-Fit plot {#std_residuals_fit}

This specific Standardized residuals graph also help detecting outliers in the residuals (any residual > 3 standard deviations is a potential outlier).


```r
ebike_aug %>% 
  ggplot(aes(x = .fitted, y = .std.resid)) +
  geom_point() +
  geom_smooth(method = "loess", se = FALSE, color = "red") +
  labs(title = "e-bike frame hardening process",
       subtitle = "Linear model - Standardised Residuals vs Fitted values",
       y = "Standardised Residuals",
       x = "Fitted values")
```

<img src="6_regression_files/figure-html/unnamed-chunk-19-1.png" width="100%" />

The plot shows no outliers to consider in this DOE.

### Outliers test {#outliers}

In a case where we were doubtfull we could go further and make a statistical test to assess if a certain value was an outlier. A usefull test is available in the car package.


```r
outlierTest(ebike_lm_factor)
```

```
No Studentized residuals with Bonferroni p < 0.05
Largest |rstudent|:
   rstudent unadjusted p-value Bonferroni p
12 1.648813            0.11997           NA
```

In this case, the Bonferroni adjusted p value comes as NA confirming that there is no outlier in the data.   

### Cooks distance {#cooks}


```r
ebike_aug %>% 
  ggplot(aes(x = .cooksd, y = .std.resid)) +
  geom_point() +
  geom_vline(xintercept = 0.5, color = "red") +
  labs(title = "e-bike frame hardening process",
       subtitle = "Residuals vs Leverage",
       y = "Standardised Residuals",
       x = "Cooks distance")
```

<img src="6_regression_files/figure-html/unnamed-chunk-21-1.png" width="100%" />

### Coefficient of determination {#R-squared}

The R square can be extracted from the linear model that has been used to build the Anova model.


```r
summary(ebike_lm_factor)$r.squared
```

```
[1] 0.9260598
```

Thus, in the e-bike hardening process, the factor “temperature” explains about 88% percent of the variability in etch rate.

Anova fixed effects assumes that:
- errors are normally distributed and are independent

As the number of residuals is too small we're not checking the normality via the histogram but rather with a a Q-Q plot.

## Multiple means comparison

We can also compare medians and get a sense of the effect of the treatment levels by looking into the box plot:


```r
ggplot(ebike_factor, 
       aes(x = temperature, y = cycles, fill = temperature)) +
  geom_boxplot() +
  scale_fill_viridis_d(option = "D", begin = 0.5) +
  scale_y_continuous(n.breaks = 10, labels = label_number(big.mark = "'")) +
  theme(legend.position = "none") +
  labs(title = "e-bike frame hardening process",
       subtitle = "Raw data plot",
       x = "Furnace Temperature [°C]",
       y = "Cycles to failure [n]")
```

<img src="6_regression_files/figure-html/unnamed-chunk-23-1.png" width="100%" />

1 factor with severals levels + 1 continuous dependent variable
Similar to the t-test but extended - this test allows to compare the means between several levels of treatement for a continuous response variable (the t test is only 2 levels at a time, performing all pair wise t-tests would also not be a solution because its a lot of effort and would increase the type I error)

ANOVA principle: the total variability in the data, as measured by the total corrected sum of squares, can be partitioned into a sum of squares of the differences between the treatment averages and the grand average plus a sum of squares of the differences of observations within treatments from the treatment average

### Analysis of variance {#aov}

In R the anova is built by passing the linear model to the anova or aov functions. The output of the anova function is just the anova table as shown here for this first example. The output of the aov function is a list.


```r
ebike_aov_factor <- aov(ebike_lm_factor)
summary(ebike_aov_factor)
```

```
            Df    Sum Sq   Mean Sq F value   Pr(>F)    
temperature  3 6.687e+10 2.229e+10    66.8 2.88e-09 ***
Residuals   16 5.339e+09 3.337e+08                     
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Note that the RF temperature or between-treatment mean square (22,290.18) is many times larger than the within-treatment or error mean square (333.70). This indicates that it is unlikely that the treatment means are equal. 
Also p < 0.05 thus we can reject the null hypothesis and conclude that the means are significantly different.

Anova on plasma etching, modification of the example to achieve a p > 0.05:


```r
ebike_narrow2 <- ebike_hardening2 %>%
  pivot_longer(
    cols = starts_with("g"),
    names_to = "observation",
    values_to = "cycles"
  ) %>%
  group_by(temperature) %>%
  mutate(cycles_mean = mean(cycles)) %>%
  ungroup()
ebike_factor2 <- ebike_narrow2
ebike_factor2$temperature <- as.factor(ebike_factor2$temperature)

ebike_lm_factor2 <- lm(cycles ~ temperature, data = ebike_factor2)
anova(ebike_lm_factor2)
```

```
Analysis of Variance Table

Response: cycles
            Df    Sum Sq   Mean Sq F value Pr(>F)
temperature  3 1.476e+09 492000000  1.2015  0.341
Residuals   16 6.552e+09 409500000               
```


```r
ggplot(ebike_factor2, 
       aes(x = temperature, y = cycles, fill = temperature)) +
  geom_boxplot() +
  scale_y_continuous(n.breaks = 10) +
  scale_fill_viridis_d(option = "A", begin = 0.5) +
  theme(legend.position = "none") +
  scale_y_continuous(n.breaks = 10, labels = label_number(big.mark = "'")) +
  labs(title = "e-bike frame hardening process",
       subtitle = "Boxplot of frame aging resistance",
       x = "Furnace Temperature [°C]",
       y = "Cycles to failure [n]")
```

<img src="6_regression_files/figure-html/unnamed-chunk-26-1.png" width="100%" />

P > 0.05 - there is no significant difference between the means

### Pairwise comparison {#tukey}

The Anova may indicate that the treament means differ but it won't indicate which ones. In this case we may want to compare pairs of means.


```r
ebike_tukey <- TukeyHSD(ebike_aov_factor, ordered = TRUE)
```


```r
head(ebike_tukey$temperature) %>% 
  kable(align = "c", 
        caption = "tukey test on e-bike frame hardening process", 
        booktabs = T)
```



Table: (\#tab:unnamed-chunk-28)tukey test on e-bike frame hardening process

|        |  diff  |    lwr     |    upr    |   p adj   |
|:-------|:------:|:----------:|:---------:|:---------:|
|180-160 | 36200  |  3145.624  | 69254.38  | 0.0294279 |
|200-160 | 74200  | 41145.624  | 107254.38 | 0.0000455 |
|220-160 | 155800 | 122745.624 | 188854.38 | 0.0000000 |
|200-180 | 38000  |  4945.624  | 71054.38  | 0.0215995 |
|220-180 | 119600 | 86545.624  | 152654.38 | 0.0000001 |
|220-200 | 81600  | 48545.624  | 114654.38 | 0.0000146 |

The test provides us a simple direct calculation of the differences between the treatment means and a confidence interval for those. Most importantly it provides us with the p value to help us confirm the significance of the difference and conclude factor level by factor level which differences are significant.

Additionally we can obtain the related plot with the confidence intervals 


```r
plot(ebike_tukey)
```

<img src="6_regression_files/figure-html/unnamed-chunk-29-1.png" width="100%" />

### Least significant difference {#fisherLSD}

Fisher's Least Significant difference is an alternative to Tuckey's test.


```r
library(agricolae)
```


```r
ebike_anova <- anova(ebike_lm_factor) 

ebike_LSD <- LSD.test(y = ebike_factor$cycles,
         trt = ebike_factor$temperature,
         DFerror = ebike_anova$Df[2],  
         MSerror = ebike_anova$`Mean Sq`[2],
         alpha = 0.05)
```

The Fisher procedure provides us with additional information. A first outcome is the difference between means (of life cycles) that can be considered significant, indicated in the table below by LSD = 24.49.


```r
head(ebike_LSD$statistics) %>% 
  kable(align = "c", 
        caption = "Fisher LSD procedure on e-bike frame hardening: stats",
        booktabs = T)
```



Table: (\#tab:unnamed-chunk-32)Fisher LSD procedure on e-bike frame hardening: stats

|   |  MSerror  | Df |  Mean  |    CV    | t.value  |   LSD    |
|:--|:---------:|:--:|:------:|:--------:|:--------:|:--------:|
|   | 333700000 | 16 | 617750 | 2.957095 | 2.119905 | 24492.02 |

Furthermore it gives us a confidence interval for each treatment level mean:


```r
head(ebike_LSD$means) %>% 
  # as_tibble() %>%
  rename(cycles = `ebike_factor$cycles`) %>%
  select(-Min, -Max, -Q25, -Q50, -Q75) %>%
  kable(align = "c", 
        caption = "Fisher LSD procedure on e-bike frame hardening: means", 
        booktabs = T)
```



Table: (\#tab:unnamed-chunk-33)Fisher LSD procedure on e-bike frame hardening: means

|    | cycles |   std    | r |   LCL    |   UCL    |
|:---|:------:|:--------:|:-:|:--------:|:--------:|
|160 | 551200 | 20017.49 | 5 | 533881.5 | 568518.5 |
|180 | 587400 | 16742.16 | 5 | 570081.5 | 604718.5 |
|200 | 625400 | 20525.59 | 5 | 608081.5 | 642718.5 |
|220 | 707000 | 15247.95 | 5 | 689681.5 | 724318.5 |

We can see for example that for temperature 220 °C the etch rate if on average 707.0 with a probability of 95% of being between 689.7 and 724.3 A/min.

Another interesting outcome is the grouping of levels for each factor:


```r
head(ebike_LSD$groups) %>% 
  kable(align = "c", 
        caption = "Fisher LSD procedure on e-bike frame hardening: groups", 
        booktabs = T)
```



Table: (\#tab:unnamed-chunk-34)Fisher LSD procedure on e-bike frame hardening: groups

|    | ebike_factor$cycles | groups |
|:---|:-------------------:|:------:|
|220 |       707000        |   a    |
|200 |       625400        |   b    |
|180 |       587400        |   c    |
|160 |       551200        |   d    |

In this case as all level means are statistically different they all show up in separate groups, each indicated by a specific letter.

Finally we can get from this package a plot with the Least significant difference error bars:


```r
plot(ebike_LSD)
```

<img src="6_regression_files/figure-html/unnamed-chunk-35-1.png" width="100%" />

And below we're exploring a manual execution of this type of plot (in this case with the standard deviations instead).


```r
ebike_factor %>%
  group_by(temperature) %>%
  summarise(cycles_mean = mean(cycles), 
            cycles_sd = sd(cycles)) %>%
  ggplot(aes(x = temperature, y = cycles_mean)) +
  geom_point(size = 2) +
  geom_line() +
  geom_errorbar(aes(ymin = cycles_mean - cycles_sd, 
                    ymax = cycles_mean + cycles_sd),
                width = .1) +
  scale_y_continuous(n.breaks = 10, labels = label_number(big.mark = "'")) +
  # scale_color_viridis_d(option = "C", begin = 0.1, end = 0.9) +
  annotate(geom = "text", x = Inf, y = -Inf, label = "Error bars are +/- 1xSD", 
    hjust = 1, vjust = -1, colour = "grey30", size = 3, 
    fontface = "italic") +
  labs(title = "e-bike frame hardening process",
       subtitle = "Boxplot of frame aging resistance",
       x = "Furnace Temperature [°C]",
       y = "Cycles to failure [n]")
```

<img src="6_regression_files/figure-html/unnamed-chunk-36-1.png" width="100%" />

As often with statistical tools, there is debate on the best approach to use. We recommend to combine the Tukey test with the Fisher's LSD completementary R functions. The Tukey test giving a first indication of the levels that have an effect and calculating the means differences and the Fisher function to provide much more additional information on each level. To be considered in each situation the slight difference  between the significance level for difference between means and to decide if required to take the most conservative one.

To go further in the Anova F-test we recommend this interesting article from @minitab_anovaftest.

## Forecasting

### Predict {#predict}

Following the residuals analysis and the anova our model is validated. 

A model is usefull for predictions. In a random effects model where conclusions can applied to the all the population we can predict values at any value of the input variables. In that case reusing the model with temperature as a numeric vector we could have a prediction for various temperature values such as:


```r
ebike_new <- tibble(temperature = c(170, 160, 200, 210))
predict(ebike_lm, newdata = ebike_new)
```

```
     1      2      3      4 
567210 541940 643020 668290 
```

We can see that the prediction at the tested levels is slightly different from the measured averages at those levels. This is because the linear interpolation line is not passing exactly by the averages.

Anyway this is a fixed effects model and we can only take conclusions at the levels at which the input was tested. We can check that the predictions correspond to the averages we've calculated for each level:


```r
ebike_new <- data.frame(temperature = as_factor(c("160", "200")))
predict(ebike_lm_factor, newdata = ebike_new)
```

```
     1      2 
551200 625400 
```











