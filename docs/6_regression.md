


## Linear regression

<div class="marginnote">

<b class="highlight">Case study: e-bike frame hardening</b>

Demand for electrical bicycles grows steadily and a global manufacturer is looking into improving the quality of his bicycle frames. A test program around different treatment temperatures is established to find the conditions that optimize the fatigue resistance.

<img src="img/bike_frames_bw.jpg" width="80%" style="display: block; margin: auto;" />

</div>

A way to go beyond the statistical description of samples and direct comparison between different tests it is to establish a model. Models help us simplify the reality and draw general conclusions. The case studies in this unit introduce linear models and their applications. They also serve as the backbone for statistical inference and forecasting. These are two important techniques because they provide mathematical evidence of such general conclusions in a context where the test quantities are strongly limited as for example in lifecycle testing of expensive mechanical parts.

Mountain bikes frames are submitted to many different efforts, namely bending, compression and vibration. Obviously no one expects a bike frame to break in regular usage and it is hard to commercialy claim resistance to failure as a big thing. Nevertheless on the long term a manufacturer reputation is made on performance features such as the number of cycles of effort that the frame resists. An e-bike manufacturing company is looking to increase the duration of its frames by improving the  <b class="highlight">e-bike frame hardening</b> process.

A test has been run with 5 groups of 30 bike frames submitted to 4 different treatment temperature levels and the data collected in the R tibble `ebike_hardening` presented below:


```r
head(ebike_hardening) %>%
  kable(align = "c")
```



| temperature |   g1   |   g2   |   g3   |   g4   |   g5   |
|:-----------:|:------:|:------:|:------:|:------:|:------:|
|     160     | 575000 | 542000 | 530000 | 539000 | 570000 |
|     180     | 565000 | 593000 | 590000 | 579000 | 610000 |
|     200     | 600000 | 651000 | 610000 | 637000 | 629000 |
|     220     | 725000 | 700000 | 715000 | 685000 | 710000 |

This type of two way entry is friendly for data collection but for manipulation with the `{tidyverse}` package functions it is often better to transform it in a long format.


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

slice_head(.data = ebike_narrow, n = 5) %>% 
  kable(align = "c", 
        caption = "e-bike hardening experiment data")
```



Table: (\#tab:fig-ebikenarrow)e-bike hardening experiment data

| temperature | observation | cycles | cycles_mean |
|:-----------:|:-----------:|:------:|:-----------:|
|     160     |     g1      | 575000 |   551200    |
|     160     |     g2      | 542000 |   551200    |
|     160     |     g3      | 530000 |   551200    |
|     160     |     g4      | 539000 |   551200    |
|     160     |     g5      | 570000 |   551200    |

The engineering team is looking forward to see the first results which have been prepared by the laboratory supervisor. He has prepared a series of plots and data models and sent out an draft report. The first plot is a simple dot plot having the raw data and in red the group means.  


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

<img src="6_regression_files/figure-html/fig-rawdataplot-1.png" width="100%" />

Clearly the highest the furnace temperature the higher the number of cycles to failure. This is absolutely expected as higher temperatures, up to a certain level, allow to release mechanical tensions and make the material less prone to fracture. The team knows that other factors are at play such as the treatment duration, the pre-heating temperature and many others related with the welding of the frame parts, but has deliberately decided to look only into the temperature due to time constraints related with a new bike launch.

### Linear model {#lm}


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
(Intercept)   137620      41211    3.34   0.0036 ** 
temperature     2527        215   11.73  7.3e-10 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 21500 on 18 degrees of freedom
Multiple R-squared:  0.884,	Adjusted R-squared:  0.878 
F-statistic:  138 on 1 and 18 DF,  p-value: 7.26e-10
```

This last code chunk in lab supervisor draft report is a linear model built with the variable `temperature` as a numeric vector. The R `summary()` function produces a specific output for linear models and a dedicated help explaining each output value can be accessed with `?summary.lm`. Knowing that R uses specific "methods" to provide the summaries for many functions is useful to find their help pages and a way to list them is `apropos("summary)`.

In this case we see a high R-squared suggesting a very good fit and that the temperature is significant by looking at the 3 *significance stars* next to its p-value. It is good to complement the raw data plot with a regression line corresponding to this linear model as done in the next chunk with the function `geom_smooth()`:


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

<img src="6_regression_files/figure-html/fig-ebikesmooth-1.png" width="100%" />

The engineering team has selected to specify and control the temperature variable at specific levels in what is called a fixed effects model, limiting the conclusions to the levels tested. The lab supervisor updates his model by converting the temperature variable to a factor and establishes again the linear model. He explicitly introduces the argument `contrasts` as cont.treatment to make clear that this was his option. In principle this is not needed because this is default setting for the contrasts as seen with `getOption("contrasts")`.


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
(Intercept)      551200       8170   67.47  < 2e-16 ***
temperature180    36200      11553    3.13   0.0064 ** 
temperature200    74200      11553    6.42  8.4e-06 ***
temperature220   155800      11553   13.49  3.7e-10 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 18300 on 16 degrees of freedom
Multiple R-squared:  0.926,	Adjusted R-squared:  0.912 
F-statistic: 66.8 on 3 and 16 DF,  p-value: 2.88e-09
```

### Contrasts {#contr.treatment}

We saw that from the first model to the second the R-squared has slightly improved and that he obtains slightly different model coefficients. In R the model coefficients depend on the variable variable data type. To obtain equivalent results with the different type coding it is necessary to carefully set the model **contrasts**. Factor type coding and contrasts define different lead to different linear regression equations. We can see the coefficients and use them to calculate the output with a matrix multiplication  as follows:


```r
ebike_lm$contrasts$temperature
```

```
NULL
```

```r
ebike_lm$coefficients 
```

```
(Intercept) temperature 
     137620        2527 
```

```r
ebike_lm$coefficients %*% c(1, 180)
```

```
       [,1]
[1,] 592480
```

this show that to calculate the output for an input of 180 we have 137620 + 180 x 2'527 = 592'480. Differently When the temperature is coded as a factor we have the following coefficients and output calculation:


```r
ebike_lm_factor$contrasts$temperature
```

```
[1] "contr.treatment"
```

```r
ebike_lm_factor$coefficients
```

```
   (Intercept) temperature180 temperature200 temperature220 
        551200          36200          74200         155800 
```

```r
ebike_lm_factor$coefficients %*% c(1, 1, 0, 0)
```

```
       [,1]
[1,] 587400
```

The output is slightly different corresponding to 551'200 + 1 x 36'200 = 587'400.

### Predict {#predict}

A model is useful for predictions. In a random effects model where conclusions can applied to the all the population we can predict values at any value of the input variables. In that case reusing the model with temperature as a numeric vector we could have a prediction for various temperature values such as:


```r
ebike_new <- tibble(temperature = c(180, 200, 210))
predict(ebike_lm, newdata = ebike_new)
```

```
     1      2      3 
592480 643020 668290 
```

We can see that the prediction at the tested levels is slightly different from the measured averages at those levels. This is because the linear interpolation line is not passing exactly by the averages.

Anyway this is a fixed effects model and we can only take conclusions at the levels at which the input was tested. We can check that the predictions correspond to the averages we've calculated for each level:


```r
ebike_new <- data.frame(temperature = as_factor(c("180", "200")))
predict(ebike_lm_factor, newdata = ebike_new)
```

```
     1      2 
587400 625400 
```

We find again exactly the same values calculated with the linear regression coefficients before. The `predict()` function has other advantages such as providing confidence intervals which will be explored in later case studies.

The lab supervisor is now ready to assess the validity of the model. This is required before entering the main objective which is comparing the treatment means using an anova. To do this assessment the model he is going to do a residuals analysis. R provides direct plotting functions with the base and stats packages but he opted to break down the analysis and use custom the plots. He also uses some additional statistical tests to confirm our observations from the plots. He starts by loading the package broom which will help him retrieving the data from the lm object into a data frame.

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



| cycles | temperature | .fitted | .resid | .hat | .sigma | .cooksd | .std.resid | index |
|:------:|:-----------:|:-------:|:------:|:----:|:------:|:-------:|:----------:|:-----:|
| 575000 |     160     | 551200  | 23800  | 0.2  | 17571  | 0.13261 |  1.45665   |   1   |
| 542000 |     160     | 551200  | -9200  | 0.2  | 18679  | 0.01982 |  -0.56307  |   2   |
| 530000 |     160     | 551200  | -21200 | 0.2  | 17846  | 0.10522 |  -1.29752  |   3   |
| 539000 |     160     | 551200  | -12200 | 0.2  | 18535  | 0.03485 |  -0.74668  |   4   |
| 570000 |     160     | 551200  | 18800  | 0.2  | 18069  | 0.08275 |  1.15063   |   5   |
| 565000 |     180     | 587400  | -22400 | 0.2  | 17724  | 0.11747 |  -1.37096  |   6   |

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

<img src="6_regression_files/figure-html/unnamed-chunk-6-1.png" width="100%" />

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
   1        -0.53433        2.9609    0.09
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

<img src="6_regression_files/figure-html/unnamed-chunk-9-1.png" width="100%" />

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
Bartlett's K-squared = 0.433, df = 3, p-value = 0.93
```

The P-value is P = 0.934, so we cannot reject the null hypothesis. There is no evidence to counter the claim that all five variances are the same. This is the same conclusion reached by analyzing the plot of residuals versus fitted values.

Notes: 
* the var.test function cannot be used here as it applies to the two levels case only
* this test is sensitive to the normality assumption, consequently, when the validity of this assumption is doubtful, the Bartlett test should not be used and replace by the modified Levene test for example

### Normality plot

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

<img src="6_regression_files/figure-html/unnamed-chunk-11-1.png" width="100%" />

The plot suggests normal distribution. We see that the error distribution is aproximately normal. In the fixed effects model we give more importance to the center of the values and here we consider acceptable that the extremes of the data tend to bend away from the straight line.
The verification can be completed by a test. For populations < 50 use the shapiro-wilk normality test.

### Normality test {#shapiroTest}


```r
shapiro.test(ebike_aug$.resid)
```

```

	Shapiro-Wilk normality test

data:  ebike_aug$.resid
W = 0.938, p-value = 0.22
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

<img src="6_regression_files/figure-html/unnamed-chunk-13-1.png" width="100%" />

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
12   1.6488            0.11997           NA
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

<img src="6_regression_files/figure-html/unnamed-chunk-15-1.png" width="100%" />

### Coefficient of determination {#R-squared}

The R square can be extracted from the linear model that has been used to build the Anova model.


```r
summary(ebike_lm_factor)$r.squared
```

```
[1] 0.92606
```

Thus, in the e-bike hardening process, the factor “temperature” explains about 88% percent of the variability in etch rate.

Anova fixed effects assumes that:
- errors are normally distributed and are independent

As the number of residuals is too small we're not checking the normality via the histogram but rather with a a Q-Q plot.

