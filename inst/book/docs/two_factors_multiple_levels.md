


```r
library(tidyverse)
library(readxl)
library(stats)
filter <- dplyr::filter
select <- dplyr::select
```

## Two factors multiple levels

Battery life example

Load and prepare data for analysis:


```r
battery <- read.csv(sep = ";", header = TRUE, "../industRial/data-raw/5_battery.csv")

battery_narrow <- gather(battery,
                         temperature,
                         life,
                         T15, T70, T125)

battery_narrow_factor <- battery_narrow
battery_narrow_factor$material <- as.factor(battery_narrow$material)
battery_narrow_factor$temperature <- ordered(battery_narrow$temperature,
                                            levels = c("T15", "T70", "T125"))
```

### lm with interactions


```r
battery_lm_factor <- lm(
  life ~ temperature + material + temperature:material, 
  data = battery_narrow_factor
  )
summary(battery_lm_factor)
```

```

Call:
lm(formula = life ~ temperature + material + temperature:material, 
    data = battery_narrow_factor)

Residuals:
    Min      1Q  Median      3Q     Max 
-60.750 -14.625   1.375  17.937  45.250 

Coefficients:
                        Estimate Std. Error t value Pr(>|t|)    
(Intercept)               83.167      7.501  11.087 1.48e-11 ***
temperature.L            -54.624     12.992  -4.204 0.000257 ***
temperature.Q             31.741     12.992   2.443 0.021385 *  
material2                 25.167     10.608   2.372 0.025059 *  
material3                 41.917     10.608   3.951 0.000503 ***
temperature.L:material2  -20.506     18.374  -1.116 0.274242    
temperature.Q:material2  -45.724     18.374  -2.488 0.019293 *  
temperature.L:material3   13.258     18.374   0.722 0.476759    
temperature.Q:material3  -57.053     18.374  -3.105 0.004434 ** 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 25.98 on 27 degrees of freedom
Multiple R-squared:  0.7652,	Adjusted R-squared:  0.6956 
F-statistic:    11 on 8 and 27 DF,  p-value: 9.426e-07
```

Looking at the output we see that R-squared is equal to 0.7652. This means about 77 percent of the variability in the battery life is explained by the plate material in the battery, the temperature, and the material type–temperature interaction. We're going to go more in details now to validate the model and understand the effects and interactions of the different factors.

### Outliers and model check

We start by an assessment of the residuals, starting by the timeseries of residuals:


```r
plot(battery_lm_factor$residuals)
```

<img src="two_factors_multiple_levels_files/figure-html/unnamed-chunk-5-1.png" width="672" />

No specific pattern is apparent so now we check all the remaining plots grouped into one single output:


```r
par(mfrow = c(2,2))
plot(battery_lm_factor)
```

<img src="two_factors_multiple_levels_files/figure-html/unnamed-chunk-6-1.png" width="672" />

Residuals versus fit presents a rather simetrical distribution around zero indicating equality of variances at all levels and the qq plot presents good adherence to the centel line indicating a normal distributed population of residuals, all ok for these. The scale location plot though, shows a center line that is not horizontal which suggest the presence of outliers.

We can extract the absolute maximum residual with:


```r
battery_lm_factor$residuals %>% abs() %>% max()
```

```
[1] 60.75
```

Inspecting again the residuals plots we see that this corresponds to the point labeled with 2 for which the standardized value is greater than 2 standard deviations. 

We're therefore apply the outlier test from the car package:


```r
library(car)
```


```r
outlierTest(battery_lm_factor)
```

```
No Studentized residuals with Bonferroni p < 0.05
Largest |rstudent|:
   rstudent unadjusted p-value Bonferroni p
2 -3.100368          0.0046065      0.16583
```

which gives a high Bonferroni p value thus excluding this possibility.

### Interaction plot {#interactionPlot}

In this experiement instead of just plotting a linear regression we need to go for a more elaborate plot that shows the response as a function of the two factors. Many different approaches are possible in R and here we're starting with a rather simple one - the interaction plot from the stats package:


```r
interaction.plot(x.factor = battery_narrow_factor$temperature, 
                 trace.factor = battery_narrow_factor$material,
                 fun = mean,
                 response = battery_narrow_factor$life,
                 trace.label = "Material",
                 legend = TRUE,
                 main = "Temperature-Material interaction plot",
                 xlab = "temperature [°C]",
                 ylab = "life [h]")
```

<img src="two_factors_multiple_levels_files/figure-html/unnamed-chunk-10-1.png" width="672" />

Although simple many important learnings can be extracted from this plot. We get the indication of the mean value of battery life for the different data groups at each temperature level for each material. Also we see immediatly that batteries tend to have longer lifes at lower temperature for all material types. We also see that there is certainly an interaction between material and temperature as the lines cross each other.

### Effects significance

As the R-squared was rather high and there were no issues with residuals we considere the model as acceptable and move ahead with the assessment of the significance of the different effects. For that we apply the anova to the linear model:


```r
battery_aov <- aov(battery_lm_factor)
summary(battery_aov)
```

```
                     Df Sum Sq Mean Sq F value   Pr(>F)    
temperature           2  39119   19559  28.968 1.91e-07 ***
material              2  10684    5342   7.911  0.00198 ** 
temperature:material  4   9614    2403   3.560  0.01861 *  
Residuals            27  18231     675                     
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

We see in the output little stars in front of the p value of the different factors. Three stars for temperature corresponding to an extremely low p value indicating that the means of the lifetime at different levels of temperature are significantly different, confirming that temperature has an effect on lifetime. With a lower significance but still clearly impacting lifetime depends on the material. Finally it is confirmed that there is an interaction between both factors has the temperature:material term has a p value of 0.01861 which us lower than the treshold of 0.05.

The interaction here corresponds to the fact that increasing temperature from 15 to 70 decreases lifetime for material 2 but increases for material 3.

### Removing interaction

Its interesting to consider what would have been the analysis if the interaction was not put in the model. We can easily assess that by creating a new model in R without the temperature:material term.


```r
battery_lm_factor_no_int <- 
  lm(life ~ temperature + material, data = battery_narrow_factor)
summary(battery_lm_factor_no_int)
```

```

Call:
lm(formula = life ~ temperature + material, data = battery_narrow_factor)

Residuals:
    Min      1Q  Median      3Q     Max 
-54.389 -21.681   2.694  17.215  57.528 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)     83.167      8.652   9.613 8.16e-11 ***
temperature.L  -57.040      8.652  -6.593 2.30e-07 ***
temperature.Q   -2.518      8.652  -0.291  0.77300    
material2       25.167     12.235   2.057  0.04819 *  
material3       41.917     12.235   3.426  0.00175 ** 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 29.97 on 31 degrees of freedom
Multiple R-squared:  0.6414,	Adjusted R-squared:  0.5951 
F-statistic: 13.86 on 4 and 31 DF,  p-value: 1.367e-06
```

The model still presents a reasonably high R-square of 0.64. We now apply the anova on this new model:


```r
battery_aov_no_int <- aov(battery_lm_factor_no_int)
summary(battery_aov_no_int)
```

```
            Df Sum Sq Mean Sq F value   Pr(>F)    
temperature  2  39119   19559  21.776 1.24e-06 ***
material     2  10684    5342   5.947  0.00651 ** 
Residuals   31  27845     898                     
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

The output naturally confirms the significance of the effects of the factors, however, as soon as a residual analysis is performed for these data, it becomes clear that the non-interaction model is inadequate:


```r
par(mfrow = c(2,2))
plot(battery_lm_factor_no_int)
```

<img src="two_factors_multiple_levels_files/figure-html/unnamed-chunk-14-1.png" width="672" />

We see in the Residuals vs Fitted a clear pattern with residuals moving from positive to negative and then again to positive along the fitted values axis which indicates that there is an interaction at play.


