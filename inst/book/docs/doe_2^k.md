

## 2^2 factorial design



The $2^{k}$ designs are particularly useful in the early stages of experimental work when many factors are likely to be investigated. It provides the smallest number of runs with which k factors can be studied in a complete factorial design. Consequently, these designs are widely used in factor screening experiments.

The validity of the analysis depends on the following assumptions:

* the factors are fixed
* the designs are completely randomized
* the usual normality assumptions are satisfied
* the response is approximately linear over the range of the factor levels chosen

Analysis Procedure for a 2 k Design

1. Estimate factor effects
2. Form initial model (full model)
  a. If the design is replicated, fit the full model
  b. If there is no replication, form the model using a normal probability plot of the effects
3. Perform statistical testing (Anova)
4. Refine model (remove non significant effects)
5. Analyze residuals
6. Interpret results

DEF - Sparsity of effects principle: most systems are dominated by some of the main effects and low-order interactions, and most high-order interactions are negligible.

In this first Case Study dedicated to $2^k$ designs we're going to explore the contrasts settings in the linear model functions.

**The Chemical Process**

In this case study factors have only 2 levels. 


```r
library(tidyverse)
library(readxl)
library(stats)
library(broom)
library(industRial)
library(knitr)
filter <- dplyr::filter
select <- dplyr::select
```

Below we start by loading our dataset:


```r
chm <- read.csv(sep = ";", header = TRUE, "../industRial/data-raw/6_chemical.csv")
```

### Factors as +/-

In this first model we're using a design where the inputs levels have been defined as plus and minus, sometimes also called high and low. The actual naming is not important, what is critical is to ensure that those input parameters are coded as factors. This is necessary as we will see to obtain the right coefficients in the linear model.


```r
chmn_fct <- chm %>%
  gather(replicate, yield, I, II, III) %>%
  mutate(across(c(A,B), as_factor))

chmn_ctr_lm <- lm(
  formula = yield ~ A * B, 
  data = chmn_fct,
  contrasts = list(A = "contr.sum", B = "contr.sum")
  )
chmn_ctr_aov <- aov(chmn_ctr_lm)

summary(chmn_ctr_lm)
```

```

Call:
lm(formula = yield ~ A * B, data = chmn_fct, contrasts = list(A = "contr.sum", 
    B = "contr.sum"))

Residuals:
   Min     1Q Median     3Q    Max 
-2.000 -1.333 -0.500  1.083  3.000 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  27.5000     0.5713  48.135 3.84e-11 ***
A1           -4.1667     0.5713  -7.293 8.44e-05 ***
B1            2.5000     0.5713   4.376  0.00236 ** 
A1:B1         0.8333     0.5713   1.459  0.18278    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 1.979 on 8 degrees of freedom
Multiple R-squared:  0.903,	Adjusted R-squared:  0.8666 
F-statistic: 24.82 on 3 and 8 DF,  p-value: 0.0002093
```

```r
summary(chmn_ctr_aov)
```

```
            Df Sum Sq Mean Sq F value   Pr(>F)    
A            1 208.33  208.33  53.191 8.44e-05 ***
B            1  75.00   75.00  19.149  0.00236 ** 
A:B          1   8.33    8.33   2.128  0.18278    
Residuals    8  31.33    3.92                     
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
predict(chmn_ctr_lm, newdata = list(A = "+", B = "+"))
```

```
 1 
30 
```

We can observe in the output that the p value of the effects is the same in the lm and in the the aov functions. This shows that the contrasts have been correctly specified with contr.sum 

Note that contr.sum applies to cases where the sum of the contrasts is zero while the R default is contr.treatment which applies to cases where the levels are coded as 0 and 1.

### Factors as +/- 1 

In this example we convert the levels to factors still using the +/-1 notation. This will also be helpfull to apply what are called the Yates tables.


```r
coded <- function(x) { ifelse(x == x[1], -1, 1) }
chmn_fct <- chmn_fct %>% mutate(cA = coded(A), cB = coded(B))
chmn_fct2 <- chmn_fct %>%
  mutate(across(c(cA, cB), as_factor))

chmn_ctr2_lm <- lm(
  formula = yield ~ cA * cB, 
  data = chmn_fct2,
  contrasts = list(cA = "contr.sum", cB = "contr.sum")
  )
chmn_ctr2_aov <- aov(chmn_ctr2_lm)

summary(chmn_ctr2_lm)
```

```

Call:
lm(formula = yield ~ cA * cB, data = chmn_fct2, contrasts = list(cA = "contr.sum", 
    cB = "contr.sum"))

Residuals:
   Min     1Q Median     3Q    Max 
-2.000 -1.333 -0.500  1.083  3.000 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  27.5000     0.5713  48.135 3.84e-11 ***
cA1          -4.1667     0.5713  -7.293 8.44e-05 ***
cB1           2.5000     0.5713   4.376  0.00236 ** 
cA1:cB1       0.8333     0.5713   1.459  0.18278    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 1.979 on 8 degrees of freedom
Multiple R-squared:  0.903,	Adjusted R-squared:  0.8666 
F-statistic: 24.82 on 3 and 8 DF,  p-value: 0.0002093
```

```r
summary(chmn_ctr2_aov)
```

```
            Df Sum Sq Mean Sq F value   Pr(>F)    
cA           1 208.33  208.33  53.191 8.44e-05 ***
cB           1  75.00   75.00  19.149  0.00236 ** 
cA:cB        1   8.33    8.33   2.128  0.18278    
Residuals    8  31.33    3.92                     
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
predict(chmn_ctr2_lm, newdata = list(cA = "1", cB = "1"))
```

```
 1 
30 
```

Note that a coefficient in a regression equation is the change in the response when the corresponding variable changes by +1. Here cA1 corresponds to the lower level of A corresponding to -1 while in the model with numeric coding it was +1. Special attention to the + and - needs to be taken with the R output. In the prediction function anyway we enter the correct sign.

As A or B changes from its low level to its high level, the coded variable changes by 1 − (−1) = +2, so the change in the response is twice the regression coefficient.

So the effects and interaction(s) are twice the values in the “Estimate” column.
These regression coefficients are often called effects and interactions, even though they differ from the definitions used in the designs themeselves.

### Factors as +/- 1 numeric

In this second example we're going to code the levels with +1/-1 but we're going to start by leaving them as numeric.


```r
chmn_num <- chmn_fct %>% mutate(cA = coded(A), cB = coded(B))
chmn_num_lm <- lm(
  formula = yield ~ cA * cB, 
  data = chmn_num
  )
chmn_num_aov <- aov(chmn_num_lm)

summary(chmn_num_lm)
```

```

Call:
lm(formula = yield ~ cA * cB, data = chmn_num)

Residuals:
   Min     1Q Median     3Q    Max 
-2.000 -1.333 -0.500  1.083  3.000 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  27.5000     0.5713  48.135 3.84e-11 ***
cA            4.1667     0.5713   7.293 8.44e-05 ***
cB           -2.5000     0.5713  -4.376  0.00236 ** 
cA:cB         0.8333     0.5713   1.459  0.18278    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 1.979 on 8 degrees of freedom
Multiple R-squared:  0.903,	Adjusted R-squared:  0.8666 
F-statistic: 24.82 on 3 and 8 DF,  p-value: 0.0002093
```

```r
summary(chmn_num_aov)
```

```
            Df Sum Sq Mean Sq F value   Pr(>F)    
cA           1 208.33  208.33  53.191 8.44e-05 ***
cB           1  75.00   75.00  19.149  0.00236 ** 
cA:cB        1   8.33    8.33   2.128  0.18278    
Residuals    8  31.33    3.92                     
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
predict(chmn_num_lm, newdata = list(cA = 1, cB = 1))
```

```
 1 
30 
```

In this case we did not define any contrasts. Looking into the lm We can see we've obtained exactly the same outputs.

As the inputs are coded as numeric this behaves just like the first simple linear model we've seen in the Case Study on One Factor with Multiple levels. In particular when we feed the predictions function with numeric values.

This is very intuitive as it corresponds to the original units of the experiments (also called natural or engineering units). On the other hand coding the design variables provides another advange: generally, the engineering units are not directly comparable while coded variables are very effective for determining the relative size of factor effects.

We can see that these three ways of coding the variable levels lead to equivalent results both in lm, anova and prediction. Our preference goes to use numeric values as it is more intuitive and allows for easier prediction between the fixed levels. 

### sd bars in interaction plots 

Here we're making a step further in the representation of interaction plots, we're adding error bars to the means. There are many ways to do this and we're providing a simple approach with the function plotMeans from the package RcmdrMisc.


```r
library(RcmdrMisc)
```

We select standard error as argument for the error.bars argument.


```r
# Alternative plot from the RcmdrMisc package ("Stats facile avec R")
par(mfrow = c(1,1))
plotMeans(response = chmn_fct$yield,
          factor2 = chmn_fct$A,
          factor1 = chmn_fct$B,
          error.bars = "se",
          xlab = "A - Reactant",
          legend.lab = "B - Catalist",
          ylab = "Yield")
```

<img src="doe_2^k_files/figure-html/unnamed-chunk-8-1.png" width="672" />

## 2^3 factorial design

The plasma etching example

A - gap in cm
B - flow
C - power in W
response - etch rate in Angstrom/m


```r
pls <- read.csv("../industRial/data-raw/6-3_plasma.csv")
plsn <- pls %>% 
  gather(replicate, etch, Rep1, Rep2)
plsn_fct <- plsn %>%
  mutate(across(c(A,B,C), as_factor))
```

### lm and anova


```r
plsn_ctr_lm <- lm(
  formula = etch ~ A * B * C, 
  data = plsn_fct,
  contrasts = list(A = "contr.sum", B = "contr.sum", C = "contr.sum")
  )
summary(plsn_ctr_lm)
```

```

Call:
lm(formula = etch ~ A * B * C, data = plsn_fct, contrasts = list(A = "contr.sum", 
    B = "contr.sum", C = "contr.sum"))

Residuals:
   Min     1Q Median     3Q    Max 
-65.50 -11.12   0.00  11.12  65.50 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  776.062     11.865  65.406 3.32e-12 ***
A1            50.812     11.865   4.282 0.002679 ** 
B1            -3.688     11.865  -0.311 0.763911    
C1          -153.062     11.865 -12.900 1.23e-06 ***
A1:B1        -12.437     11.865  -1.048 0.325168    
A1:C1        -76.812     11.865  -6.474 0.000193 ***
B1:C1         -1.062     11.865  -0.090 0.930849    
A1:B1:C1      -2.813     11.865  -0.237 0.818586    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 47.46 on 8 degrees of freedom
Multiple R-squared:  0.9661,	Adjusted R-squared:  0.9364 
F-statistic: 32.56 on 7 and 8 DF,  p-value: 2.896e-05
```


```r
plsn_ctr_aov <- aov(plsn_ctr_lm)
summary(plsn_ctr_aov)
```

```
            Df Sum Sq Mean Sq F value   Pr(>F)    
A            1  41311   41311  18.339 0.002679 ** 
B            1    218     218   0.097 0.763911    
C            1 374850  374850 166.411 1.23e-06 ***
A:B          1   2475    2475   1.099 0.325168    
A:C          1  94403   94403  41.909 0.000193 ***
B:C          1     18      18   0.008 0.930849    
A:B:C        1    127     127   0.056 0.818586    
Residuals    8  18020    2253                     
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

The main effects of Gap and Power are highly significant (both have very small P-values). The AC interaction is also highly significant; thus, there is a strong interaction between Gap and Power.

### R^2 and Adjusted R^2

The ordinary R^2 is 0.9661 and it measures the proportion of total variability explained by the model. A potential problem with this statistic is that it always increases as factors are added to the model, even if these factors are not significant. The adjusted R^2 is obtained by dividing the Sums of Squares by the degrees of freedom, and is adjusted for the size of the model, that is the number of factors.


```r
plsn_ctr_reduced_lm <- lm(
  formula = etch ~ A + C + A:C, 
  data = plsn_fct,
  contrasts = list(A = "contr.sum", C = "contr.sum")
  )
```

Besides the base summary() function, R squared and adjusted R squared can also be easily retrieved with the glance function from the {broom} package. We're extracting them here for the complete and for reduced model:


```r
glance(plsn_ctr_lm)[1:2] %>%
  bind_rows(glance(plsn_ctr_reduced_lm)[1:2], 
            .id = "model")
```

```
# A tibble: 2 x 3
  model r.squared adj.r.squared
  <chr>     <dbl>         <dbl>
1 1         0.966         0.936
2 2         0.961         0.951
```

Adjusted R² has improved. Removing the nonsignificant terms from the full model has produced a final model that is likely to function more effectively as a predictor of new data.

### Coding natural values

Now that we have model often we will want to predict the response at a certainly specific level between the coded factor levels of $\pm$ 1.

To do that we need to convert that specific the natural value into a coded value. Lets calculate the coded value for the factor A (gap) of which the natural value is nA = 0.9, between the natural levels of nA = 0.8 and nA = 1.2. We choose to do this for a fixed level of C of 1, corresponding to its maximum of 325W..


```r
# Converting natural value xA into coded value cA:
lA <- 0.8
hA <- 1.2
xA <- 0.9

cA <- (xA - (lA + hA) / 2) / ((hA -  lA) / 2)
cA
```

```
[1] -0.5
```

To be noted that the opposite conversion looks like:


```r
# Converting back the coded value cA into its natural value xA
lA <- 0.8
hA <- 1.2
iA <- -0.5

xA <- iA * ((hA - lA) / 2) + ((lA + hA)/2)
xA
```

```
[1] 0.9
```

### Coded values prediction

And now we can feed our linear model and make predictions:


```r
plsn_lm <- lm(
  formula = etch ~ A * C, 
  data = plsn,
  # contrasts = list(A = "contr.sum", B = "contr.sum", C = "contr.sum")
  )
summary(plsn_lm)
```

```

Call:
lm(formula = etch ~ A * C, data = plsn)

Residuals:
   Min     1Q Median     3Q    Max 
-72.50 -15.44   2.50  18.69  66.50 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)   776.06      10.42  74.458  < 2e-16 ***
A             -50.81      10.42  -4.875 0.000382 ***
C             153.06      10.42  14.685 4.95e-09 ***
A:C           -76.81      10.42  -7.370 8.62e-06 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 41.69 on 12 degrees of freedom
Multiple R-squared:  0.9608,	Adjusted R-squared:  0.9509 
F-statistic: 97.91 on 3 and 12 DF,  p-value: 1.054e-08
```


```r
plsn_new <- tibble(A = cA, C = 1)
pA <- predict(plsn_lm, plsn_new)
pA
```

```
       1 
992.9375 
```

We can visualize this outcome as follows:


```r
plsn %>%
  filter(C == 1) %>%
  ggplot() +
  geom_point(aes(x = A, y = etch, color = as_factor(C))) +
  geom_smooth(aes(x = A, y = etch), method = "lm") +
  geom_point(aes(x = cA, y = pA)) +
  scale_y_continuous(n.breaks = 10) + 
  scale_color_discrete(guide = FALSE) +
  theme_industRial() +
  theme(plot.title = ggtext::element_markdown()) +
  labs(
    title = "3^k factorial design",
    subtitle = "Prediction with reduced model")
```

<img src="doe_2^k_files/figure-html/unnamed-chunk-18-1.png" width="672" />

### Response surface plot 

We are introducing here response surface plots which is yet another way to visualize the experiment outputs as a function of the inputs. We're doing this with the persp() function from base R which provides an extremely fast rendering, easy parametrization and a readable output. 


```r
ngrid <- 20
Agrid <- Bgrid <- seq(from = -1, to = 1, length = ngrid)
yield <- predict(plsn_lm, expand.grid(A = Agrid, C = Bgrid))
yield <- matrix(yield, length(Agrid), length(Bgrid))

persp(
  x = Agrid, 
  y = Bgrid, 
  z = yield, 
  theta = -40, phi = 20, r = 10,
  ticktype = "d", xlab = "Gap", ylab = "Power",
  main = "Plasma etching experiment"
)
```

<img src="doe_2^k_files/figure-html/unnamed-chunk-19-1.png" width="672" />

Due to the interaction between factors A and C the surface is slightly bent. This is exactly what we observe in the interactions plots of which the one below corresponds to slicing the surface at the min and the max of Power:


```r
interaction.plot(x.factor = plsn$A, 
                 trace.factor = plsn$C,
                 fun = mean,
                 response = plsn$etch,
                 trace.label = "Power",
                 legend = TRUE,
                 xlab = "Gap",
                 ylab = "Yield",
                 main = "Plasma etching experiment")
```

<img src="doe_2^k_files/figure-html/unnamed-chunk-20-1.png" width="672" />

Just like in the surface plot we can see here in the interaction plot that the response of yield on gap is different depending on the level of power. When power is high it decreases and when power is low it increases. As a reminder this is what is called an interaction between these two factors.

## 2^k single replicate design

Possible approaches:
- graphical methods–normal and half-normal probability plots; no formal tests;
- assume some high-order interactions are zero, and fit a model that excludes them; degrees of freedom go into error, so testing is possible (not recommended)

The Filtration example


```r
flt <- read.csv("../industRial/data-raw/6-4_filtration.csv")
flt_nf <- flt %>%
  mutate(across(-filtration, as_factor))
```

### Single replicate lm


```r
flt_lm <- lm(
  formula = filtration ~ A * B * C * D, 
  data = flt)
summary(flt_lm)
```

```

Call:
lm(formula = filtration ~ A * B * C * D, data = flt)

Residuals:
ALL 16 residuals are 0: no residual degrees of freedom!

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept)  70.0625         NA      NA       NA
A            10.8125         NA      NA       NA
B             1.5625         NA      NA       NA
C             4.9375         NA      NA       NA
D             7.3125         NA      NA       NA
A:B           0.0625         NA      NA       NA
A:C          -9.0625         NA      NA       NA
B:C           1.1875         NA      NA       NA
A:D           8.3125         NA      NA       NA
B:D          -0.1875         NA      NA       NA
C:D          -0.5625         NA      NA       NA
A:B:C         0.9375         NA      NA       NA
A:B:D         2.0625         NA      NA       NA
A:C:D        -0.8125         NA      NA       NA
B:C:D        -1.3125         NA      NA       NA
A:B:C:D       0.6875         NA      NA       NA

Residual standard error: NaN on 0 degrees of freedom
Multiple R-squared:      1,	Adjusted R-squared:    NaN 
F-statistic:   NaN on 15 and 0 DF,  p-value: NA
```

We can see that being a single replicate design no statistics have been calculated for the effects in the model. A recommended approach in this case is to look into the normal probability plot of the model effects. Here we are going to prepare this plot with the function qqPlot() from the {car} package:


```r
flt_eff <- flt_lm$coefficients[2:16]
flt_eff_names <- names((flt_lm$coefficients)[2:16])
main_effects_plot <- qqPlot(
  flt_eff, envelope = 0.70, 
  id = list(
    method="y", n=5, cex=1, col=carPalette()[1], location="lr"), 
    grid = FALSE,
  col = "black",
  col.lines = "black",
  main = "Chemical vessel - Normal plot of effects"
  )
```

<img src="doe_2^k_files/figure-html/unnamed-chunk-23-1.png" width="672" />

In plot we can see that the effects that have the highest influence on the output are the effects A, C and D and their interactions. We can still confirm these observations with a calculation of the percentage contribution of each effect as follows:


```r
flt_lm_tidy <- flt_lm %>%
  tidy() %>%
  filter(term != "(Intercept)") %>%
  mutate(
    effect_estimate = - 2 * estimate,
    effect_estimate_sum = sum(effect_estimate), 
    effect_contribution_perc = abs((effect_estimate/effect_estimate_sum)*100) %>%
      round(2)
  )
main_effects_table <- flt_lm_tidy %>%
  select(term, effect_estimate, effect_contribution_perc) %>%
  arrange(desc(effect_contribution_perc)) %>%
  head(8) %>%
  kable()
```

### Single replicate reduced model

Following the previous analysis we are removing the factor B from the model and keeping only the 2nd order interactions assuming the system also respects the sparcity of effects principle.


```r
flt_red_lm <- lm(
  formula = filtration ~ A + C + D + A:C + A:D, 
  data = flt)
summary(flt_red_lm)
```

```

Call:
lm(formula = filtration ~ A + C + D + A:C + A:D, data = flt)

Residuals:
    Min      1Q  Median      3Q     Max 
-6.3750 -1.5000  0.0625  2.9062  5.7500 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)   70.062      1.104  63.444 2.30e-14 ***
A             10.812      1.104   9.791 1.93e-06 ***
C              4.938      1.104   4.471   0.0012 ** 
D              7.313      1.104   6.622 5.92e-05 ***
A:C           -9.063      1.104  -8.206 9.41e-06 ***
A:D            8.312      1.104   7.527 2.00e-05 ***
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 4.417 on 10 degrees of freedom
Multiple R-squared:  0.966,	Adjusted R-squared:  0.9489 
F-statistic: 56.74 on 5 and 10 DF,  p-value: 5.14e-07
```

We can now see that we've regained degrees of freedom and obtained a sort of hidden replication allowing to calculate statistics and error terms on the model.

### Residuals analysis

Checking the residuals we see the significant effect of the remaining interactions. The residuals are not completely normal but the in the standardized residuals the deviations are contained within 1.2 sd.


```r
par(mfrow = c(2,2))
plot(flt_red_lm)
```

<img src="doe_2^k_files/figure-html/unnamed-chunk-26-1.png" width="672" />

We can now establish the main effects and interaction plots and conclude on the optimal settings to maximize the output: A and D should be on the max and C on the min.

