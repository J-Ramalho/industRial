# R Toolbox

## R programming

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




```r
library(tidyverse)
library(readxl)
library(knitr)
library(qcc)
filter <- dplyr::filter
select <- dplyr::select
```

## R Datasets

All examples presented throughout the book are published either fully anonymized or the with the original entities authorization and reference. All datasets are made available for further exploration. The books original datasets are available in the books github repository. Instructions for downloading them are presented specifically for each dataset, the general approach is described below.

Get from github the book companion package:

```
devtools::install_github("J-Ramalho/industRial")
```

Datasets become immediatly available by invoking the package name and the dataset, e.g.:


```r
head(industRial::dial_control)
```

```
  Operator       Date  Defect Location
1     Jane 2018.01.31  Indent       3h
2     Jane 2018.02.02  Indent       3h
3     Jane 2018.02.02  Indent       4h
4    Peter 2018.02.02  Indent      10h
5     Jane 2018.02.03 Scratch       3h
6     Jane 2018.02.03  Indent       3h
```

If repetitive use is required then it is best to directly load the package in the current session:


```r
library(industRial)
```

as the package is loaded the dataset is in memory and ready to go, e.g.:


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

## R Packages

All tools applied throughout this book are available in the form of packages of the programming language R. They're all available for downloaded at no cost.

In all sections packages are loaded as they become needed. We've prefered this approach instead of a grouped loading in the begining of the chapter because this helps reminding which package the functions come from. 

When needed we also present code required to handle the masking of functions with the same name from those different packages. In the example below the filter and select functions are made explicit to avoid having them masked by the stats package in case it has been loaded before.

### Industrial packages

#### industRial

The `{industRial}` package is an original companion package developed for this book that besides containing the datasets from all cases has varied functions to print and customise the aesthetics of spc charts. They're built on top of the tidyverse package. They aim for an easier modification of the control chart rules and customisation of the plot aesthetics when compared with other more advanced packages for spc such as the qcc. The industRial package can be simply downloaded from github with the following command:

```{}
devtools::install_github("J-Ramalho/industRial")
```

#### six sigma

SixSigma is a very complete and robust package by Emilio L.Cano [@Cano2015]. It provides well many well tested functions in the area of quality management.

#### qcc

qcc is another extremely complete and solid package. It was developped and is maintained by Luca Scrucca and offers a very large range of statistical process control charts and capability analysis. Short examples in its vignette: [qcc vignette](https://luca-scr.github.io/qcc/articles/qcc.html)

#### qicharts2

I recommend qichart2 specifically for the nice pareto plots. As many niche packages we need to be awere that the number of contributers is small meaning that it cannot be as thouroughly tested as community packages.

#### DoE.base

This package is one of the most complete and vast packages in Design of Experiements. It is a first of a large suite of packages on the topic, it has vast functionality and is extremely well documented.

[DoE.base](http://prof.beuth-hochschule.de/groemping/software/doe/?L=1&print=1)

### All purpose packages

The amount of packages available is extremely large and growing very fast. When selecting new packages it is recommended to check the latest package update. Packages that have had no improvements since more than a couple of years should be questionned. The field evolves rapidly and compatibility and other issues can become painfull. A way to obtain statistics on package history is on [metacran](https://www.r-pkg.org/) or [RStudio package manager](https://packagemanager.rstudio.com/). 

Below a comprehensive list of the different packages used in the book:


```r
installed_packages <- bind_rows(
  installed.packages(lib.loc = .Library) %>% as_tibble(),
  installed.packages(lib.loc = "/home/joao/R/x86_64-pc-linux-gnu-library/4.0/") %>% 
    as_tibble()
)

recommended_packages <- read_excel("data/rpackages.xlsx") %>%
  filter(Used == "y") %>%
  left_join(installed_packages) %>%
  select(Package, Area, Version) %>%
  arrange(Area)

recommended_packages %>%
  kable()
```



|Package     |Area                   |Version |
|:-----------|:----------------------|:-------|
|rcartocolor |colors                 |2.0.0   |
|viridis     |colors                 |0.5.1   |
|datasets    |data                   |4.0.5   |
|readr       |data loading           |1.4.0   |
|readxl      |data loading           |1.3.1   |
|dplyr       |data science           |1.0.4   |
|forcats     |data science           |0.5.1   |
|hms         |data science           |1.0.0   |
|janitor     |data science           |2.1.0   |
|lubridate   |data science           |1.7.9.2 |
|magrittr    |data science           |2.0.1   |
|tibble      |data science           |3.1.0   |
|tidyr       |data science           |1.1.2   |
|broom       |datascience            |0.7.4   |
|tidyverse   |datascience            |1.3.0   |
|purrr       |functional programming |0.3.4   |
|qicharts2   |industrial stats       |0.7.1   |
|qcc         |industrial stats       |2.7     |
|SixSigma    |industrial stats       |0.9-52  |
|DoE.base    |industrial stats       |1.1-6   |
|patchwork   |plotting               |1.1.1   |
|ggplot2     |plotting               |3.3.3   |
|scales      |plotting               |1.1.1   |
|bookdown    |publishing             |0.21    |
|knitr       |publishing             |1.31    |
|stats       |statistics             |4.0.5   |
|tidymodels  |statistics             |0.1.2   |
|agricolae   |statistics             |1.3-3   |
|car         |statistics             |3.0-10  |
|RcmdrMisc   |statistics             |2.7-1   |
|lsr         |statistics             |0.5     |
|fs          |sysadmin               |1.5.0   |
|glue        |text                   |1.4.2   |
|stringr     |text                   |1.4.0   |

### Publishing packages

This book has been written using the R package `{Bookdown}` from @Xie2016 further customized with a layout developped by [Matthew J. C. Crump](https://community.rstudio.com/t/bookdown-contest-submission-gitbook-style-tufte-style-for-web-book/11666). Plot themes have been adapted from the package `{cowplot}` by Claus O.Wilke.

## R Session

An important aspect to ensure reproducibility of the examples along the time and between users is to have the same programming setup. We're showing below our setup at the time of rendering the book. 


```r
devtools::session_info()[[1]]
```

```
 setting  value                       
 version  R version 4.0.5 (2021-03-31)
 os       Ubuntu 20.04.2 LTS          
 system   x86_64, linux-gnu           
 ui       X11                         
 language (EN)                        
 collate  en_US.UTF-8                 
 ctype    en_US.UTF-8                 
 tz       Europe/Zurich               
 date     2021-05-08                  
```




