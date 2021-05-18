


# (PART) TOOLBOX {-}

# R Packages

Why R? Many tools exist to do Data Analysis and Statistics with different degrees of power and difficulty such as:

* Spreadsheets: Excel, Libreoffice, Numbers
* Proprietary software: Minitab, Mathlab
* Programming languages: Visual Basic, R, Python, Julia
* Databases: sqlite, postgre, mysql, mongodb

Choosing the right set of tools for Data Science is often not a very scientific task. Mostly is a matter of what is available and what our colleagues, customers or suppliers use. As with everything it is important to remain open to evaluate new tools and approaches and even to be able to combine them.

In this book we've chosen to provide all examples in R which is a free software environment for statistical computing and graphics https://www.r-project.org/
Besides taste and personnal preference R brings a significant number of specific advantages in the field of Industrial Data Science:

1. R allows for reproducible research

This because the algorithms and functions defined to make the calculations can be inspected and all results can be fully reproduced and audited. This is known as reproducible research and is a critical aspect in all areas where a proof is needed such as in equipment validation and product quality reporting.

2. R functions, tools and programs can be adapted and improved

Being an open source language, all R libraries and packages added to the basic environment can be not only audited but adapted and improved This is very important as when we enter into details every industry has a slight different way of doing things, different naming conventions, different coeficients and so on.

3. R is extensible

R is compatible with most other software on the market and is an excellent "glue" tool allowing for example for data loading from excel files, producing reports in pdf and even building complete dashboards in the form of web pages. 

All tools applied throughout this book are available in the form of packages of the programming language R. As with all open source code, they're all available for download with freedom to modification and at no cost.

The amount of packages available is extremely large and growing very fast. When selecting new packages it is recommended to check the latest package update. Packages that have had no improvements since more than a couple of years should be questionned. The field evolves rapidly and compatibility and other issues can become painfull. A way to obtain statistics on package history is on [metacran](https://www.r-pkg.org/) or [RStudio package manager](https://packagemanager.rstudio.com/). 

Below a comprehensive list of the different packages used in the book:


|Package     |Area                   |Version |
|:-----------|:----------------------|:-------|
|rcartocolor |colors                 |NA      |
|viridis     |colors                 |0.6.1   |
|datasets    |data                   |4.0.5   |
|readr       |data loading           |1.4.0   |
|readxl      |data loading           |1.3.1   |
|dplyr       |data science           |1.0.6   |
|forcats     |data science           |0.5.1   |
|hms         |data science           |1.0.0   |
|janitor     |data science           |2.1.0   |
|lubridate   |data science           |1.7.10  |
|magrittr    |data science           |2.0.1   |
|tibble      |data science           |3.1.1   |
|tidyr       |data science           |1.1.3   |
|broom       |datascience            |0.7.6   |
|tidyverse   |datascience            |1.3.1   |
|purrr       |functional programming |0.3.4   |
|qicharts2   |industrial stats       |0.7.1   |
|qcc         |industrial stats       |2.7     |
|SixSigma    |industrial stats       |0.9-52  |
|DoE.base    |industrial stats       |1.1-6   |
|patchwork   |plotting               |1.1.1   |
|ggplot2     |plotting               |3.3.3   |
|scales      |plotting               |1.1.1   |
|bookdown    |publishing             |0.22    |
|knitr       |publishing             |1.33    |
|stats       |statistics             |4.0.5   |
|tidymodels  |statistics             |NA      |
|agricolae   |statistics             |1.3-3   |
|car         |statistics             |3.0-10  |
|RcmdrMisc   |statistics             |2.7-1   |
|lsr         |statistics             |NA      |
|fs          |sysadmin               |1.5.0   |
|glue        |text                   |1.4.2   |
|stringr     |text                   |1.4.0   |

Theses packages below are loaded implicitly and not visible in the book text. Be sure to load at minimum the packages below before trying any example:

```{}
ds_pkgs <- c("tidyverse", "scales", "janitor", "knitr", "stats", "industRial",
  "viridis", "broom", "patchwork")
purrr::map(ds_pkgs, library, character.only = TRUE)
```

A common issue in R when compared to python for instance is **function masking**. As we tend to load all the sets of functions from each package we end up with conflicting function names. In the scope of this text it is mostly the function filter() from `{dplyr}` which conflicts with the function with the same name from `{stats}`. We use the most simple technique which is to add `filter <- dplyr::filter` in the beginning of our script to precise which function we want to give priority and we pre-append the package name to all calls of the other function such as `stats::filter`. For more sophisticated ways to handle this issue we suggest the package `{import}`.

We're highlighting now some specific packages that are used in the book and that bring powerful features in analysis of data from R&D and Operations. Wherever they are required in the book they are loaded explicitly so that we know where the functions come from.

## six sigma

SixSigma is a very complete and robust package by Emilio L.Cano [@Cano2015]. It provides well many well tested functions in the area of quality management.

## qcc

qcc is another extremely complete and solid package. It was developped and is maintained by Luca Scrucca and offers a very large range of statistical process control charts and capability analysis. Short examples in its vignette: [qcc vignette](https://luca-scr.github.io/qcc/articles/qcc.html)

## qicharts2

I recommend qichart2 specifically for the nice pareto plots. As many niche packages we need to be awere that the number of contributers is small meaning that it cannot be as thouroughly tested as community packages.

## DoE.base

This package is one of the most complete and vast packages in Design of Experiements. It is a first of a large suite of packages on the topic, it has vast functionality and is extremely well documented.

[DoE.base](http://prof.beuth-hochschule.de/groemping/software/doe/?L=1&print=1)

## car

The Companion for Applied Regression is also used extensively as it contains many usefull functions to assess the performance of linear models and anova. 

# Datasets {#datasets}

An original package with the name `{industRial}` has been developed as a companion package for this book. It can be downloaded from github with the following command:

```{}
devtools::install_github("J-Ramalho/industRial")
```

The primary package goal is to make easily available all the data sets from all case studies. All dataset presented throughout the book are published either fully anonymized. Once the package is correctly installed it can be loaded in the R session as usual with the library() function:

```{}
library(industRial)
```

Once loaded the data sets become immediately available in memory and can directly be used in the examples presented or for further exploration. Lets confirm this invoking the first data set:


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

# Functions {#functions}

Besides the data sets the `{industRial}` package also contains toy functions to plot Statistical Process Control (SPC) charts. The objective here is to showcase how to build such functions and their scope of application is limited to the book case studies. For complete and robust SPC functions we recommend using the `{QCC}` package also described below.

Additionally the package contains theme functions to print and customize the aesthetics of spc charts and other charts. These themes are built on top of the `{ggplot2}` by H.Wickham and `{cowplot}` package by Claus O.Wilke. The main objective is to give the reader a starting point for customization of charts in this domain.

The complete list of datasets, themes and functions can be seen by listing all objects from the package with ls():


```r
ls("package:industRial")
```

```
 [1] "%>%"                 "battery_charging"    "chart_Cpk"          
 [4] "chart_I"             "chart_IMR"           "dial_control"       
 [7] "ebike_hardening"     "ebike_hardening2"    "juice_drymatter"    
[10] "off_spec"            "perfume_experiment"  "pet_delivery"       
[13] "pet_doe"             "process_Cpk"         "process_stats"      
[16] "process_stats_table" "solarcell_fill"      "solarcell_output"   
[19] "syringe_diameter"    "tablet_thickness"    "tablet_weight"      
[22] "theme_industRial"    "theme_qcc"          
```

or conveniently on the console with industRial:: and then tab. For each function a help page is available and can be obtained the same way as any other R data sets, themes and functions with `?<object>` (e.g. ?chart_xbar)

To go even deeper the text book and get access to all the code, the original Rmd files are also bundled in the package and can be seen in the book folder. A way to get the exact path is with:


```r
paste0(.libPaths()[1], "/industRial/book")
```

```
[1] "/home/joao/R/x86_64-pc-linux-gnu-library/4.0/industRial/book"
```

# Tutorials {#tutorials}

A set of practical exercises on key concepts presented throughout this book is available either on the web or locally, instructions follow.

**Run tutorials on the web**

the exercises are published on the shinyapp.io server and can be freely accessed with the links below:

[Pareto charts](https://thoth.shinyapps.io/pareto/)  
This tutorial builds on the *The dial polishing workshop* case study from the Design for Six Sigma chapter, train building pareto charts using the `{qichart2}` package and explore how playing with different variables gives new insights into apparently simple data collections.

[Anova](https://thoth.shinyapps.io/anova/)  
This tutorial explores how the p value is calculated by playing with a dynamic anova chart. This exercise is based on the *The e-bike frame hardening process* of the DOE Interactions chapter.

**Run tutorials locally**

The tutorials can also be run locally which can be convenient as they load faster. This also allows for further exploration as the original tutorial code becomes available.

Install locally the `{industRial}` and `{learnr}` packages, with:

```{}
devtools::install_github("J-Ramalho/industRial")
install.packages("learnr)
```

load the packages:

```{}
library(industRial)
library(learnr)
```

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
```

choose a tutorial and run it as follows:

```{}
learnr::run_tutorial(package = "industRial", "anova")
```

The original files are available in the package tutorials folder. Their names correspond to the tutorial names listed before so there is a simple way to open the desired file, e.g.: 

```{}
rstudioapi::navigateToFile(
  paste0(.libPaths()[1], "/industRial/tutorials/anova/anova.Rmd")
  )
```




