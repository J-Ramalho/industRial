


# Statistical Process Control {#SPC}

Keeping the variability of an industrial process under control is one of the most important objectives in manufacturing. Based on expert knowledge or on detailed functional analysis the product and process parameters that are critical to quality are identified and selected for close follow-up. The most common and effective way for such follow-up is the Statistical Process Control which is done by using control charts.

**The syringe injection molding process**

<div class="marginnote">

<div class="figure" style="text-align: center">
<img src="img/syringe_molding_bw.jpg" alt="A clean room for syringe injection molding with fully automatised handling" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-2)A clean room for syringe injection molding with fully automatised handling</p>
</div>

</div>

## xbar-R charts

There are many types of control charts and in this case study we're demonstrating the xbar and R charts. These two charts are often used together and are suited to the control the mean and the variability of a continuous variable.

Bamako Lightening is a company that manufactures lamps. The weight of each lamp is critical to the quality of the product. The Production Operator monitors the production process using xbar and R-charts. Samples are taken of six lamps every hour and their means and ranges plotted on control charts. Data is available representing samples taken a period of 25 hours of production.

Looking at the first five lines to confirm and assess the quality of our data for further processing. 


```r
head(syringe_diameter) %>%
    kable()
```



|Hour  |  Sample1|  Sample2|  Sample3|  Sample4|  Sample5|  Sample6|
|:-----|--------:|--------:|--------:|--------:|--------:|--------:|
|Hour1 | 5.331433| 5.339867| 5.324400| 5.336267| 5.322833| 5.318133|
|Hour2 | 5.324033| 5.321433| 5.314200| 5.323733| 5.341967| 5.339233|
|Hour3 | 5.326267| 5.340433| 5.313567| 5.356533| 5.338700| 5.356967|
|Hour4 | 5.355267| 5.360000| 5.317133| 5.331933| 5.344600| 5.347400|
|Hour5 | 5.337867| 5.326367| 5.314967| 5.313433| 5.337467| 5.340700|
|Hour6 | 5.343167| 5.335233| 5.323833| 5.346267| 5.333967| 5.320533|

We see that in this table each line corresponds to a sampling hour and each column corresponds to a sample number. 

We're now going to pass this data to the control chart plotting function qcc(). As this function takes a dataset of observations so we're removing the Hour column with the select function from tidyverse:


```r
syringe_clean <- syringe_diameter %>% 
  select(-Hour) %>%
  mutate(across(starts_with("S"), round, 2))
```

Now we load the qcc package that has the required quality control tools:

<b>Calibration run</b>

In order to establish a control chart it is recommended to run a "calibration run". The calibration run is used to calculate the control limits before entering "regular production". Using the first 10 samples we call the qcc() function to make the required calculations.

### Mean chart {#xbar_chart}


```r
library(qcc)
```


```r
syringe_xbar <- qcc(
  syringe_clean[1:10, ], 
  type = "xbar", 
  title = "Lamp weight \n xbar chart", 
  xlab = "Sample group",
  plot = FALSE
  )
```

Before we step ahead and simply plot the SPC chart and interpret the results lets look a bit in detail in the calculations done to established the Control Chart. To do this we're going to go in the details of what we've obtained in the previous chunk. 

A first step is to read the begining of the qcc() help file typing ?qcc in the console. It says "Create an object of class 'qcc' to perform statistical process control' (in R technical terms function is a helper that generates an S3 R object). 

The key point here is that this means we can inspect the calculations separately from the plot itself. We can start by confirming the class and the type of the qcc object:


```r
class(syringe_xbar)
```

```
[1] "qcc"
```

```r
typeof(syringe_xbar)
```

```
[1] "list"
```

It is confirmed it is an object of class qcc with the R type list. Looking into the structure of the list:


```r
str(syringe_xbar)
```

```
List of 11
 $ call      : language qcc(data = syringe_clean[1:10, ], type = "xbar", plot = FALSE, title = "Lamp weight \n xbar chart",      xlab = "Sample group")
 $ type      : chr "xbar"
 $ data.name : chr "syringe_clean[1:10, ]"
 $ data      : num [1:10, 1:6] 5.33 5.32 5.33 5.36 5.34 5.34 5.3 5.32 5.34 5.36 ...
  ..- attr(*, "dimnames")=List of 2
  .. ..$ Group  : chr [1:10] "1" "2" "3" "4" ...
  .. ..$ Samples: chr [1:6] "Sample1" "Sample2" "Sample3" "Sample4" ...
 $ statistics: Named num [1:10] 5.33 5.33 5.34 5.34 5.33 ...
  ..- attr(*, "names")= chr [1:10] "1" "2" "3" "4" ...
 $ sizes     : int [1:10] 6 6 6 6 6 6 6 6 6 6
 $ center    : num 5.33
 $ std.dev   : num 0.0142
 $ nsigmas   : num 3
 $ limits    : num [1, 1:2] 5.32 5.35
  ..- attr(*, "dimnames")=List of 2
  .. ..$ : chr ""
  .. ..$ : chr [1:2] "LCL" "UCL"
 $ violations:List of 2
  ..$ beyond.limits : int(0) 
  ..$ violating.runs: num(0) 
 - attr(*, "class")= chr "qcc"
```

The output is not easy to read but we present it here just to show that inside the list there are several tables with the statistical analysis required for our plot. If we want like to see for instance the standard deviation we can extract it separately:


```r
syringe_xbar$std.dev
```

```
[1] 0.01420679
```

And if we want like to see a summary of all the data stored in the object we could apply the summary method:


```r
summary(syringe_xbar)
```

```

Call:
qcc(data = syringe_clean[1:10, ], type = "xbar", plot = FALSE,     title = "Lamp weight \n xbar chart", xlab = "Sample group")

xbar chart for syringe_clean[1:10, ] 

Summary of group statistics:
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
5.325000 5.328333 5.333333 5.333333 5.337500 5.343333 

Group sample size:  6
Number of groups:  10
Center of group statistics:  5.333333
Standard deviation:  0.01420679 

Control limits:
      LCL      UCL
 5.315934 5.350733
```

We are now ready to finally we can see this all together in a plot:


```r
plot(syringe_xbar)
```

<img src="10_spc_files/figure-html/unnamed-chunk-11-1.png" width="80%" />

### Range chart {#Rchart}

Using the same 10 first samples we also obtain the corresponding R chart:


```r
syringe_R <- qcc(
  syringe_clean[1:10, ], 
  type = "R", 
  title = "Lamp weight \n R chart",
  xlab = "Sample group"
  )
```

<img src="10_spc_files/figure-html/unnamed-chunk-12-1.png" width="80%" />

<b>Regular production</b>

Now that the calibration data has been plotted we can consider that the control limits are defined. They can become fixed and reused in new plots for the future production runs. Samples from those future runs can then be assessed against this limits and the control chart rules can be verified (in this example the shewhart rules are used). We now add the remaining data points to our chart by specifying which lines we're refering too in our dataframe in the 'newdata' argument:


```r
syringe_xbar <- qcc(
  data = syringe_clean[1:10, ],
  newdata = syringe_clean[11:25,],
  type = "xbar", 
  title = "Lamp weight \n xbar chart", 
  xlab = "Sample group"
  )
```

<img src="10_spc_files/figure-html/unnamed-chunk-13-1.png" width="80%" />

We can see that the data point corresponding to the average of the measurements of the samplegroup 17 is plotted in red because it is outside of the control limits.

Now we plot the R chart to assess the variability:


```r
syringe_R <- qcc(
  data = syringe_clean[1:10, ],
  newdata = syringe_clean[11:25,], 
  type = "R", 
  title = "Lamp weight \n R chart",
  xlab = "Sample group"
  )
```

<img src="10_spc_files/figure-html/unnamed-chunk-14-1.png" width="80%" />

In this case all the points are within the previously defined control limits.

<b>Warnings and specification limits</b>

More tight controls can be put in place by clearly identifying warning limits in a narrower range than the control limits. These measures need to be accompaigned by clear decision criteria and proper training to avoid the typical problem of overeacting and destabilizing the process by introducing unintented special causes of variation.

### Control limits {#limits.xbar}

We add warning limits in the plot with as follows:


```r
warn.limits <- limits.xbar(
  syringe_xbar$center, 
  syringe_xbar$std.dev, 
  syringe_xbar$sizes, 
  2
  )
plot(
  syringe_xbar, 
  restore.par = FALSE,
  title = "Lamp weight \n xbar chart",
  xlab = "Sample group")
abline(h = warn.limits, lty = 3, col = "chocolate")
```

<img src="10_spc_files/figure-html/unnamed-chunk-15-1.png" width="80%" />

A manufacturing process under control has a variation that is lower than the product specifications and ideally it is centered. Therefore it is usually good practice to follow the control chart rules refering to the process control limits. 

In some cases nevertheless there may be desired or interesting to add the specification limits. This can be done as follows, first we establish the specifications:


```r
spec_max <- 5.6
spec_min <- 5.3
spec_tgt <- (spec_max - spec_min) / 2 + spec_min
specs <- c(spec_min, spec_tgt, spec_max)
```

and replot the control chart with visible specification limits and targets:


```r
plot(
  syringe_xbar,
  restore.par = FALSE,
  title = "Lamp weight \n xbar chart",
  xlab = "Sample group",
  ylim = c(specs[1], specs[3])
  )
abline(h = specs, lty = 3, col = "red")
```

<img src="10_spc_files/figure-html/unnamed-chunk-17-1.png" width="80%" />

In the previous example we see a situation that happens in practice and that requires action: the data plotted is still within the min max specification limits for this relativelly small number of data points. Furthermore the variation is overall well contained within the process limits. Nevertheless we see it is extremelly off centered when compared with the product specification. A process capability study should help determining the causes for this offcentering and help correcting it.

Adapted from @Bass2007

In this chapter we're going to go more in depth in the study of the manufacturing process variability. We're going to make a comparison between the product specifications and the process variability. We're looking for opportunities to tigthen the product specifications. 
Tightening a product specification without increasing the cost of a manufacturing cost can be a source of competitive advantage.

## Cpk charts

### Off specification {#off_spec}


```r
syringe_long <- syringe_diameter %>%
  pivot_longer(cols = starts_with("Sample"),
               names_to = "sample",
               values_to = "value")
```

**variables**


```r
syringe_mean = syringe_long %>% pull(value) %>% mean()
syringe_sd = syringe_long %>% pull(value) %>% sd()
syringe_n <- length(syringe_long)
theor_n = 1000000
```

**calculation: probability of being between the limits**


```r
off_spec <- function(UCL, LCL, mean, sd) {
  round(100 - ((stats::pnorm(UCL, mean, sd) - stats::pnorm(LCL, mean, sd))*100), 2)
}
```


```r
syringe_off_spec <- off_spec(spec_max, spec_min, syringe_mean, syringe_sd)
```


```r
syringe_theor <- rnorm(n = theor_n, mean = syringe_mean, sd = syringe_sd) %>% 
  as_tibble()
```


```r
plot_subtitle <- paste(
  "Spec: [", spec_min, ";", spec_max, 
  "], Proportion off-spec = ",
  signif(syringe_off_spec, digits = 2), "%"
  )
```

Note that we deliberately twick the plot colors to make it look like the plots from minitab and from the qcc package. We provide this theme in the book companion package `industRial` with the name theme_qcc. 


```r
syringe_long %>%
  ggplot(aes(x = value, y = ..density..)) +
  geom_histogram(
    bins = 30,
    fill = "white",
    color = "grey20") +
  geom_density(data = syringe_theor, linetype = 2) +
  geom_vline(xintercept = {spec_min}, color = "red", linetype = 3) +
  geom_vline(xintercept = {spec_max}, color = "red", linetype = 3) +
  geom_vline(xintercept = {spec_tgt}, color = "red", linetype = 2) +
  scale_x_continuous(n.breaks = 10) +
  theme_qcc() +
  labs(
    title = "Out of specification (Expected)", 
    subtitle = {plot_subtitle})
```

<img src="10_spc_files/figure-html/unnamed-chunk-24-1.png" width="80%" />

By looking at the histogram of the Bamako lightning dataset we confirm the extreme offcentering of the production. We also see that although there are no measurements beyond the lower specification limit (LSL) it is very likely this will happen soon.

We can also calculate the Cpk

### Process Capability {#process_Cpk}


```r
process_Cpk <- function(UCL, LCL, mean, sd) {
  pmin(
    (abs(mean - abs(LCL)) / (3 * sd)),
    (abs((abs(UCL) - mean)) / (3 * sd))
   )
}
```


```r
process_Cpk(spec_max, spec_min, syringe_mean, syringe_sd)
```

```
[1] 0.7158694
```

And convert the percentage out of spec in parts per million. We're not considering the 1.5 shift that sometimes is presented in the literature but rather making a simple direct conversion of the proportion out of spec found before:


```r
formatC(((syringe_off_spec) * 10000), format = "d", big.mark = "'")
```

```
[1] "15'900"
```

The expected population below the LSL is 1,3% which is very high for industry standards. In fact this corresponds to 15'900 parts per million (ppm) whereas a common target would be 1 ppm. Naturally these figures are indicative and they depend of the context criteria such as severity of the problem, cost, difficulty to eliminate the problem and so on. 

We can now establish a simple table using the functions created before, to present the expected percentage that falls within certain limits. To make it useful as a reference table we're putting this limits from $\pm$ 1 to $\pm$ 6 standard deviations

### Sigma conversion table {#sigma_table}


```r
sigma_limits <- tibble(
  sigma_plus = c(1, 2, 3, 4, 5, 6),
  sigma_minus = -sigma_plus,
  mean = 0,
  sd = 1
)

sigma_limits %>%
  mutate(
    off_spec_perc = off_spec(sigma_plus, sigma_minus, mean, sd),
    Cpk = process_Cpk(sigma_plus, sigma_minus, mean, sd),
    ppm_defects = formatC(
      off_spec(sigma_plus, sigma_minus, mean, sd) * 10000,
      format = "d",
      big.mark = "'")) %>%
  select(sigma_minus, sigma_plus, off_spec_perc, Cpk, ppm_defects) %>%
  kable(align = "c", digits = 2)
```



| sigma_minus | sigma_plus | off_spec_perc | Cpk  | ppm_defects |
|:-----------:|:----------:|:-------------:|:----:|:-----------:|
|     -1      |     1      |     31.73     | 0.33 |   317'300   |
|     -2      |     2      |     4.55      | 0.67 |   45'500    |
|     -3      |     3      |     0.27      | 1.00 |    2'700    |
|     -4      |     4      |     0.01      | 1.33 |     100     |
|     -5      |     5      |     0.00      | 1.67 |      0      |
|     -6      |     6      |     0.00      | 2.00 |      0      |

### Capability chart {#process.capability}




```r
syringe_cpk <- process.capability(
  syringe_xbar,
  breaks = 10,
  spec.limits = c(spec_min, spec_max),
  target = spec_tgt,
  digits = 2,
  print = FALSE,
  std.dev = syringe_sd
)
```

<img src="10_spc_files/figure-html/unnamed-chunk-30-1.png" width="80%" />

A fine tuning of the forecast of the number of expected parts out of specification can be done with the parameter std.dev. The input value will be used in the probability distribution function. Different approaches can be considered: calculating the sandard deviation within each subgroup or the standard deviation of the entire population and also correcting the standard deviation dividing by n or by n - 1. In this example we re-use the standard deviation calculated on the entire set of datapoints as the group is small but for a case with more data it would be interesting to used the subgroups that tend to give smaller standard deviations.

## I-MR charts

In this final chapter we're exploring the development of custom functions for summary statistics and timeseries plotting. All these functions are available on the book companion package `{industRial}` for exploration and further development. They don't pretend to be used as such for real life applications. For that we recommend the functions from the package `{QCC}` presented before. The objective here is to show a workflow and demonstrate some possibilities that the `{tidyverse}` offers to make completely customized functions.

To encourage this exploration we're not presenting here the complete code for each function but propose to check it with the R functionality for function code exploration. We see often the recommendation to read R source code and we can only support it as an excellent way to develop our skilset.

Lets start with the simple function that calculates the percentage of parts out of specification given the specification limits, the process mean and standard deviation. This function was presented in the previous case study and since it is loaded in memory we can read its content with the R function body():


```r
body(off_spec)
```

```
{
    round(100 - ((stats::pnorm(UCL, mean, sd) - stats::pnorm(LCL, 
        mean, sd)) * 100), 2)
}
```

we can see that it uses simple functions from the package {`stats}`. We can also explicitly request to see the arguments it takes with formals():


```r
dput(formals(off_spec))
```

```
as.pairlist(alist(UCL = , LCL = , mean = , sd = ))
```

and for a complete review we can open the function help page with:

```{}
?off_spec
```

Lets give some data and use the function:


```r
off_spec(0.981, 0.819, 0.943, 0.019)
```

```
[1] 2.28
```

we get 2.28% parts out of spec. We'll see this calculation in action in a moment.

### Process statistics {#process_stats}

**The tablet weight control procedure**


```r
tablet_weight <- tablet_weight %>%
    janitor::clean_names(case = "snake")
```

We're now going to use the function process stats to calculate several statistical data for this dataset. As mentionned we encourage the reader to explore the code with body(process_stats) and dput(formals(process_stats)) as there is a wealth of details in how to calculate process control limits, moving ranges and the like.


```r
weight_statistics_data <- process_stats(tablet_weight, 10)
```

this being done we can now convert this data into an easy readable format for reporting of for a future integration in a shiny app for example. We're exploring the package `{gt}` that has a specific very neat look rather different from the `{kable}` package used in most of the book. 


```r
process_stats_table(weight_statistics_data)
```

```{=html}
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#wnlwsejqlq .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#wnlwsejqlq .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#wnlwsejqlq .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#wnlwsejqlq .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#wnlwsejqlq .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#wnlwsejqlq .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#wnlwsejqlq .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#wnlwsejqlq .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#wnlwsejqlq .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#wnlwsejqlq .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#wnlwsejqlq .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#wnlwsejqlq .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#wnlwsejqlq .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#wnlwsejqlq .gt_from_md > :first-child {
  margin-top: 0;
}

#wnlwsejqlq .gt_from_md > :last-child {
  margin-bottom: 0;
}

#wnlwsejqlq .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#wnlwsejqlq .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#wnlwsejqlq .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#wnlwsejqlq .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#wnlwsejqlq .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#wnlwsejqlq .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#wnlwsejqlq .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#wnlwsejqlq .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#wnlwsejqlq .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#wnlwsejqlq .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#wnlwsejqlq .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#wnlwsejqlq .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#wnlwsejqlq .gt_left {
  text-align: left;
}

#wnlwsejqlq .gt_center {
  text-align: center;
}

#wnlwsejqlq .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#wnlwsejqlq .gt_font_normal {
  font-weight: normal;
}

#wnlwsejqlq .gt_font_bold {
  font-weight: bold;
}

#wnlwsejqlq .gt_font_italic {
  font-style: italic;
}

#wnlwsejqlq .gt_super {
  font-size: 65%;
}

#wnlwsejqlq .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="wnlwsejqlq" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;"><table class="gt_table">
  <thead class="gt_header">
    <tr>
      <th colspan="3" class="gt_heading gt_title gt_font_normal" style>Process Summary Statistics</th>
    </tr>
    <tr>
      <th colspan="3" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style></th>
    </tr>
  </thead>
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Variable</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">Value</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">Unit</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr>
      <td class="gt_row gt_left">Weight mean</td>
      <td class="gt_row gt_right">0.9400000</td>
      <td class="gt_row gt_left">g</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">Spec target</td>
      <td class="gt_row gt_right">0.9000000</td>
      <td class="gt_row gt_left">g</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">Spec min</td>
      <td class="gt_row gt_right">0.8100000</td>
      <td class="gt_row gt_left">g</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">Spec max</td>
      <td class="gt_row gt_right">0.9900000</td>
      <td class="gt_row gt_left">g</td>
    </tr>
    <tr>
      <td class="gt_row gt_left" style="font-weight: bold;">Out of spec</td>
      <td class="gt_row gt_right" style="font-weight: bold;">0.7100000</td>
      <td class="gt_row gt_left" style="font-weight: bold;">%</td>
    </tr>
    <tr>
      <td class="gt_row gt_left" style="font-weight: bold;">Cpk</td>
      <td class="gt_row gt_right" style="font-weight: bold;">0.8178525</td>
      <td class="gt_row gt_left" style="font-weight: bold;"></td>
    </tr>
    <tr>
      <td class="gt_row gt_left">Sample size</td>
      <td class="gt_row gt_right">137</td>
      <td class="gt_row gt_left">parts</td>
    </tr>
  </tbody>
  
  
</table></div>
```

### Individual chart {#chart_I}

The data set being available we're feeding it into the chart_I() function:


```r
chart_I(weight_statistics_data)
```

<img src="10_spc_files/figure-html/unnamed-chunk-37-1.png" width="80%" />

### Moving range chart {#chart_IMR}

The companion of the I chart is the MR chart, where MR stands for moving range. This chart can be called with:


```r
chart_IMR(weight_statistics_data)
```

<img src="10_spc_files/figure-html/unnamed-chunk-38-1.png" width="80%" />

### Capability chart (custom) {#chart_Cpk}

And a final chart for this session the capability chart:


```r
chart_Cpk(weight_statistics_data)
```

<img src="10_spc_files/figure-html/unnamed-chunk-39-1.png" width="80%" />


