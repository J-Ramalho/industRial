

## Two level designs

### Coding factors

2 factors 2 levels

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

**The PET clothing improvement plan**

In this case study factors have only 2 levels. 


```r
library(tidyverse)
library(readxl)
library(stats)
library(industRial)
library(knitr)
filter <- dplyr::filter
select <- dplyr::select
```

Below we start by preparing our dataset:


```r
library(DoE.base)
```


```r
pet_doe <- fac.design(
  randomize = FALSE,
  factor.names=list(A=c("-","+"), 
                    B=c("-","+"),
                    replicate = c("I", "II", "III"))
  )
```


```r
yield <- c(64.4,82.8,41.4,71.3,57.5,73.6,43.7,69.0,62.1,73.6,52.9,66.7)

pet_doe <- bind_cols(
  pet_doe,
  "yield" = yield,
)
```

#### Factors as +/-

In this first model we're using a design where the inputs levels have been defined as plus and minus, sometimes also called high and low. The actual naming is not important, what is critical is to ensure that those input parameters are coded as factors. 


```r
pet_fct <- pet_doe %>%
  mutate(across(c(A,B), as_factor))
```

Another detail is to put the higher level as the reference otherwise we will get inverted signs in the lm output:

[]{#relevel}


```r
pet_fct$A <- relevel(pet_fct$A, ref="+")
pet_fct$B <- relevel(pet_fct$B, ref="+")
```


and one final step is need which is the setup of the contrasts. As our design is ortogonal and we want the contrasts to add up to zero we have to indicate that on the factor so that the coefficients of the linear model are correctly calculated. The current definition of the contrasts is:


```r
contrasts(pet_fct$A)
```

```
  -
+ 0
- 1
```

So we change this with:

[]{#contrasts}


```r
contrasts(pet_fct$A) <- "contr.sum"
contrasts(pet_fct$B) <- "contr.sum"
contrasts(pet_fct$A)
```

```
  [,1]
+    1
-   -1
```

```r
contrasts(pet_fct$A)
```

```
  [,1]
+    1
-   -1
```

Now we can run our linear model:


```r
pet_ctr_lm <- lm(
  formula = yield ~ A * B, 
  data = pet_fct
  )
summary(pet_ctr_lm)
```

```

Call:
lm.default(formula = yield ~ A * B, data = pet_fct)

Residuals:
   Min     1Q Median     3Q    Max 
-4.600 -3.067 -1.150  2.492  6.900 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)   63.250      1.314  48.135 3.84e-11 ***
A1             9.583      1.314   7.293 8.44e-05 ***
B1            -5.750      1.314  -4.376  0.00236 ** 
A1:B1          1.917      1.314   1.459  0.18278    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 4.552 on 8 degrees of freedom
Multiple R-squared:  0.903,	Adjusted R-squared:  0.8666 
F-statistic: 24.82 on 3 and 8 DF,  p-value: 0.0002093
```

We can observe in the output that the p value of the effects is the same in the lm and in the the aov functions. This confirms that the contrasts have been correctly specified with contr.sum

Note that we've had to adjust the contrasts in the lm function with contr.sum which applies to cases where the sum of the contrasts is zero (the R default is contr.treatment which applies to cases where the levels are coded as 0 and 1).

and now going to apply a prediction:


```r
predict(pet_ctr_lm, newdata = list(A = "+", B = "+"))
```

```
 1 
69 
```

#### Factors as +/- 1 

In this example we convert the levels to factors still using the +/-1 notation. This will also be helpfull to apply what are called the Yates tables.


```r
coded <- function(x) { ifelse(x == x[1], -1, 1) }
```

We again convert them to factors and put the upper level as the reference. Regarding the contrasts we show a simpler and more direct approach now by defining them directly in the lm() function.


```r
pet_fct <- pet_fct %>% mutate(cA = coded(A), cB = coded(B))
pet_fct2 <- pet_fct %>% mutate(across(c(cA, cB), as_factor))
pet_fct2$cA <- relevel(pet_fct2$cA, ref = "1")
pet_fct2$cB <- relevel(pet_fct2$cB, ref = "1")

pet_ctr2_lm <- lm(
  formula = yield ~ cA * cB, 
  data = pet_fct2,
  contrasts = list(cA = "contr.sum", cB = "contr.sum")
  )
summary(pet_ctr2_lm)
```

```

Call:
lm.default(formula = yield ~ cA * cB, data = pet_fct2, contrasts = list(cA = "contr.sum", 
    cB = "contr.sum"))

Residuals:
   Min     1Q Median     3Q    Max 
-4.600 -3.067 -1.150  2.492  6.900 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)   63.250      1.314  48.135 3.84e-11 ***
cA1            9.583      1.314   7.293 8.44e-05 ***
cB1           -5.750      1.314  -4.376  0.00236 ** 
cA1:cB1        1.917      1.314   1.459  0.18278    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 4.552 on 8 degrees of freedom
Multiple R-squared:  0.903,	Adjusted R-squared:  0.8666 
F-statistic: 24.82 on 3 and 8 DF,  p-value: 0.0002093
```

Note that a coefficient in a regression equation is the change in the response when the corresponding variable changes by +1. Special attention to the + and - needs to be taken with the R output.

As A or B changes from its low level to its high level, the coded variable changes by 1 − (−1) = +2, so the change in the response is twice the regression coefficient.

So the effects and interaction(s) from their minumum to their maximum correspond to  twice the values in the “Estimate” column. These regression coefficients are often called effects and interactions, even though they differ from the definitions used in the designs themeselves.

Checking now with coded factors:


```r
predict(pet_ctr2_lm, newdata = list(cA = "1", cB = "1"))
```

```
 1 
69 
```

#### Factors as +/- 1 numeric

In this example we're going to code the levels with +1/-1 but we're going use the numeric coding:


```r
pet_num <- pet_fct %>% mutate(cA = coded(A), cB = coded(B))
pet_num_lm <- lm(
  formula = yield ~ cA * cB, 
  data = pet_num
  )
summary(pet_num_lm)
```

```

Call:
lm.default(formula = yield ~ cA * cB, data = pet_num)

Residuals:
   Min     1Q Median     3Q    Max 
-4.600 -3.067 -1.150  2.492  6.900 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)   63.250      1.314  48.135 3.84e-11 ***
cA             9.583      1.314   7.293 8.44e-05 ***
cB            -5.750      1.314  -4.376  0.00236 ** 
cA:cB          1.917      1.314   1.459  0.18278    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 4.552 on 8 degrees of freedom
Multiple R-squared:  0.903,	Adjusted R-squared:  0.8666 
F-statistic: 24.82 on 3 and 8 DF,  p-value: 0.0002093
```

In this case we did not define any contrasts. Looking into the lm We can see we've obtained exactly the same outputs.


```r
predict(pet_num_lm, newdata = list(cA = 1, cB = 1))
```

```
 1 
69 
```

As the inputs are coded as numeric this behaves just like the first simple linear model we've seen in the Case Study on One Factor with Multiple levels. In particular when we feed the predictions function with numeric values.

This is very intuitive as it corresponds to the original units of the experiments (also called natural or engineering units). On the other hand coding the design variables provides another advange: generally, the engineering units are not directly comparable while coded variables are very effective for determining the relative size of factor effects.

We can see that these three ways of coding the variable levels lead to equivalent results both in lm and prediction. Our preference goes to use numeric values as it is more intuitive and allows for easier prediction between the fixed levels. 

And now in order to better understand the coding of factors in this unit, we're going to establish a simple regression plot of our data:


```r
pet_num %>% 
  unclass() %>% 
  as_tibble() %>%
  mutate(cA = coded(A), cB = coded(B)) %>%
  pivot_longer(
    cols = c("cA", "cB"),
    names_to = "variable",
    values_to = "level") %>% 
  ggplot() +
  geom_point(aes(x = level, y = yield)) +
  geom_smooth(aes(x = level, y = yield), 
              method = "lm", se = FALSE, fullrange = TRUE) +
  # coord_cartesian(xlim = c(-2, 2)) +
  # geom_hline(yintercept = 27.5, color = "grey50") +
  # scale_y_continuous(n.breaks = 20) +
  facet_wrap(vars(variable)) +
  theme_industRial()
```

<img src="9_twolevelDOE_files/figure-html/unnamed-chunk-17-1.png" width="672" />

Note that we had to extract the data from the S3 doe object, which we've done with using unclass() and then as_tibble()

The intercept passes at 27.5 as seen on the lm summary. We're going now to put the B factor at its maximum and replot:


```r
pet_num %>% 
  unclass() %>%
  as_tibble() %>%
  mutate(cA = coded(A), cB = coded(B)) %>%
  filter(cB == 1) %>%
  pivot_longer(
    cols = c("cA", "cB"),
    names_to = "variable",
    values_to = "level") %>% 
  ggplot() +
  geom_point(aes(x = level, y = yield)) +
  geom_smooth(aes(x = level, y = yield), 
              method = "lm", se = FALSE, fullrange = TRUE) +
  coord_cartesian(xlim = c(-2, 2)) +
  scale_y_continuous(n.breaks = 10) +
  facet_wrap(vars(variable)) +
  theme_industRial()
```

<img src="9_twolevelDOE_files/figure-html/unnamed-chunk-18-1.png" width="672" />

As seen on the plot the output of our prediction is 69 corresponding the high level of A when B is at 1. To be precise we need to multiply all the coefficients by the levels of the factors as : 63.250 + 9.583x(+1) - 5.750x(+1) + 1.917

#### sd bars in interaction plots 

Here we're making a step further in the representation of interaction plots, we're adding error bars to the means. There are many ways to do this and we're providing a simple approach with the function plotMeans from the package RcmdrMisc.

[]{#plotMeans}


```r
library(RcmdrMisc)
```

We select standard error as argument for the error.bars argument.


```r
par(mfrow = c(1,1), bty = "l")
plotMeans(response = pet_fct$yield,
          factor2 = pet_fct$A,
          factor1 = pet_fct$B,
          error.bars = "se",
          xlab = "A - Reactant",
          legend.lab = "B - Catalist\n(error bars +/-se)",
          ylab = "Yield",
          col = viridis::viridis(12)[4],
          legend.pos = "bottomright",
          main = "The PET clothing improvement plan")
```

<img src="9_twolevelDOE_files/figure-html/unnamed-chunk-20-1.png" width="672" />

### Coding natural values

3 factors 2 levels

The plasma etching example

A - gap in cm
B - flow
C - power in W
response - etch rate in Angstrom/m


```r
pls <- read.csv("~/Documents/data_science/industRial/data-raw/6-3_plasma.csv")

plsn <- pls %>% 
  gather(replicate, etch, Rep1, Rep2)
plsn_fct <- plsn %>%
  mutate(across(c(A,B,C), as_factor))
```


```r
pls <- fac.design(
  randomize = FALSE,
  factor.names=list(A=c(-1,1), 
                    B=c(-1,1),
                    C=c(-1,1),
                    replicate = c("Rep1", "Rep2"))
  )
```


```r
etch <- c(550, 669, 633, 642, 1037, 749, 1075, 729, 604, 650 , 601, 635, 1052, 868, 1063, 860)

plsn_fct <- bind_cols(
  pls2,
  "etch" = etch
)
```

#### lm and anova


```r
plsn_lm <- lm(
  formula = etch ~ A * B * C, 
  data = plsn
  # contrasts = list(A = "contr.sum", B = "contr.sum", C = "contr.sum")
  )
summary(plsn_lm)
```

```

Call:
lm.default(formula = etch ~ A * B * C, data = plsn)

Residuals:
   Min     1Q Median     3Q    Max 
-65.50 -11.12   0.00  11.12  65.50 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  776.062     11.865  65.406 3.32e-12 ***
A            -50.812     11.865  -4.282 0.002679 ** 
B              3.688     11.865   0.311 0.763911    
C            153.062     11.865  12.900 1.23e-06 ***
A:B          -12.437     11.865  -1.048 0.325168    
A:C          -76.812     11.865  -6.474 0.000193 ***
B:C           -1.062     11.865  -0.090 0.930849    
A:B:C          2.813     11.865   0.237 0.818586    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 47.46 on 8 degrees of freedom
Multiple R-squared:  0.9661,	Adjusted R-squared:  0.9364 
F-statistic: 32.56 on 7 and 8 DF,  p-value: 2.896e-05
```


```r
plsn_aov <- aov(plsn_lm)
summary(plsn_aov)
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

#### R^2 and Adjusted R^2

The ordinary R^2 is 0.9661 and it measures the proportion of total variability explained by the model. A potential problem with this statistic is that it always increases as factors are added to the model, even if these factors are not significant. The adjusted R^2 is obtained by dividing the Sums of Squares by the degrees of freedom, and is adjusted for the size of the model, that is the number of factors.


```r
plsn_reduced_lm <- lm(
  formula = etch ~ A + C + A:C, 
  data = plsn
  )
```

[]{#glance}

Besides the base summary() function, R squared and adjusted R squared can also be easily retrieved with the glance function from the {broom} package. We're extracting them here for the complete and for reduced model:


```r
library(broom)
```


```r
glance(plsn_lm)[1:2] %>%
  bind_rows(glance(plsn_reduced_lm)[1:2], 
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

#### Coding natural values

Now that we have model often we will want to predict the response at a certainly specific level between the coded factor levels of $\pm$ 1.

To do that we need to convert that specific the natural value into a coded value. Lets calculate the coded value for the factor A (gap) of which the natural value is nA = 0.9, between the natural levels of nA = 0.8 and nA = 1.2. We choose to do this for a fixed level of C of 1, corresponding to its maximum of 325W.


```r
natural2coded <- function(xA, lA, hA) {(xA - (lA + hA) / 2) / ((hA -  lA) / 2)}
```


```r
# Converting natural value xA into coded value cA:
lA <- 0.8
hA <- 1.2
xA <- 0.9

cA <- natural2coded(xA, lA, hA)
cA
```

```
[1] -0.5
```


To be noted that the opposite conversion looks like:


```r
coded2natural <- function(cA, lA, hA) {cA * ((hA - lA) / 2) + ((lA + hA)/2)} 
```


```r
# Converting back the coded value cA into its natural value xA
lA <- 0.8
hA <- 1.2
cA <- -0.5

nA <- coded2natural(cA, lA, hA)
nA
```

```
[1] 0.9
```

#### Coded values prediction

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
lm.default(formula = etch ~ A * C, data = plsn)

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

<img src="9_twolevelDOE_files/figure-html/unnamed-chunk-35-1.png" width="672" />

#### Response surface plot 

We are introducing here response surface plots which is yet another way to visualize the experiment outputs as a function of the inputs. We're doing this with the persp() function from base R which provides an extremely fast rendering, easy parametrization and a readable output. 

[]{#persp}


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

<img src="9_twolevelDOE_files/figure-html/unnamed-chunk-36-1.png" width="672" />

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

<img src="9_twolevelDOE_files/figure-html/unnamed-chunk-37-1.png" width="672" />

Just like in the surface plot we can see here in the interaction plot that the response of yield on gap is different depending on the level of power. When power is high it decreases and when power is low it increases. As a reminder this is what is called an interaction between these two factors.

### Single replicate designs

m factors 2 levels 

Possible approaches:
- graphical methods–normal and half-normal probability plots; no formal tests;
- assume some high-order interactions are zero, and fit a model that excludes them; degrees of freedom go into error, so testing is possible (not recommended)

The Filtration example


```r
flt <- read.csv("~/Documents/data_science/industRial/data-raw//6-4_filtration.csv")
flt_nf <- flt %>%
  mutate(across(-filtration, as_factor))
```

#### lm


```r
flt_lm <- lm(
  formula = filtration ~ A * B * C * D, 
  data = flt)
summary(flt_lm)
```

```

Call:
lm.default(formula = filtration ~ A * B * C * D, data = flt)

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

We can see that being a single replicate design no statistics have been calculated for the effects in the model. A recommended approach in this case is to look into the normal probability plot of the model effects. 

#### qqPlot 

Here we are going to prepare this plot with the function qqPlot() from the {car} package:

[]{#qqPlot}


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

<img src="9_twolevelDOE_files/figure-html/unnamed-chunk-40-1.png" width="672" />

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

#### Reduced model

Following the previous analysis we are removing the factor B from the model and keeping only the 2nd order interactions assuming the system also respects the sparcity of effects principle.


```r
flt_red_lm <- lm(
  formula = filtration ~ A + C + D + A:C + A:D, 
  data = flt)
summary(flt_red_lm)
```

```

Call:
lm.default(formula = filtration ~ A + C + D + A:C + A:D, data = flt)

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

#### Residuals analysis

Checking the residuals we see the significant effect of the remaining interactions. The residuals are not completely normal but the in the standardized residuals the deviations are contained within 1.2 sd.


```r
par(mfrow = c(2,2))
plot(flt_red_lm)
```

<img src="9_twolevelDOE_files/figure-html/unnamed-chunk-43-1.png" width="672" />

We can now establish the main effects and interaction plots and conclude on the optimal settings to maximize the output: A and D should be on the max and C on the min.

