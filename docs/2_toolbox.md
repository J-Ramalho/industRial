

# Toolbox

## R and RStudio

Many tools exist to do Data Analysis and Statistics with different degrees of power and difficulty such as:

-   Spreadsheets: Excel, Libreoffice, Numbers
-   Proprietary software: Minitab, Mathlab
-   Programming languages: Visual Basic, R, Python, Julia
-   Databases: sqlite, postgre, mysql, mongodb

Choosing the right set of tools for Data Science is often not a very scientific task. Mostly is a matter of what is available and what our colleagues, customers or suppliers use. As with everything it is important to remain open to evaluate new tools and approaches and even to be able to combine them.

In this book we've chosen to provide all examples in R which is a free software environment for statistical computing and graphics. Besides taste and personal preference R brings a significant number of specific advantages in the field of Industrial Data Science:

R allows for reproducible research

This because the algorithms and functions defined to make the calculations can be inspected and all results can be fully reproduced and audited. This is known as reproducible research and is a critical aspect in all areas where a proof is needed such as in equipment validation and product quality reporting.

R functions and tools can be audited and improved 

Being an open source language, all R libraries and packages added to the basic environment can be audited, adapted and improved. This is very important because when we enter into details every industry has a slight different way of doing things, different naming conventions, different coeficients and so on.

R is extensible

R is compatible with most other software on the market and is an excellent "glue" tool allowing for example for data loading from excel files, producing reports in pdf and even building complete dashboards in the form of web pages.

Large documentation is available on installing and learning R, starting with the official sites [R-project](https://www.r-project.org/) and [RStudio](https://www.rstudio.com/).

## Packages

All industry specific tools applied throughout this book are available in the form of packages of the programming language R. As with all open source code, they're all available for download with freedom to modification and at no cost.

The amount of packages available is extremely large and growing very fast. When selecting new packages it is recommended to check the latest package update. Packages that have had no improvements since more than a couple of years should be questioned. The field evolves rapidly and compatibility and other issues can become painful. Two ways of obtaining statistics on package history are [metacran](https://www.r-pkg.org/) and [RStudio package manager](https://packagemanager.rstudio.com/).

Additionally an original package named `{industRial}` has been developed as a companion package for this book. 

### Installation {#installation}

The companion package to this book can downloaded from github with the following command:

    devtools::install_github("J-Ramalho/industRial")

The list below identifies which are the remaining packages required to run all the coded of the book examples. Note that it is not required to download them all at once.

The column *Download* precises if a package is downloaded automatically when the `{industRial}` package is downloaded (imports) or if it needs be downloaded manually by the reader (suggests). In technical terms this differentiation corresponds to the DESCRIPTION file and allows for a progressive installation of the required software.


|Download |Package    |Domain           |Version |Depends                                       |
|:--------|:----------|:----------------|:-------|:---------------------------------------------|
|imports  |viridis    |colors           |0.5.1   |R (>= 2.10), viridisLite (>= 0.3.0)           |
|imports  |readr      |data loading     |1.3.1   |R (>= 3.1)                                    |
|imports  |dplyr      |data wrangling   |1.0.2   |R (>= 3.2.0)                                  |
|imports  |forcats    |data wrangling   |0.5.0   |R (>= 3.2)                                    |
|imports  |janitor    |data wrangling   |2.0.1   |R (>= 3.1.2)                                  |
|imports  |magrittr   |data wrangling   |1.5     |NA                                            |
|imports  |tibble     |data wrangling   |3.0.3   |R (>= 3.1.0)                                  |
|imports  |tidyr      |data wrangling   |1.1.1   |R (>= 3.1)                                    |
|imports  |purrr      |data wrangling   |0.3.4   |R (>= 3.2)                                    |
|imports  |glue       |data wrangling   |1.4.1   |R (>= 3.1)                                    |
|imports  |stringr    |data wrangling   |1.4.0   |R (>= 3.1)                                    |
|imports  |patchwork  |plotting         |1.0.1   |NA                                            |
|imports  |ggplot2    |plotting         |3.3.2   |R (>= 3.2)                                    |
|imports  |scales     |plotting         |1.1.1   |R (>= 3.2)                                    |
|imports  |ggtext     |plotting         |0.1.0   |R (>= 3.5)                                    |
|imports  |broom      |statistics       |0.7.0   |R (>= 3.1)                                    |
|imports  |stats      |statistics       |4.0.2   |NA                                            |
|suggests |qicharts2  |industrial stats |0.7.1   |R (>= 3.0.0)                                  |
|suggests |qcc        |industrial stats |2.7     |R (>= 3.0)                                    |
|suggests |SixSigma   |industrial stats |0.9-52  |R (>= 2.14.0)                                 |
|suggests |DoE.base   |industrial stats |1.1-6   |R (>= 2.10), grid, conf.design                |
|suggests |rsm        |industrial stats |2.10.2  |NA                                            |
|suggests |agricolae  |industrial stats |1.3-3   |R (>= 2.10)                                   |
|suggests |ggraph     |networks         |2.0.3   |R (>= 2.10), ggplot2 (>= 3.0.0)               |
|suggests |tidygraph  |networks         |1.2.0   |NA                                            |
|suggests |igraph     |networks         |1.2.5   |methods                                       |
|suggests |ggforce    |networks         |0.3.2   |ggplot2 (>= 3.0.0), R (>= 3.3.0)              |
|suggests |bookdown   |publishing       |0.20    |NA                                            |
|suggests |knitr      |publishing       |1.29    |R (>= 3.2.3)                                  |
|suggests |kableextra |publishing       |NA      |NA                                            |
|suggests |gt         |publishing       |0.2.2   |R (>= 3.2.0)                                  |
|suggests |car        |statistics       |3.0-9   |R (>= 3.5.0), carData (>= 3.0-0)              |
|suggests |RcmdrMisc  |statistics       |2.7-1   |R (>= 3.5.0), utils, car (>= 3.0-0), sandwich |

In the book text we don't see the loading instructions for the installed packages over and over again everytime an example is given to avoid repetition (e.g. running `library(dplyr)` before each code chunk). Be sure to load at minimum the packages below before trying any example:

    ds_pkgs <- c("tidyverse", "scales", "janitor", "knitr", "stats", "industRial",
      "viridis", "broom", "patchwork")
    purrr::map(ds_pkgs, library, character.only = TRUE)

Beware of the common issue of *function masking*. This happens more often in R when compared to python. As we tend to load all the sets of functions from each package we end up with conflicting function names. In the scope of this text it is mostly the function filter() from `{dplyr}` which conflicts with the function with the same name from `{stats}`. We tackle this with the simple technique of adding `filter <- dplyr::filter` in the beginning of our script to precise which function we want to give priority and we pre-append the package name to all calls of the other function such as `stats::filter`. For more sophisticated ways to handle this issue we suggest the package `{import}`.

### Highlights

We're highlighting now some specific packages that are used in the book and that bring powerful features in analysis of data from R&D and Operations. Wherever they are required in the book we loaded them explicitly in the text to help tracking where the specific functions come from.

#### six sigma

`{SixSigma}` is a very complete and robust R package. It provides many well tested functions in the area of quality and process improvement. We're preseting a full example with the gage r&R function in our MSA Case Study. As many other industrial packages, the `{SixSigma}` package is from before the `{tidyverse}` era and its plots have been not been developed with `{ggplot2}`. This makes integration in newer approaches harder. The data output is still nevertheless fully exploitable and very useful. The package is part of an excellent book with the same name published by @Cano2012.

#### qcc

`{qcc}` is another extremely complete and solid package. It was developped and is maintained by Luca Scrucca and offers a very large range of statistical process control charts and capability analysis. This package has started long ago much before the `{tidyverse}` but has made the turn and revamped all its plots with `{ggplot2}`. At the moment of writing this version is not yet in CRAN but can be obtained from github with:

```{}
# install.packages("devtools")
devtools::install_github("luca-scr/qcc", build = TRUE, build_opts = c("--no-resave-data", "--no-manual"))
```

You can find examples of the control charts in its vignette: [qcc vignette](https://luca-scr.github.io/qcc/articles/qcc.html). We build and develop further on our SPC Case Studies.

#### qicharts2

I recommend qichart2 specifically for the nice pareto plots. As many niche packages we need to be awere that the number of contributers is small meaning that it cannot be as thouroughly tested as community packages.

#### DoE.base

This package is one of the most complete and vast packages in Design of Experiements. It is a first of a large suite of packages on the topic, it has vast functionality and is extremely well documented.

[DoE.base](http://prof.beuth-hochschule.de/groemping/software/doe/?L=1&print=1)

#### car

The Companion for Applied Regression is also used extensively as it contains many usefull functions to assess the performance of linear models and anova.

## Datasets {#datasets}

All datasets presented throughout the book are fully anonymized. Once the package is correctly installed it can be loaded in the R session as usual with the library() function.

    devtools::install_github("J-Ramalho/industRial")
    library(industRial)

The primary goal of `{industRial}` is to make easily available all the data sets from all case studies. We can easily look for a data set by typing `industRial::` and tab. The complete list can also be obtained with the snippet below: 


```r
data(package = "industRial") %>%
  pluck("results") %>%
  as_tibble() %>%
  select(Item, Title) %>%
  kable()
```



|Item               |Title                                                                                     |
|:------------------|:-----------------------------------------------------------------------------------------|
|battery_charging   |Charging time of a lithium-ion battery.                                                   |
|dial_control       |Collection of visual defects on watch dial production.                                    |
|ebike_hardening    |Cycles to failure of ebikes frames after temperature treatment.                           |
|ebike_hardening2   |Cycles to failure of ebikes frames after temperature treatment.                           |
|juice_drymatter    |Dry matter content of different juices obtained with two different measurement devices.   |
|perfume_experiment |Correlation matrix of the input variables of an experiment design in perfume formulation. |
|pet_delivery       |Tensile strength values on PET raw material for the clothing industry.                    |
|pet_doe            |A factorial design for the improvement of PET film tensile strength.                      |
|solarcell_fill     |Yearly outputs and fills factor of solarcells of different types.                         |
|solarcell_output   |Yearly outputs of solarcells of different types.                                          |
|syringe_diameter   |Production measurements of the inner diameter of syringes barrels.                        |
|tablet_thickness   |Thickness measurements of pharmaceutical tablets                                          |
|tablet_weight      |Weight measurements of pharmaceutical tablets                                             |

Once the package is loaded the data objects become immediately available in memory and can directly be used in the examples presented or for further exploration. Lets confirm this invoking the first data set:


```r
dial_control %>%
  head() %>%
  kable()
```



|Operator |Date       |Defect  |Location |
|:--------|:----------|:-------|:--------|
|Jane     |2018.01.31 |Indent  |3h       |
|Jane     |2018.02.02 |Indent  |3h       |
|Jane     |2018.02.02 |Indent  |4h       |
|Peter    |2018.02.02 |Indent  |10h      |
|Jane     |2018.02.03 |Scratch |3h       |
|Jane     |2018.02.03 |Indent  |3h       |

The dateset can be used and manipulated like any other dataset created in the session or loaded otherwise. For example it can be filtered and assigned to a new variable name:


```r
dial_peter <- dial_control %>%
  filter(Operator == "Peter") 
dial_peter %>%
  head(2) %>%
  kable()
```



|Operator |Date       |Defect  |Location |
|:--------|:----------|:-------|:--------|
|Peter    |2018.02.02 |Indent  |10h      |
|Peter    |2018.02.03 |Scratch |4h       |

## Functions {#functions}

Besides the data sets the `{industRial}` package also contains toy functions to plot Statistical Process Control (SPC) charts. The objective here is to showcase how to build such functions and their scope of application is limited to the book case studies. For complete and robust SPC functions we recommend using the `{QCC}` package also described below.

Additionally the package contains theme functions to print and customize the aesthetics of spc charts and other charts. These themes are built on top of the `{ggplot2}` by H.Wickham and `{cowplot}` package by Claus O.Wilke. The main objective is to give the reader a starting point for customization of charts in this domain.

A functions can conveniently be accessed on the console with `industRial::` and then tab. The complete list of themes and functions can be seen with:


```r
lsf.str("package:industRial") %>%
  unclass() %>%
  as_tibble() %>%
  kable()
```



|value               |
|:-------------------|
|chart_Cpk           |
|chart_I             |
|chart_IMR           |
|off_spec            |
|process_Cpk         |
|process_stats       |
|process_stats_table |
|theme_industRial    |
|theme_qcc           |

For each function a help page is available and can be obtained the same way as any other R data sets, themes and functions with `?<object>` (e.g. ?chart_xbar)

To go even deeper and get access to all the code, the original book Rmd files are also bundled in the package and can be seen in the book folder. A way to get the exact folder path is:


```r
paste0(.libPaths()[1], "/industRial/book")
```

```
[1] "C:/R/R-4.0.2/jr_library/industRial/book"
```

# Tutorials {#tutorials}

A set of practical exercises on key concepts presented throughout this book is available either on the web or locally, instructions follow.

<br>

## On the web

the tutorials in the list below are published on the shinyapp.io server and can be freely accessed with the links below:

+------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Topic/Link                                                       | Content                                                                                                                                                                                                                                                                              |
+==================================================================+======================================================================================================================================================================================================================================================================================+
| [Pareto chart](https://j-ramalho.shinyapps.io/pareto/)           | This tutorial builds on the *The dial polishing workshop* case study from the Design for Six Sigma chapter, train building pareto charts using the `{qichart2}` package and explore how playing with different variables gives new insights into apparently simple data collections. |
+------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| [DOE Anova](https://j-ramalho.shinyapps.io/anova/)               | This tutorial explores how the p value is calculated by playing with a dynamic anova chart. This exercise is based on the *The e-bike frame hardening process* of the DOE Interactions chapter.                                                                                      |
+------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| [Response Surface](https://j-ramalho.shinyapps.io/surface/)      | This tutorial tests 3D visualization skills by playing with 3D response surface plots and the related interaction plots using the battery_charging dataset and the `{rsm}` package.                                                                                                  |
+------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| [Process Capability](https://j-ramalho.shinyapps.io/capability/) | In this tutorial we can play with the process centering variability and see how this is translated in the process indicators "percentage out of spec" and Cpk.                                                                                                                       |
+------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

<br><br>

## Locally

The same set of tutorials can also be run locally which can be convenient as they load faster. This also allows for further exploration as the original tutorial code becomes available. For downloading instructions refer to the packages (#installation) session.

Next load the packages:

    library(industRial)
    library(learnr)

and list the tutorials with:


```r
learnr::available_tutorials(package = "industRial")
```

```
Available tutorials:
* industRial
  - anova      : "industRial practice"
  - capability : "industRial practice"
  - pareto     : "industRial practice"
  - surface    : "industRial practice" 
```

choose a tutorial and run it as follows:

    learnr::run_tutorial(package = "industRial", "anova")

The original files are available in the package tutorials folder. Their names correspond to the tutorial names listed before so there is a simple way to open the desired file, e.g.:

    rstudioapi::navigateToFile(
      paste0(.libPaths()[1], "/industRial/tutorials/anova/anova.Rmd")
      )
