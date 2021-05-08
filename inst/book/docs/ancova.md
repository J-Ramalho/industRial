

### Means comparison & covariance

#### Ancova

We assess here the potential utilisation of the analysis of covariance (ancova) in situations where a continuous variable may be influencing the measured value. This technique complements the analysis of variance (anova) allowing for a more accurate assessment of the effects of the categorical variables.

Below a description of the approach taken from [@Montgomery2012], pag.655:

*Suppose that in an experiment with a response variable y there is another variable, say x, and that y is linearly related to x. Furthermore, suppose that x cannot be controlled by the experimenter but can be observed along with y. The variable x is called a covariate or concomitant variable. The analysis of covariance involves adjusting the observed response variable for the effect of the concomitant variable.* 

*If such an adjustment is not performed, the concomitant variable could inflate the error mean square and make true differences in the response due to treatments harder to detect. Thus, the analysis of covariance is a method of adjusting for the effects of an uncontrollable nuisance variable. As we will see, the procedure is a combination of analysis of variance and regression analysis.*

*As an example of an experiment in which the analysis of covariance may be employed, consider a study performed to determine if there is a difference in the strength of a monofilament fiber produced by three different machines. The data from this experiment are shown in Table 15.10 (below). Figure 15.3 presents a scatter diagram of strength (y) versus the diameter (or thickness) of the sample. Clearly, the strength of the fiber is also affected by its thickness; consequently, a thicker fiber will generally be stronger than a thinner one. The analysis of covariance could be used to remove the effect of thickness (x) on strength (y) when testing for differences in strength between machines.*


```r
library(tidyverse)
library(knitr)
library(readxl)
filter <- dplyr::filter
select <- dplyr::select
```


```r
filament <- read_excel("../industRial/data-raw/filament.xlsx")
filament %>% 
  kable()
```



|machine | strength| thickness|
|:-------|--------:|---------:|
|m1      |       36|        20|
|m1      |       41|        25|
|m1      |       39|        24|
|m1      |       42|        25|
|m1      |       49|        32|
|m2      |       40|        22|
|m2      |       48|        28|
|m2      |       39|        22|
|m2      |       45|        30|
|m2      |       44|        28|
|m3      |       35|        21|
|m3      |       37|        23|
|m3      |       42|        26|
|m3      |       34|        21|
|m3      |       32|        15|

Below a plot of strenght by thickness:


```r
filament %>%
  ggplot(aes(x = thickness, y = strength)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  theme_light()
```

<img src="ancova_files/figure-html/unnamed-chunk-4-1.png" width="80%" />


```r
# as the plot is slightly different from the book, the plot below has been done 
# in base R just to confirm and we get exactly the sameas  with ggplot2.
par(mfrow=c(1,1))
plot(filament$thickness, filament$strength)
# plot(jitter(filament$strength, 1), jitter(filament$thickness, 1))
abline(lm(strength~thickness, data = filament))
```

And a short test to assess the strenght of the correlation:


```r
library(stats)
```


```r
cor.test(filament$strength, filament$thickness)
```

```

	Pearson's product-moment correlation

data:  filament$strength and filament$thickness
t = 9.8039, df = 13, p-value = 2.263e-07
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.8209993 0.9797570
sample estimates:
     cor 
0.938542 
```

Going further and using the approach from [@Broc2016] I'm faceting the scatterplots to assess if the coefficient of the linear regression is similar for all the levels of the machine factor:


```r
filament %>%
  ggplot(aes(x = thickness, y = strength)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(facets = "machine") +
  theme_light()
```

<img src="ancova_files/figure-html/unnamed-chunk-8-1.png" width="80%" />

Visually this is the case, going from one level to the other is not changing the relationship between thickness and strenght - increasing thickness increases stenght. Visually the slopes are similar but the number of points is small. In a real case this verification could be extended with the correlation test for each level or/and a statistical test between slopes.

We're now reproducing in R the ancova case study from the book, still using the aov function.

The way to feed the R function arguments is obtained from https://www.datanovia.com/en/lessons/ancova-in-r/

Note that in the formula the covariate goes first (and there is no interaction)! If you do not do this in order, you will get different results.

#### Ancova in aov

*Three different machines produce a monofilament fiber for a textile company. The process engineer is interested in determining if there is a difference in the breaking strength of the fiber produced by the three machines. However, the strength of a fiber is related to its diameter, with thicker fibers being generally stronger than thinner ones. A random sample of five fiber specimens is selected from each machine.*


```r
filament_ancova <- aov(strength ~ thickness  + machine, filament)
summary(filament_ancova)
```

```
            Df Sum Sq Mean Sq F value   Pr(>F)    
thickness    1 305.13  305.13 119.933 2.96e-07 ***
machine      2  13.28    6.64   2.611    0.118    
Residuals   11  27.99    2.54                     
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

All values from the book table page 662 are correctly obtained with the code above. In particular:

* machine in this table corresponds to the adjusted machines mean square
* residuals in this table corresponds to the error

to be noted that the R anova table gives the thickness meansquare while the book doesn't.

Conclusions from the book in page 662:

*Comparing the adjusted treatment means with the unadjusted treatment means (the y i. ), we note that the adjusted means are much closer together, another indication that the covariance analysis was necessary.*

*A basic assumption in the analysis of covariance is that the treatments do not influence the covariate x because the technique removes the effect of variations in the x i. . However, if the variability in the x i. is due in part to the treatments, then analysis of covariance removes part of the treatment effect. Thus, we must be reasonably sure that the treatments do not affect the values x ij.*

*In some experiments this may be obvious from the nature of the covariate, whereas in others it may be more doubtful. In our example, there may be a difference in fiber diameter (x ij ) between the three machines. In such cases, Cochran and Cox (1957) suggest that an analysis of variance on the x ij values may be helpful in determining the validity of this assumption. ...there is no reason to believe that machines produce fibers of different diameters.*

(I did not go further here as it goes beyond the scope of the assessment)

#### Comparison with anova

Below I'm doing the common approach we've been using at NSTC in design of experiments.


```r
filament_aov <- aov(strength ~ machine, filament)
summary(filament_aov)
```

```
            Df Sum Sq Mean Sq F value Pr(>F)  
machine      2  140.4   70.20   4.089 0.0442 *
Residuals   12  206.0   17.17                 
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

The anova table obtained also corresponds correctly to the book example. 

Montgomery final observations:

*It is interesting to note what would have happened in this experiment if an analysis of covariance had not been performed, that is, if the breaking strength data (y) had been analyzed as a completely randomized single-factor experiment in which the covariate x was ignored. The analysis of variance of the breaking strength data is shown in Table 15.14. We immediately notice that the error estimate is much longer in the CRD analysis (17.17 versus 2.54). This is a reflection of the effectiveness of analysis of covariance in reducing error variability.*

*We would also conclude, based on the CRD analysis, that machines differ significantly in the strength of fiber produced. This is exactly opposite the conclusion reached by the covariance analysis.*

*If we suspected that the machines differed significantly in their effect on fiber strength, then we would try to equalize the strength output of the three machines. However, in this problem the machines do not differ in the strength of fiber produced after the linear effect of fiber diameter is removed. It would be helpful to reduce the within-machine fiber diameter variability because this would probably reduce the strength variability in the fiber.*

Potential applications

In the scope of methods validations this approach could potentially be used in robustness validations when there is suspiction that a continuous variable is disturbing the measurement.

Naturally this should not be applied everywhere but only where there would to be logical a physical or chemical reason behind as in the example with thickness and strenght.








