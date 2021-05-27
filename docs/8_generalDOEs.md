


## General factorial designs

m factors n levels designs

**The juice production plant**

We're comming back to our Juice Bottling context where a quality team was looking to put in operation a new measurement device for dry matter content in a juices bottling line.

After a short brainstorming using the Ishikawa tool presented before the team has identified several potential influcing parameters on the equipment bias when compared with the reference equipement: the product itself, the drymatter level on the product (its target), the speed of the filling line and the poweder particle size. In order to evaluate such impact the team has prepared a mid size experiment design with three products, three levels of drymatter, two line speed levels and two particle size levels.

First we load the DoE.base package:


```r
library(DoE.base)
```

and then generate the doe with the fac.design function.

### Factorial design {#fac.design}


```r
juice_doe <- fac.design(
  randomize = FALSE,
  factor.names = list(
    product = c("beetroot", "apple", "carrot"), 
    drymatter_target = c(10, 15, 20),
    part = c(1, 2, 3),
    speed = c(20, 25),
    particle_size = c(250, 300))
)
```

Note that the DoE generated is more than just a tibble, it belongs to a specific class called design and has many other attributes just like an lm or aov S3 objects.


```r
class(juice_doe)
```

```
[1] "design"     "data.frame"
```

The power and care given by the package authors become visible when we use an R generic function such as summary() with this object and we see it returns a tailor made output, in this case showing the levels of the different factors of our design: 


```r
summary(juice_doe)
```

```
Call:
fac.design(randomize = FALSE, factor.names = list(product = c("beetroot", 
    "apple", "carrot"), drymatter_target = c(10, 15, 20), part = c(1, 
    2, 3), speed = c(20, 25), particle_size = c(250, 300)))

Experimental design of type  full factorial 
108  runs

Factor settings (scale ends):
   product drymatter_target part speed particle_size
1 beetroot               10    1    20           250
2    apple               15    2    25           300
3   carrot               20    3                    
```

Using this the team has simple copied the experiment plan to an spreadsheet to collect the data:

```{}
juice_doe %>% 
  write_clip() 
```

and after a few day the file completed and ready for analysis looked like:


```r
juice_drymatter %>%
  head() %>%
  kable()
```



|product  | drymatter_TGT| speed| particle_size| part| drymatter_DRX| drymatter_REF|
|:--------|-------------:|-----:|-------------:|----:|-------------:|-------------:|
|apple    |            10|    20|           250|    1|          9.80|         10.05|
|apple    |            10|    20|           250|    2|          9.82|         10.05|
|apple    |            10|    20|           250|    3|          9.82|         10.05|
|beetroot |            10|    20|           250|    1|          9.79|         10.03|
|beetroot |            10|    20|           250|    2|          9.75|         10.03|
|beetroot |            10|    20|           250|    3|          9.77|         10.03|


```r
juice_drymatter <- juice_drymatter %>%
  mutate(bias = drymatter_DRX - drymatter_REF)
```

### Main effects plots

As the number of factors and levels of a design increase, more thinking is required to obtain good visualisation of the data. 

Main effects plots consist usually of a scatterplot representing the experiment output as a function of one of the inputs. In a design like this with three different inputs three plots are required:


```r
drymatter_TGT_plot <- juice_drymatter %>%
  group_by(drymatter_TGT) %>%
  summarise(bias_m_drymatter = mean(bias)) %>%
  ggplot(aes(x = drymatter_TGT, y = bias_m_drymatter)) +
  geom_point() +
  geom_line() +
  coord_cartesian(
    xlim = c(9,21),
    ylim = c(-1,0), expand = TRUE) +
  labs(
    title = "Juice bottling problem",
    subtitle = "Main effects plots",
    x = "drymatter_TGT [%]",
    y = "Average bias [g]"
  )

particle_size_plot <- juice_drymatter %>%  
  group_by(particle_size) %>%
  summarise(particle_size_bias_mean = mean(bias)) %>%
  ggplot(aes(x = particle_size, y = particle_size_bias_mean)) +
  geom_point() +
  geom_line() +
  coord_cartesian(
    xlim = c(240,310), 
    ylim = c(-1,0), expand = TRUE) +
  labs(
    x = "particle_size",
    y = "Average bias [g]"
  )

speed_plot <- juice_drymatter %>%  
  group_by(speed) %>%
  summarise(speed_bias_mean = mean(bias)) %>%
  ggplot(aes(x = speed, y = speed_bias_mean)) +
  geom_point() +
  geom_line() +
  coord_cartesian(
    xlim = c(19, 26),
    ylim = c(-1,0), expand = TRUE) +
  labs(
    x = "Speed",
    y = "Average bias [g]"
  )

drymatter_TGT_plot + particle_size_plot + speed_plot
```

<img src="8_generalDOEs_files/figure-html/unnamed-chunk-8-1.png" width="80%" />

This kind of plots gives already important insights in to the experiement outcome, even before any deeper analysis with a linear model and anova. In our case:

* higher particle_size and higher speed result in higher bias weight deviation
* beyond 10.5% drymatter_TGT level the bias weight is always higher than the target

### Interactions plots (custom) (#errorbar)

In designs like these with 3 factors we have 3 possible interactions (A-B, A-C, B-C) corresponding the the possible combination between them. This results in three interaction plots that we're presenting below. The approach here goes beyond the interaction.plot function from the `{stats}` package presented previously in the two factors multiple levels case. We are developping here the plots with {ggplot2} which provides much more control on the plot attibutes but on the other hand requires that additional code is added to calculate the means by group.


```r
drymatter_TGT_particle_size_plot <- juice_drymatter %>%  
  mutate(particle_size = as_factor(particle_size)) %>%
  group_by(drymatter_TGT, particle_size) %>%
  summarise(drymatter_bias_mean = mean(bias), drymatter_bias_sd = sd(bias)) %>%
  ggplot(aes(x = drymatter_TGT, y = drymatter_bias_mean, color = particle_size, linetype = particle_size)) +
  geom_point(aes(group = particle_size), size = 2) +
  geom_line(aes(group = particle_size, linetype = particle_size)) +
  scale_linetype(name = "Particle Size") +
  geom_errorbar(aes(
    ymin = drymatter_bias_mean - 2 * drymatter_bias_sd,
    ymax = drymatter_bias_mean + 2 * drymatter_bias_sd,
    width = .5
  )) +
  scale_linetype(guide=FALSE) +
  scale_color_viridis_d(option = "C", begin = 0.3, end = 0.7, name = "Particle size") +
  coord_cartesian(
    xlim = c(9,21),
    ylim = c(-1,0), expand = TRUE) +
  annotate(geom = "text", x = Inf, y = 0, label = "Error bars are +/- 2xSD", 
    hjust = 1, vjust = -1, colour = "grey30", size = 3, 
    fontface = "italic") +
  labs(
    title = "Juice bottling problem",
    subtitle = "Interaction plots",
    x = "Drymatter target",
    y = "Average bias deviation [g]"
  ) +
  theme_industRial() +
  theme(legend.justification=c(1,0), legend.position=c(1,0))

drymatter_TGT_speed_plot <- juice_drymatter %>%  
  mutate(speed = as_factor(speed)) %>%
  group_by(drymatter_TGT, speed) %>%
  summarise(drymatter_bias_mean = mean(bias), drymatter_bias_sd = sd(bias)) %>%
  ggplot(aes(x = drymatter_TGT, y = drymatter_bias_mean, color = speed)) +
  geom_point(aes(group = speed), size = 2) +
  geom_line(aes(group = speed, linetype = speed)) +
  scale_linetype(guide=FALSE) +
  scale_color_viridis_d(option = "C", begin = 0.3, end = 0.7, name = "Speed") +
  geom_errorbar(aes(
    ymin = drymatter_bias_mean - 2 * drymatter_bias_sd,
    ymax = drymatter_bias_mean + 2 * drymatter_bias_sd,
    width = .5
  )) +
  coord_cartesian(
    xlim = c(9, 21),
    ylim = c(-1,0), expand = TRUE) +
  annotate(geom = "text", x = Inf, y = 0, label = "Error bars are +/- 2xSD", 
    hjust = 1, vjust = -1, colour = "grey30", size = 3, 
    fontface = "italic") +
  labs(
    x = "Dry matter target",
    y = "Average bias deviation [g]"
  ) +
  theme_industRial() +
  theme(legend.justification=c(1,0), legend.position=c(1,0))

speed_particle_size_plot <- juice_drymatter %>%  
  mutate(particle_size = as_factor(particle_size)) %>%
  group_by(speed, particle_size) %>%
  summarise(drymatter_bias_mean = mean(bias), drymatter_bias_sd = sd(bias)) %>%
  ggplot(aes(x = speed, y = drymatter_bias_mean, color = particle_size)) +
  geom_point(aes(group = particle_size), size = 2) +
  geom_line(aes(group = particle_size, linetype = particle_size)) +
  scale_linetype(guide=FALSE) +
  scale_color_viridis_d(option = "C", begin = 0.3, end = 0.7, name = "Particle size") +
  geom_errorbar(aes(
    ymin = drymatter_bias_mean - 2 * drymatter_bias_sd,
    ymax = drymatter_bias_mean + 2 * drymatter_bias_sd,
    width = .5
  )) +
  coord_cartesian(
    xlim = c(19, 26),
    ylim = c(-1,0), expand = TRUE) +
  annotate(geom = "text", x = Inf, y = 0, label = "Error bars are +/- 2xSD", 
    hjust = 1, vjust = -1, colour = "grey30", size = 3, 
    fontface = "italic") +
  labs(
    x = "Speed",
    y = "Average bias deviation [g]"
  ) +
  theme_industRial() +
  theme(legend.justification=c(1,0), legend.position=c(1,0))

drymatter_TGT_particle_size_plot + drymatter_TGT_speed_plot + speed_particle_size_plot
```

<img src="8_generalDOEs_files/figure-html/unnamed-chunk-9-1.png" width="80%" />

The plots indicate no interaction between the different factors as all lines do not intercept and are mostly parallel.

In most cases the anova would be performed first and only the plot for the significant interactions would be plotted, if any.

### Anova with 3rd level interactions

The sources of variation for the Anova table for three-factor fixed effects model are: A, B, C, AB, AC, BC, ABC. To be noted that like in the two-factors we must have at least two parts (n>2) to determine the sum of squares due to error if all possible interactions are to be included in the model.

We are now fully prepared for an assessment of the effect of the different factors with the anova. To reduce the amount of coding we're inputing the model directly in the aov function:


```r
juice_drymatter_aov <- aov(
  bias ~ drymatter_TGT * speed * particle_size,
  data = juice_drymatter)
summary(juice_drymatter_aov)
```

```
                                   Df Sum Sq Mean Sq F value Pr(>F)    
drymatter_TGT                       1 1.3149  1.3149 486.057 <2e-16 ***
speed                               1 0.0000  0.0000   0.000  0.985    
particle_size                       1 0.6241  0.6241 230.705 <2e-16 ***
drymatter_TGT:speed                 1 0.0007  0.0007   0.272  0.603    
drymatter_TGT:particle_size         1 0.0028  0.0028   1.040  0.310    
speed:particle_size                 1 0.0032  0.0032   1.191  0.278    
drymatter_TGT:speed:particle_size   1 0.0039  0.0039   1.442  0.233    
Residuals                         100 0.2705  0.0027                   
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

The observations of the plots are confirmed and completed with statistical input: we see that the percentage of drymatter_TGT and the particle_size significantly affect the bias volume (p < 0.05). The drymatter_TGT-particle_size interactions are non significative.

As expected the anova confirms strong influence of the dissolution level on the bias.

From the analysis all interactions could be removed from the model in order to establish a predictive model.
