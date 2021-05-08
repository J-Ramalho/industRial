


```r
library(tidyverse)
library(readxl)
library(stats)
library(broom)
library(industRial)
library(patchwork)
filter <- dplyr::filter
select <- dplyr::select
```

## 3F-nL designs

Designs with 3 factors and above with multiple levels.

Soft Drink bottling example


```r
bottling <- read.csv(sep = ";", header = TRUE, 
                     "../industRial/data-raw/5_bottling.csv")

bottling_factor <- bottling %>%
  mutate(across(c(speed, carbonation, pressure, replicate), as_factor))

bottling_factor <- bottling_factor %>%
  group_by(carbonation) %>%
  mutate(fill_m_carb = mean(fill, na.rm = TRUE)) %>%
  ungroup() %>%
  group_by(pressure) %>%
  mutate(fill_m_press = mean(fill, na.rm = TRUE)) %>%
  ungroup() %>%
  group_by(speed) %>%
  mutate(fill_m_speed = mean(fill, na.rm = TRUE)) 
```

### Main effects plots

As the number of factors and levels of a design increase, more thinking is required to obtain good visualisation of the data. 

Main effects plots consist usually of a scatterplot representing the experiment output as a function of one of the inputs. In a design like this with three different inputs three plots are required:


```r
carbonation_plot <- bottling %>%  
  group_by(carbonation) %>%
  summarise(carbonation_fill_mean = mean(fill)) %>%
  ggplot(aes(x = carbonation, y = carbonation_fill_mean)) +
  geom_point() +
  geom_line() +
  coord_cartesian(
    xlim = c(9,15),
    ylim = c(-2,10), expand = TRUE) +
  labs(
    title = "Soft-Drink bottling problem",
    subtitle = "Main effects plots",
    x = "Carbonation [%]",
    y = "Average fill deviation [g]"
  ) +
  theme_industRial()

pressure_plot <- bottling %>%  
  group_by(pressure) %>%
  summarise(pressure_fill_mean = mean(fill)) %>%
  ggplot(aes(x = pressure, y = pressure_fill_mean)) +
  geom_point() +
  geom_line() +
  coord_cartesian(
    xlim = c(24,31), 
    ylim = c(-2,10), expand = TRUE) +
  labs(
    x = "Pressure",
    y = "Average fill deviation [g]"
  ) +
  theme_industRial()

speed_plot <- bottling %>%  
  group_by(speed) %>%
  summarise(speed_fill_mean = mean(fill)) %>%
  ggplot(aes(x = speed, y = speed_fill_mean)) +
  geom_point() +
  geom_line() +
  coord_cartesian(
    xlim = c(190, 260),
    ylim = c(-2,10), expand = TRUE) +
  labs(
    x = "Speed",
    y = "Average fill deviation [g]"
  ) +
  theme_industRial()

carbonation_plot + pressure_plot + speed_plot
```

<img src="doe_3F-nL_files/figure-html/unnamed-chunk-4-1.png" width="672" />

This kind of plots gives already important insights in to the experiement outcome, even before any deeper analysis with a linear model and anova. In our case:

* higher pressure and higher speed result in higher fill weight deviation
* beyond 10.5% carbonation level the fill weight is always higher than the target

### Interactions plots

In designs like these with 3 factors we have 3 possible interactions (A-B, A-C, B-C) corresponding the the possible combination between them. This results in three interaction plots that we're presenting below. The approach here goes beyond the interaction.plot function from the `{stats}` package presented previously in the two factors multiple levels case. We are developping here the plots with {ggplot2} which provides much more control on the plot attibutes but on the other hand requires that additional code is added to calculate the means by group.


```r
carbonation_pressure_plot <- bottling %>%  
  group_by(carbonation, pressure) %>%
  summarise(carbonation_fill_mean = mean(fill)) %>%
  ggplot(aes(x = carbonation, y = carbonation_fill_mean)) +
  geom_point(aes(group = pressure)) +
  geom_line(aes(group = pressure, linetype = as_factor(pressure))) +
  scale_linetype(name = "Pressure") +
  coord_cartesian(
    xlim = c(9,15),
    ylim = c(-2,10), expand = TRUE) +
  labs(
    title = "Soft-Drink bottling problem",
    subtitle = "Interaction plots",
    x = "Carbonation",
    y = "Average fill deviation [g]"
  ) +
  theme_industRial() +
  theme(legend.justification=c(1,0), legend.position=c(1,0))

carbonation_speed_plot <- bottling %>%  
  group_by(carbonation, speed) %>%
  summarise(carbonation_fill_mean = mean(fill)) %>%
  ggplot(aes(x = carbonation, y = carbonation_fill_mean)) +
  geom_point(aes(group = speed)) +
  geom_line(aes(group = speed, linetype = as_factor(speed))) +
  scale_linetype(name = "Speed") +
  coord_cartesian(
    xlim = c(9, 15),
    ylim = c(-2,10), expand = TRUE) +
  labs(
    x = "Carbonation",
    y = "Average fill deviation [g]"
  ) +
  theme_industRial() +
  theme(legend.justification=c(1,0), legend.position=c(1,0))

speed_pressure_plot <- bottling %>%  
  group_by(speed, pressure) %>%
  summarise(speed_fill_mean = mean(fill)) %>%
  ggplot(aes(x = speed, y = speed_fill_mean)) +
  geom_point(aes(group = pressure)) +
  geom_line(aes(group = pressure, linetype = as_factor(pressure))) +
  scale_linetype(name = "Pressure") +
  coord_cartesian(
    xlim = c(190, 260),
    ylim = c(-2,10), expand = TRUE) +
  labs(
    x = "Speed",
    y = "Average fill deviation [g]"
  ) +
  theme_industRial() +
  theme(legend.justification=c(1,0), legend.position=c(1,0))

carbonation_pressure_plot + carbonation_speed_plot + speed_pressure_plot
```

<img src="doe_3F-nL_files/figure-html/unnamed-chunk-5-1.png" width="672" />

The plots indicate no interaction between the different factors as all lines do not intercept and are mostly parallel.

In most cases the anova would be performed first and only the plot for the significant interactions would be plotted, if any.

### Model with 3rd level interactions

The sources of variation for the Anova table for three-factor fixed effects model are: A, B, C, AB, AC, BC, ABC. To be noted that like in the two-factors we must have at least two replicates (n>2) to determine the sum of squares due to error if all possible interactions are to be included in the model.


```r
bottling_lm_factor <- lm(fill ~ 
                           carbonation + speed + pressure + 
                           carbonation:speed + 
                           carbonation:pressure + 
                           speed:pressure + 
                           carbonation:speed:pressure,
                           data = bottling_factor
  )
summary(bottling_lm_factor)
```

```

Call:
lm(formula = fill ~ carbonation + speed + pressure + carbonation:speed + 
    carbonation:pressure + speed:pressure + carbonation:speed:pressure, 
    data = bottling_factor)

Residuals:
   Min     1Q Median     3Q    Max 
  -1.0   -0.5    0.0    0.5    1.0 

Coefficients:
                                    Estimate Std. Error t value Pr(>|t|)    
(Intercept)                       -2.000e+00  5.951e-01  -3.361  0.00567 ** 
carbonation12                      2.500e+00  8.416e-01   2.970  0.01169 *  
carbonation14                      6.500e+00  8.416e-01   7.723 5.38e-06 ***
speed250                           1.500e+00  8.416e-01   1.782  0.10000    
pressure30                         1.500e+00  8.416e-01   1.782  0.10000    
carbonation12:speed250            -5.000e-01  1.190e+00  -0.420  0.68185    
carbonation14:speed250             5.000e-01  1.190e+00   0.420  0.68185    
carbonation12:pressure30           5.000e-01  1.190e+00   0.420  0.68185    
carbonation14:pressure30           2.000e+00  1.190e+00   1.680  0.11871    
speed250:pressure30                5.439e-16  1.190e+00   0.000  1.00000    
carbonation12:speed250:pressure30  2.000e+00  1.683e+00   1.188  0.25775    
carbonation14:speed250:pressure30  5.000e-01  1.683e+00   0.297  0.77151    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.8416 on 12 degrees of freedom
Multiple R-squared:  0.9747,	Adjusted R-squared:  0.9516 
F-statistic: 42.11 on 11 and 12 DF,  p-value: 7.417e-08
```

### Anova with 3rd level interactions

We are now fully prepared for an assessment of the effect of the different factors with the anova:


```r
bottling_aov_factor <- aov(bottling_lm_factor)
summary(bottling_aov_factor)
```

```
                           Df Sum Sq Mean Sq F value   Pr(>F)    
carbonation                 2 252.75  126.38 178.412 1.19e-09 ***
speed                       1  22.04   22.04  31.118  0.00012 ***
pressure                    1  45.38   45.38  64.059 3.74e-06 ***
carbonation:speed           2   0.58    0.29   0.412  0.67149    
carbonation:pressure        2   5.25    2.62   3.706  0.05581 .  
speed:pressure              1   1.04    1.04   1.471  0.24859    
carbonation:speed:pressure  2   1.08    0.54   0.765  0.48687    
Residuals                  12   8.50    0.71                     
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

The observations of the plots are confirmed and completed with statistical input: we see that the percentage of carbonation, operating pressure, and line speed significantly affect the fill volume (p < 0.05). The carbonation-pressure interaction has a P-value of 0.0558, indicating very low interaction between these factors.
