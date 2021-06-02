




## Effects significance

The commercial introduction of the new e-bike model is approaching soon and production is expected to start in a couple of months. The engineering team is getting impacient because the parameters for the frame thermal treatment are not yet defined. The engineering head call for a second meeting to review once more the DoE outputs. The lab supervisor reopens his Rmd report tries to go beyond the linear model discussed before. He created raw data plots with dots on individual data points but now he thinks it is important to have a view on the data distribution and some summary statistics. For that he prepares a box plot:


```r
ggplot(
  ebike_factor, 
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

<img src="7_effects_files/figure-html/unnamed-chunk-3-1.png" width="100%" />

They have been doing so many experiments that sometimes it gets hard to remember which variables have been tested in which experiment. This plot reminds him that this test consisted simply on 1 input variable with severals levels - the temperature and one continuous dependent variable - the number of cycles to failure. The plots shows clearly that the distributes are quite appart from each other in spite of the slight overlap between the first three groups. The underlying question is: are the different levels of temperature explaining the different results in resistance to fatigue? to confirm that means of those groups are statistically different from each other he knows he can use the analysis of variance. The name is a bit misleading since he want to compare means...but this name is historical and comes from the way the approach has evolved. The anova as it is called is similar to the t-test but is extended. Using all pair wise t-tests would mean more effort and increase the type I error.

The anova main principle is that the the total variability in the data, as measured by the total corrected sum of squares, can be partitioned into a sum of squares of the differences between the treatment averages and the grand average plus a sum of squares of the differences of observations within treatments from the treatment average. The first time he read this explanation it seemed complex but he understood better on seeing a simple hand made example on the [kahn academy - anova](https://www.youtube.com/watch?v=EFdlFoHI_0I).

### Anova {#aov}


```r
ebike_aov_factor <- aov(ebike_lm_factor)
summary(ebike_aov_factor)
```

```
            Df   Sum Sq  Mean Sq F value  Pr(>F)    
temperature  3 6.69e+10 2.23e+10    66.8 2.9e-09 ***
Residuals   16 5.34e+09 3.34e+08                    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

In R the anova is built by passing the linear model object to the `anova()` or `aov()` functions. The output of the first is just the anova table, the output of the second function is a complete list with the full lm model inside.

The R anova output gives the Mean Square for the factor and for the residuals. In this case the between-treatment mean square is much larger than the within-treatment or residuals mean square. This suggests that it is unlikely that the treatment means are equal. The p is extremely small thus we have basis to reject the null hypothesis and conclude that the means are significantly different. 
In the mean while the lab supervisor has gathered data on a similar experiment done with frams in another material for that seems to be less sensitive the the treatment temperation. He uploads this data and assigns it to a dataset called `ebike_hardning2` and plots another box plot.


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

<img src="7_effects_files/figure-html/unnamed-chunk-6-1.png" width="100%" />

Effectively within group variation is larger and groups overlap more. A new anova gives a p value of 0.34 supporting the assumption of no significant difference between the means of the treatment levels.


```r
ebike_lm_factor2 <- lm(cycles ~ temperature, data = ebike_factor2)
ebike_aov_factor2 <- aov(ebike_lm_factor2)
summary(ebike_aov_factor2)
```

```
            Df   Sum Sq  Mean Sq F value Pr(>F)
temperature  3 1.48e+09 4.92e+08     1.2   0.34
Residuals   16 6.55e+09 4.10e+08               
```

### Pairwise comparison {#tukey}


```r
ebike_tukey <- TukeyHSD(ebike_aov_factor, ordered = TRUE)
```


```r
head(ebike_tukey$temperature) %>% 
  kable(align = "c", 
        caption = "tukey test on e-bike frame hardening process", 
        booktabs = T)
```



Table: (\#tab:unnamed-chunk-9)tukey test on e-bike frame hardening process

|        |  diff  |   lwr    |  upr   |  p adj  |
|:-------|:------:|:--------:|:------:|:-------:|
|180-160 | 36200  |  3145.6  | 69254  | 0.02943 |
|200-160 | 74200  | 41145.6  | 107254 | 0.00005 |
|220-160 | 155800 | 122745.6 | 188854 | 0.00000 |
|200-180 | 38000  |  4945.6  | 71054  | 0.02160 |
|220-180 | 119600 | 86545.6  | 152654 | 0.00000 |
|220-200 | 81600  | 48545.6  | 114654 | 0.00001 |

Back to the main test the lab supervisor wants to see if all levels are significantly different from each other. As discusses the anova indicates that there is a difference in the treament means but it won't indicate which ones and doing individual t.tests has already been discarded. It is possible to get a direct one to one comparison of means with `TukeyHSD()` from `{stats}`. The test also provides a confidence interval for each difference. Most importantly it provides us with the p value to help us confirm the significance of the difference and conclude factor level by factor level which differences are significant. Additionally we can alo obtain the related plot with the confidence intervals 


```r
plot(ebike_tukey)
```

<img src="7_effects_files/figure-html/unnamed-chunk-10-1.png" width="100%" />

In the case of the frames thermal treatment all levels bring a specific impact on the lifecycle as we can see from the p values all below 0.05 and from the fact that no confidence interval crosses zero (there are no differences that could have a chance of being zero).

### Least significant difference {#fisherLSD}


```r
library(agricolae)
```


```r
ebike_LSD <- LSD.test(
  y = ebike_lm_factor,
  trt = "temperature"
)
```

A useful complement to Tukey's test is the calculation of Fisher's Least Significant differences. The Fisher procedure can be done in R with the `LSD.test()` from the `{agricolae}` package. The first important ouput is precisely the *least significant difference* which is the smallest the difference between means (of the the life cycles) that can be considered significant. This is indicated in the table below with the value LSD = 24'492.


```r
head(ebike_LSD$statistics) %>% 
  kable(align = "c", 
        caption = "Fisher LSD procedure on e-bike frame hardening: stats",
        booktabs = T)
```



Table: (\#tab:unnamed-chunk-13)Fisher LSD procedure on e-bike frame hardening: stats

|   |  MSerror  | Df |  Mean  |   CV   | t.value |  LSD  |
|:--|:---------:|:--:|:------:|:------:|:-------:|:-----:|
|   | 333700000 | 16 | 617750 | 2.9571 | 2.1199  | 24492 |

Furthermore it gives us a confidence intervals for each treatment level mean:


```r
head(ebike_LSD$means) %>% 
  select(-Q25, -Q50, -Q75) %>%
  kable(align = "c", 
        caption = "Fisher LSD procedure on e-bike frame hardening: means", 
        booktabs = T)
```



Table: (\#tab:unnamed-chunk-14)Fisher LSD procedure on e-bike frame hardening: means

|    | cycles |  std  | r |  LCL   |  UCL   |  Min   |  Max   |
|:---|:------:|:-----:|:-:|:------:|:------:|:------:|:------:|
|160 | 551200 | 20017 | 5 | 533882 | 568518 | 530000 | 575000 |
|180 | 587400 | 16742 | 5 | 570082 | 604718 | 565000 | 610000 |
|200 | 625400 | 20526 | 5 | 608082 | 642718 | 600000 | 651000 |
|220 | 707000 | 15248 | 5 | 689682 | 724318 | 685000 | 725000 |

We can see for example that for temperature 180 °C the lifecyle has an average of 587'400 (has he had calculated before) with a probability of 95% of being between 570'082 and and 604'718 cycles. Another useful outcome is the creation of groups of significance. 


```r
head(ebike_LSD$groups) %>% 
  kable(align = "c", 
        caption = "Fisher LSD procedure on e-bike frame hardening: groups", 
        booktabs = T)
```



Table: (\#tab:unnamed-chunk-15)Fisher LSD procedure on e-bike frame hardening: groups

|    | cycles | groups |
|:---|:------:|:------:|
|220 | 707000 |   a    |
|200 | 625400 |   b    |
|180 | 587400 |   c    |
|160 | 551200 |   d    |

In this case as all level means are statistically different they all show up in separate groups, each indicated by a specific letter. Finally we can use `plot()` which calls the method `plot.group()` from the same package. This allows us to provide as input the desired argument for the error bars.


```r
plot(
  ebike_LSD, 
  variation = "SE", 
  main = "e-bike hardening\nMeans comparison"
)
```

<img src="7_effects_files/figure-html/unnamed-chunk-16-1.png" width="100%" />

Strangly the package plot doesn't have the option to plot error bars with LSD and the lab supervisor decides to make a custom plot:


```r
ebike_factor %>%
  group_by(temperature) %>%
  summarise(cycles_mean = mean(cycles), 
            cycles_lsd = ebike_LSD$statistics$LSD) %>%
  ggplot(aes(x = temperature, y = cycles_mean, color = temperature)) +
  geom_point(size = 2) +
  geom_line() +
  geom_errorbar(aes(ymin = cycles_mean - cycles_lsd, 
                    ymax = cycles_mean + cycles_lsd),
                width = .1) +
  scale_y_continuous(n.breaks = 10, labels = label_number(big.mark = "'")) +
  scale_color_viridis_d(option = "C", begin = 0.1, end = 0.8) +
  annotate(geom = "text", x = Inf, y = -Inf, label = "Error bars are +/- 1xSD", 
    hjust = 1, vjust = -1, colour = "grey30", size = 3, 
    fontface = "italic") +
  labs(title = "e-bike frame hardening process",
       subtitle = "Boxplot of frame aging resistance",
       x = "Furnace Temperature [°C]",
       y = "Cycles to failure [n]")
```

<img src="7_effects_files/figure-html/unnamed-chunk-17-1.png" width="100%" />

The plot shows some overlap between the levels of 160 and 180 and again between 180 and 200. When looking a the Tukey test outcome we see that the p value of these differences is close to 0.05. Presenting all these statistical findings to the team they end up agreeing that in order to really improve the resistance they should consider a jump from 160 to 200°C in the thermal treatment.

As often with statistical tools, there is debate on the best approach to use. We recommend to combine the Tukey test with the Fisher's LSD. The Tukey test giving a first indication of the levels that have an effect and calculating the means differences and the Fisher function to provide much more additional information on each level. To be considered in each situation the slight difference  between the significance level for difference between means and to decide if required to take the most conservative one.

To go further in the Anova F-test we recommend this interesting article from @minitab_anovaftest.

## Interactions

<div class="marginnote">

<b class="highlight">Case study: solarcell output test</b>

<img src="img/solar_cell_test_bw.jpg" width="100%" style="display: block; margin: auto;" />

</div>

The countdown to leave fossil fuel has started as many companies have adopted firm timelines for 100% renewable energy sourcing. Solar energy is a great candidate but solar cell efficiency is a great challenge. Although it has been progressing steadily since more than four decades yields can still be considered low. A global manufacturing company of solar cells is looking to push the boundaries with a new generation of materials and grab another pie of the global market. 

### Model formulae {#formula}


```r
solarcell_formula <- formula(
  output ~ temperature * material
) 
```

In previous case studies input factors has been put directly in the arguments of the `lm()` function by using the inputs and outputs and relating them with the tilde ~ sign. The cases were simple with only one factor but in most DoEs we want to have many factors and decide which interactions to keep or drop. Here we're looking a bit more into detail in how to express this. When we pass an expression to the `formula()` function we generate an object of class formula and at that time some calculations are done in background to prepare the factors for the linear model calculation. Looking at the formula class and attributes we have:


```r
class(solarcell_formula)
```

```
[1] "formula"
```

```r
attributes(terms(solarcell_formula))$factors
```

```
            temperature material temperature:material
output                0        0                    0
temperature           1        0                    1
material              0        1                    1
```

We can see that the expression has been extended. Although we have only given as input the product of the factors we can see that an interaction term `temperature:material` has been generated. We also see the contrasts matrix associated. There is a specific syntax to specify the formula terms using *,+ and other symbols. As always it is good to consult the function documentation with `?formula`.

In the solar cell manufacturing company mentioned before the R&D team is working a new research project with the objective of understanding the output in [kWh/yr equivalent] of a new solar cell material at different ambient temperatures. Their latest experiment is recorded in an R dataset with the name `solarcell_output`:


```r
solarcell_output %>%
  head(5) %>%
  kable(align = "c")
```



|  material   | run | T-10 | T20 | T50 |
|:-----------:|:---:|:----:|:---:|:---:|
|  thinfilm   |  1  | 130  | 34  | 20  |
|  thinfilm   |  2  |  74  | 80  | 82  |
|  thinfilm   |  3  | 155  | 40  | 70  |
|  thinfilm   |  4  | 180  | 75  | 58  |
| christaline |  1  | 150  | 136 | 25  |

As often this data comes in a wide format and the first step we're doing is to convert it into a long format and to convert the variables to factors.


```r
solarcell_factor <- solarcell_output %>% 
  pivot_longer(
    cols = c("T-10", "T20", "T50"),
    names_to = "temperature",
    values_to = "output"
  ) %>% mutate(across(c(material, temperature), as_factor))
```

The experiment has consisted in measuring the output at three different temperature levels on three different materials. The associated linear model can be obtained with:


```r
solarcell_factor_lm <- lm(
  formula = solarcell_formula, 
  data = solarcell_factor
  )
summary(solarcell_factor_lm)
```

```

Call:
lm(formula = solarcell_formula, data = solarcell_factor)

Residuals:
   Min     1Q Median     3Q    Max 
-60.75 -14.63   1.38  17.94  45.25 

Coefficients:
                                     Estimate Std. Error t value Pr(>|t|)    
(Intercept)                            134.75      12.99   10.37  6.5e-11 ***
temperatureT20                         -77.50      18.37   -4.22  0.00025 ***
temperatureT50                         -77.25      18.37   -4.20  0.00026 ***
materialchristaline                     21.00      18.37    1.14  0.26311    
materialmultijunction                    9.25      18.37    0.50  0.61875    
temperatureT20:materialchristaline      41.50      25.98    1.60  0.12189    
temperatureT50:materialchristaline     -29.00      25.98   -1.12  0.27424    
temperatureT20:materialmultijunction    79.25      25.98    3.05  0.00508 ** 
temperatureT50:materialmultijunction    18.75      25.98    0.72  0.47676    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 26 on 27 degrees of freedom
Multiple R-squared:  0.765,	Adjusted R-squared:  0.696 
F-statistic:   11 on 8 and 27 DF,  p-value: 9.43e-07
```

We're going to go more in details now to validate the model and understand the effects and interactions of the different factors.

### Residuals standard error {#RSE}


```r
pluck(summary(solarcell_factor_lm), "sigma")
```

```
[1] 25.985
```

Besides the R-squared discussed previously in the linear models unit there is another useful indicator of the quality of the fit which is the Residuals Standard Error RSE. It provides the magnitude of a typical residuals. This value is also given directly as output of the model summary and is 26 in this case. Like the R-squared is better when we know how it is calculated and once we're at ease with manipulating the model data either with `{stats}` or `{broom}` it is possible to with a few steps check see how this is done.


```r
sqrt(sum(solarcell_factor_lm$residuals ^ 2) / df.residual(solarcell_factor_lm))
```

```
[1] 25.985
```

The exact value is 25.985 confirming the value extracted from the summary with the `pluck()` function from `{purrr}`.

### Residuals summary {#plot.lm}


```r
par(mfrow = c(2,3))
plot(solarcell_factor_lm$residuals)
plot(solarcell_factor_lm, which = 2)
plot(solarcell_factor_lm, which = c(1, 3, 5))
plot(solarcell_factor_lm, which = 4)
```

<img src="7_effects_files/figure-html/unnamed-chunk-26-1.png" width="100%" />

As the residuals analysis has been discussed in detail including custom made plots and statistical tests in the linear models unit, the assessment is done here in a summarized manner with a grouped output of all residuals plots. The qq plot presents good adherence to the center line indicating a normal distribution; the residuals versus fit presents a rather symmetrical distribution around zero indicating equality of variances at all levels and; the scale location plot though, shows a center line that is not horizontal which suggests the presence of outliers; in the Residuals versus fit we can effectively sense the Residuals Standard Error of 26.

### Interaction plot {#interaction.plot}


```r
interaction.plot(
  type = "b",
  col = viridis(12)[4],
  x.factor = solarcell_factor$temperature,
  trace.factor = solarcell_factor$material,
  fun = mean,
  response = solarcell_factor$output,
  trace.label = "Material",
  legend = TRUE,
  main = "Temperature-Material interaction plot",
  xlab = "temperature [°C]",
  ylab = "output [kWh/yr equivalent]"
)
```

<img src="7_effects_files/figure-html/unnamed-chunk-27-1.png" width="100%" />

In order to understand the behavior of the solar cell materials in the different temperature conditions the R&D team is looking for a plot that presents both factors simultaneous. Many different approaches are possible in R and here the team has selected the most basic one, the `interactionplot()` from the `{stats}` package.

Although simple several findings can already be extracted from this plot. They get the indication of the mean value of the solar cell output for the different materials at each temperature level. Also we see immediately that batteries tend to last longer at lower temperatures and this for all material types. We also see that there is certainly an interaction between material and temperature as the lines cross each other.

### Anova with interactions {#anova}


```r
anova(solarcell_factor_lm)
```

```
Analysis of Variance Table

Response: output
                     Df Sum Sq Mean Sq F value  Pr(>F)    
temperature           2  39119   19559   28.97 1.9e-07 ***
material              2  10684    5342    7.91   0.002 ** 
temperature:material  4   9614    2403    3.56   0.019 *  
Residuals            27  18231     675                    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Continuing the analysis started in the interaction plot the R&D team checks the anova output. Like in the lm summary output, the  stars in front of the p value of the different factors indicate that the effects are statistically different. Three stars for temperature corresponding to an extremely low p value indicating that the means of the output at the different levels of temperature are different. This confirms that temperature has an effect on output power. The material effect has a lower significance but is also clearly impacting cell power output. Finally it is confirmed that there is an interaction between temperature and material as the temperature:material term has a p value of 0.019 which is lower than the typical threshold of 0.05. Looking into the details interaction comes from the fact that increasing temperature from 10 to 20 decreases output for the thinfilm but is not yet impacting the output for multijunction film. For multijunction it is needed to increase even further the temperature to 50°C to see the decrease in the output. 

Before closing the first DOE analysis meeting the  R&D team discusses what would have been take-aways  if the interaction had not put in the model. As they use more and more R during their meetings and do the data analysis on the sport they simply create another model without the temperature:material term in the formula:


```r
solarcell_factor_lm_no_int <- lm(
  output ~ temperature + material, 
  data = solarcell_factor)
summary(solarcell_factor_lm_no_int)
```

```

Call:
lm(formula = output ~ temperature + material, data = solarcell_factor)

Residuals:
   Min     1Q Median     3Q    Max 
-54.39 -21.68   2.69  17.22  57.53 

Coefficients:
                      Estimate Std. Error t value Pr(>|t|)    
(Intercept)              122.5       11.2   10.97  3.4e-12 ***
temperatureT20           -37.2       12.2   -3.04   0.0047 ** 
temperatureT50           -80.7       12.2   -6.59  2.3e-07 ***
materialchristaline       25.2       12.2    2.06   0.0482 *  
materialmultijunction     41.9       12.2    3.43   0.0017 ** 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 30 on 31 degrees of freedom
Multiple R-squared:  0.641,	Adjusted R-squared:  0.595 
F-statistic: 13.9 on 4 and 31 DF,  p-value: 1.37e-06
```

Residual standard error is up from 26 to 30 which shows a poorer fit but R-square is only down from 76.5% to 64.1% which is still reasonably high. They apply the anova on this new model:


```r
anova(solarcell_factor_lm_no_int)
```

```
Analysis of Variance Table

Response: output
            Df Sum Sq Mean Sq F value  Pr(>F)    
temperature  2  39119   19559   21.78 1.2e-06 ***
material     2  10684    5342    5.95  0.0065 ** 
Residuals   31  27845     898                    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

The output still confirms the significance of the effects of the factors but the residuals analysis raises other concerns:


```r
par(mfrow = c(2,3))
plot(solarcell_factor_lm_no_int$residuals)
plot(solarcell_factor_lm_no_int, which = 2)
plot(solarcell_factor_lm_no_int, which = c(1, 3, 5))
plot(solarcell_factor_lm_no_int, which = 4)
```

<img src="7_effects_files/figure-html/unnamed-chunk-31-1.png" width="100%" />

They see in the Residuals vs Fitted a clear pattern with residuals moving from positive to negative and then again to positive along the fitted values axis which indicates that there is an interaction at play. Another concern comes from the Residuals versus Factor levels where at 10°C some residuals go beyond 2 standard deviations. The model with the interaction is clearly preferred in this case. 

## Covariance


```r
solarcell_fill %>% 
  head(5) %>%
  kable()
```



|material        | output| fillfactor|
|:---------------|------:|----------:|
|multijunction_A |    108|         20|
|multijunction_A |    123|         25|
|multijunction_A |    117|         24|
|multijunction_A |    126|         25|
|multijunction_A |    147|         32|

Solarcell experiments continue as the R&D project on new materials progresses. Any increase in the output, which is measured in [kWh/yr equivalent will bring a competitive advantage to the company. The previous meeting outcome made the R&D team select the multijunction material as the best candidate for the next round of tests. A new experiment has been designed but the team needs to go deeper in the understanding on how to improve the power output. Besides temperature and material there seems to be another variable at play: the fill factor. This seems to be a complex technical topic but all experts agree that this is influencing the behavior of the cell. The fill factor depends on the electrical circuit configuration and the output seems to be correlated with it. Until now the team has not been able to control the fill factor. The table just presented shows the value of fill factor collected for each cell tested together with the measured output.

A Data Scientist from the center recommends to use an analysis of covariance (ancova) which can be useful in situations where a continuous variable may be influencing the measured value. He calls this a covariate. In such specific case this approach provides better results than the analysis of variance (anova) allowing for a more accurate assessment of the effects of the categorical variable. In this case it can remove the effect of the fill factor in the output when we want to compare the different materials. It is nevetheless important to ensure the basic assumption that the continuous variable is independent from the factor to be analyses, in this case that the material is not influencing the fill factor. A good explanation and a similar case (without R) can be seen on page 655 of @Montgomery2012.



```r
solarcell_fill %>%
  ggplot(aes(x = fillfactor, y = output)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  theme_industRial() +
  labs(
    title = "The solarcell output test",
    subtitle = "Output vs Fill Factor",
    x = "Fill factor [%]",
    y = "Output"
  )
```

<img src="7_effects_files/figure-html/unnamed-chunk-33-1.png" width="100%" />

### Correlation test {#cor.test}


```r
cor.test(
  solarcell_fill$output, solarcell_fill$fillfactor,
  method = "pearson"
  )
```

```

	Pearson's product-moment correlation

data:  solarcell_fill$output and solarcell_fill$fillfactor
t = 9.8, df = 13, p-value = 2.3e-07
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.82100 0.97976
sample estimates:
    cor 
0.93854 
```

The next step is to confirm the correlation between the continuous input variable and the output and the `cor.test()` from the `{stats}` package is perfectly suited for this. The extremely high value of 93% confirms what was very visible in the scatterplot. Going further and using the approach from [@Broc2016] we're going to facet the scatterplots to assess if the coefficient of the linear regression is similar for all the levels of the fillfactor:


```r
solarcell_fill %>%
  ggplot(aes(x = fillfactor, y = output)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(vars(material)) +
  theme_industRial() +
  labs(
    title = "The solarcell output test",
    subtitle = "Output vs Fill Factor, by material type",
    x = "Fill factor [%]",
    y = "Output"
  )
```

<img src="7_effects_files/figure-html/unnamed-chunk-35-1.png" width="100%" />

The linear regression plots split by material show that from one material to the other the relationship between output and fillfactor is equivalent. Not only increasing fill factor increase output the degree to which this takes place is similar as we can see by the slopes of the plot. Care needs to be taken because the  number of points is very small. If required it is always possible to do individual correlation test and/or do a statistical test between slopes. Now things are ready to the ancova itself.

### Ancova {#ancova_aov}


```r
solarcell_ancova <- aov(
  formula = output ~ fillfactor + material, 
  data = solarcell_fill
  )
solarcell_aov <- aov(
  output ~ material, 
  data = solarcell_fill
  )
```

Although the team had been using R often the case of the ancova had not yet came up so it was up to the Data Scientist to do this analysis. In R the ancova can be done with the same function as the anova, the `aov()` function from `{stats}` but there's a specific way to establish the formula which he has obtained from [Datanovia - Ancova](https://www.datanovia.com/en/lessons/ancova-in-r/): the covariate is the first input and there must be interaction between the two inputs, thus the plus sign only. As with contrasts, any little mistake in the syntax may produce very different results so it requires great care and often confirmation of calculation with an existing well know case. 


```r
summary(solarcell_ancova)
```

```
            Df Sum Sq Mean Sq F value Pr(>F)    
fillfactor   1   2746    2746  119.93  3e-07 ***
material     2    120      60    2.61   0.12    
Residuals   11    252      23                   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
summary(solarcell_aov)
```

```
            Df Sum Sq Mean Sq F value Pr(>F)  
material     2   1264     632    4.09  0.044 *
Residuals   12   1854     155                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

The `aov()` summary output looks exactly the same for both analysis but the in the first output corresponding to the ancova the material mean square has been adjusted for regression and is smaller. It is also noticeable that the residuals are smaller in the ancova which confirm that the approach has helped reducing the error variability.

Finaly the most important observation is that the conclusions would have been just the opposite if the Data Scientist had not recommended the ancova. In fact in the anova would have shown that the material influences the output while when removing the influence of the fill factor the ancova ends up showing that there is no influence. This is visible in the p value which is above 0.05 in the ancova and below 0.05 in the anova.

As next steps the R&D team decides to tackle this fill factor issue and get it into control. Reducing fill factor variability within each material will certainly reduce the variability in the power output. I would also make upcoming experiments simpler and more easily comparable.











