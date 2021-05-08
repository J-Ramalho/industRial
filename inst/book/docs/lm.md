

## One factor multiple levels

### Linear regression

We will present here a first example of the utilisation of linear regression techniques and establish a linear model. These models are going to be used extensively in the upcoming cases.

**Plasma etching example**

**Data loading**


```r
library(tidyverse)
library(janitor)
library(stats)
filter <- dplyr::filter
select <- dplyr::select
```


```r
# Direct copy of the example from the book:
plasma <- read_csv("data/3-1_plasma_etching.csv") %>%
  clean_names()

plasma_narrow <- plasma %>%
  pivot_longer(
    cols = starts_with("x"),
    names_to = "observation",
    values_to = "etch_rate"
  )
```

**Raw data plot**
 

```r
ggplot(plasma_narrow, aes(x = power, y = etch_rate)) +
  geom_point() +
  theme_light() +
  theme(legend.position = "none") +
  labs(title = "Plasma case study",
       subtitle = "Raw data plot",
       x = "Power",
       y = "Etch rate")
```

<img src="lm_files/figure-html/unnamed-chunk-4-1.png" width="80%" />

#### Linear model function {#linearModel}

Here we're constructing a linear model of the raw data and not a model of the Anova, thus *power* has to be as integer and not as a factor, unlike in the Anova model.


```r
library(stats)
```


```r
plasma_lm <- lm(etch_rate ~ power, data = plasma_narrow)
summary(plasma_lm)
```

```
## 
## Call:
## lm(formula = etch_rate ~ power, data = plasma_narrow)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -43.02 -12.32  -1.21  16.71  33.06 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 137.6200    41.2108   3.339  0.00365 ** 
## power         2.5270     0.2154  11.731 7.26e-10 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 21.54 on 18 degrees of freedom
## Multiple R-squared:  0.8843,	Adjusted R-squared:  0.8779 
## F-statistic: 137.6 on 1 and 18 DF,  p-value: 7.263e-10
```

#### Linear model plot


```r
ggplot(plasma_narrow, aes(x = power, y = etch_rate)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  theme_light() +
  theme(legend.position = "none") +
  labs(title = "Plasma case study",
       subtitle = "Raw data plot",
       x = "Power",
       y = "Etch rate")
```

<img src="lm_files/figure-html/unnamed-chunk-7-1.png" width="80%" />

#### Linear model fixed effects


```r
plasma_narrow_factor <- plasma_narrow %>%
  mutate(power = as_factor(power),
         observation = as_factor(observation))
plasma_lm_factor <- lm(etch_rate ~ power, data = plasma_narrow_factor)
summary(plasma_lm_factor)
```

```
## 
## Call:
## lm(formula = etch_rate ~ power, data = plasma_narrow_factor)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -25.4  -13.0    2.8   13.2   25.6 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  551.200      8.169  67.471  < 2e-16 ***
## power180      36.200     11.553   3.133  0.00642 ** 
## power200      74.200     11.553   6.422 8.44e-06 ***
## power220     155.800     11.553  13.485 3.73e-10 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 18.27 on 16 degrees of freedom
## Multiple R-squared:  0.9261,	Adjusted R-squared:  0.9122 
## F-statistic:  66.8 on 3 and 16 DF,  p-value: 2.883e-09
```

### Model check

#### R squared 

R² the coefficient of determination

The R square can be extracted from the linear model that has been used to build the Anova model.


```r
summary(plasma_lm_factor)$r.squared
```

```
## [1] 0.9260598
```

Thus, in the plasma etching experiment, the factor “power” explains about 88% percent of the variability in etch rate.

Anova fixed effects assumes that:
- errors are normally distributed and are independent

As the number of residuals is too small we're not checking the normality via the histogram but rather with a a Q-Q plot.

#### Residuals analysis

Residuals time sequence

Such plot needs that the order of data collection is available in the dataframe. In the example below this is the case as the residuals from the model are sequenced as they appear in the *plasma* dataframe.

A tendency to have runs of positive of negative results indicates that the independency assumption does not hold.


```r
plot(plasma_lm_factor$residuals)
```

<img src="lm_files/figure-html/unnamed-chunk-10-1.png" width="80%" />


```r
par(mfrow = c(2,2))
plot(plasma_lm_factor)
```

<img src="lm_files/figure-html/unnamed-chunk-11-1.png" width="80%" />

Residuals vs fit : 

If the model is correct and the assumptions hold, the residuals should be structureless. This plot should not reveal any obvious pattern.

A second graph shows that the standardised residuals are normally distributed.
This specific Standardized residuals graph also help detecting outliers in the residuals (any residual > 3 standard deviations is a potential outlier).

The plot suggests normal distribution. The verification can be completed by a test. For populations < 50 use the shapiro-wilk normality test.

#### Shapiro test {#shapiroTest}


```r
shapiro.test(plasma_lm_factor$residuals)
```

```
## 
## 	Shapiro-Wilk normality test
## 
## data:  plasma_lm_factor$residuals
## W = 0.93752, p-value = 0.2152
```

p > 0.05 indicates that the residuals do not differ significantly from a normally distributed population.

### Prediction {#predict}

Here we're using the model with power as an integer:


```r
power_new <- data.frame(power = c(170, 190))
predict(plasma_lm, newdata = power_new)
```

```
##      1      2 
## 567.21 617.75
```
