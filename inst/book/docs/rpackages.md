

## R Packages

### Installation

All tools applied throughout this book are available in the form of packages of the programming language R. They're all available for downloaded at no cost.

In all sections packages are loaded as they become needed. We've prefered this approach to a grouped loading in the begining of the chapter of the group because it helps linking the package with the functions being used. 

When needed we also present code required to handle the masking of functions with the same name from those different packages. In the example below the filter and select functions are made explicit to avoid having them masked by the stats package in case it has been loaded before.^


```r
library(tidyverse)
library(readxl)
library(knitr)
library(qcc)
filter <- dplyr::filter
select <- dplyr::select
```

### Domain packages

#### six sigma

SixSigma is a very complete and robust package by Emilio L.Cano [@Cano2015]. It provides well many well tested functions in the area of quality management.

#### industRial

industRial is an original package developed for this book that has varied functions to print and customise the aesthetics of spc charts: They're built on top of the tidyverse package. They aim for an easier modification of the control chart rules and customisation of the plot aesthetics when compared with other more advanced packages for spc such as the qcc.

This package also contains the data sets used throughout the book, see session datasets. The industRial package can be simply downloaded from github with the following command:

```{}
devtools::install_github("J-Ramalho/industRial")
```

#### qcc

Qcc is another extremely complete and solid package. It was developped and is maintained by Luca Scrucca and offers a very large range of statistical process control charts and capability analysis. Short examples in its vignette: [qcc vignette](https://luca-scr.github.io/qcc/articles/qcc.html)

#### qicharts2

### Other packages


```r
rpackages <- read_excel("../industRial/data-raw/rpackages.xlsx") %>%
  filter(Used == "y") %>%
  select(Package, Area) %>%
  arrange(Area)
rpackages %>%
  kable()
```



|Package     |Area                   |
|:-----------|:----------------------|
|rcartocolor |colors                 |
|viridis     |colors                 |
|readr       |data loading           |
|readxl      |data loading           |
|dplyr       |data wrangling         |
|forcats     |data wrangling         |
|hms         |data wrangling         |
|janitor     |data wrangling         |
|lubridate   |data wrangling         |
|magrittr    |data wrangling         |
|tibble      |data wrangling         |
|tidyr       |data wrangling         |
|broom       |datascience            |
|tidyverse   |datascience            |
|purrr       |functional programming |
|patchwork   |plotting               |
|ggplot2     |plotting               |
|scales      |plotting               |
|kable       |publishing             |
|bookdown    |publishing             |
|knitr       |publishing             |
|stats       |statistics             |
|tidymodels  |statistics             |
|agricolae   |statistics             |
|car         |statistics             |
|RcmdrMisc   |statistics             |
|lsr         |statistics             |
|fs          |sysadmin               |
|glue        |text                   |
|stringr     |text                   |
|datasets    |training               |
|SixSigma    |NA                     |

## Session info

An important aspect to ensure reproducibility of the examples along time and between users is to have the same programming setup. We're showing below our setup at the time of rendering the book. The list below complements the list of packages presented in the previous session by adding generic data science and system administration packages.


```r
devtools::session_info()
```

```
─ Session info ───────────────────────────────────────────────────────────────
 setting  value                       
 version  R version 4.0.4 (2021-02-15)
 os       Ubuntu 20.04.2 LTS          
 system   x86_64, linux-gnu           
 ui       X11                         
 language (EN)                        
 collate  en_US.UTF-8                 
 ctype    en_US.UTF-8                 
 tz       Europe/Zurich               
 date     2021-03-21                  

─ Packages ───────────────────────────────────────────────────────────────────
 package     * version date       lib source        
 assertthat    0.2.1   2019-03-21 [1] CRAN (R 4.0.3)
 backports     1.2.1   2020-12-09 [1] CRAN (R 4.0.3)
 bookdown      0.21    2020-10-13 [1] CRAN (R 4.0.3)
 broom         0.7.4   2021-01-29 [1] CRAN (R 4.0.3)
 cachem        1.0.3   2021-02-04 [1] CRAN (R 4.0.3)
 callr         3.5.1   2020-10-13 [1] CRAN (R 4.0.3)
 cellranger    1.1.0   2016-07-27 [1] CRAN (R 4.0.3)
 cli           2.3.0   2021-01-31 [1] CRAN (R 4.0.3)
 colorspace    2.0-0   2020-11-11 [1] CRAN (R 4.0.3)
 crayon        1.4.0   2021-01-30 [1] CRAN (R 4.0.3)
 DBI           1.1.1   2021-01-15 [1] CRAN (R 4.0.3)
 dbplyr        2.1.0   2021-02-03 [1] CRAN (R 4.0.3)
 desc          1.2.0   2018-05-01 [1] CRAN (R 4.0.3)
 devtools      2.3.2   2020-09-18 [1] CRAN (R 4.0.3)
 digest        0.6.27  2020-10-24 [1] CRAN (R 4.0.3)
 dplyr       * 1.0.4   2021-02-02 [1] CRAN (R 4.0.3)
 ellipsis      0.3.1   2020-05-15 [1] CRAN (R 4.0.3)
 evaluate      0.14    2019-05-28 [1] CRAN (R 4.0.3)
 fastmap       1.1.0   2021-01-25 [1] CRAN (R 4.0.3)
 forcats     * 0.5.1   2021-01-27 [1] CRAN (R 4.0.3)
 fs            1.5.0   2020-07-31 [1] CRAN (R 4.0.3)
 generics      0.1.0   2020-10-31 [1] CRAN (R 4.0.3)
 ggplot2     * 3.3.3   2020-12-30 [1] CRAN (R 4.0.3)
 glue          1.4.2   2020-08-27 [1] CRAN (R 4.0.3)
 gtable        0.3.0   2019-03-25 [1] CRAN (R 4.0.3)
 haven         2.3.1   2020-06-01 [1] CRAN (R 4.0.3)
 highr         0.8     2019-03-20 [1] CRAN (R 4.0.3)
 hms           1.0.0   2021-01-13 [1] CRAN (R 4.0.3)
 htmltools     0.5.1.1 2021-01-22 [1] CRAN (R 4.0.3)
 httr          1.4.2   2020-07-20 [1] CRAN (R 4.0.3)
 jsonlite      1.7.2   2020-12-09 [1] CRAN (R 4.0.3)
 knitr       * 1.31    2021-01-27 [1] CRAN (R 4.0.3)
 lifecycle     0.2.0   2020-03-06 [1] CRAN (R 4.0.3)
 lubridate     1.7.9.2 2020-11-13 [1] CRAN (R 4.0.3)
 magrittr      2.0.1   2020-11-17 [1] CRAN (R 4.0.3)
 MASS          7.3-53  2020-09-09 [1] CRAN (R 4.0.3)
 memoise       2.0.0   2021-01-26 [1] CRAN (R 4.0.3)
 modelr        0.1.8   2020-05-19 [1] CRAN (R 4.0.3)
 munsell       0.5.0   2018-06-12 [1] CRAN (R 4.0.3)
 pillar        1.4.7   2020-11-20 [1] CRAN (R 4.0.3)
 pkgbuild      1.2.0   2020-12-15 [1] CRAN (R 4.0.3)
 pkgconfig     2.0.3   2019-09-22 [1] CRAN (R 4.0.3)
 pkgload       1.1.0   2020-05-29 [1] CRAN (R 4.0.3)
 prettyunits   1.1.1   2020-01-24 [1] CRAN (R 4.0.3)
 processx      3.4.5   2020-11-30 [1] CRAN (R 4.0.3)
 ps            1.5.0   2020-12-05 [1] CRAN (R 4.0.3)
 purrr       * 0.3.4   2020-04-17 [1] CRAN (R 4.0.3)
 qcc         * 2.7     2017-07-11 [1] CRAN (R 4.0.3)
 R6            2.5.0   2020-10-28 [1] CRAN (R 4.0.3)
 Rcpp          1.0.6   2021-01-15 [1] CRAN (R 4.0.3)
 readr       * 1.4.0   2020-10-05 [1] CRAN (R 4.0.3)
 readxl      * 1.3.1   2019-03-13 [1] CRAN (R 4.0.3)
 remotes       2.2.0   2020-07-21 [1] CRAN (R 4.0.3)
 reprex        1.0.0   2021-01-27 [1] CRAN (R 4.0.3)
 rlang         0.4.10  2020-12-30 [1] CRAN (R 4.0.3)
 rmarkdown     2.6     2020-12-14 [1] CRAN (R 4.0.3)
 rprojroot     2.0.2   2020-11-15 [1] CRAN (R 4.0.3)
 rstudioapi    0.13    2020-11-12 [1] CRAN (R 4.0.3)
 rvest         0.3.6   2020-07-25 [1] CRAN (R 4.0.3)
 scales        1.1.1   2020-05-11 [1] CRAN (R 4.0.3)
 sessioninfo   1.1.1   2018-11-05 [1] CRAN (R 4.0.3)
 stringi       1.5.3   2020-09-09 [1] CRAN (R 4.0.3)
 stringr     * 1.4.0   2019-02-10 [1] CRAN (R 4.0.3)
 testthat      3.0.1   2020-12-17 [1] CRAN (R 4.0.3)
 tibble      * 3.0.6   2021-01-29 [1] CRAN (R 4.0.3)
 tidyr       * 1.1.2   2020-08-27 [1] CRAN (R 4.0.3)
 tidyselect    1.1.0   2020-05-11 [1] CRAN (R 4.0.3)
 tidyverse   * 1.3.0   2019-11-21 [1] CRAN (R 4.0.3)
 usethis       2.0.0   2020-12-10 [1] CRAN (R 4.0.3)
 vctrs         0.3.6   2020-12-17 [1] CRAN (R 4.0.3)
 withr         2.4.1   2021-01-26 [1] CRAN (R 4.0.3)
 xfun          0.20    2021-01-06 [1] CRAN (R 4.0.3)
 xml2          1.3.2   2020-04-23 [1] CRAN (R 4.0.3)
 yaml          2.2.1   2020-02-01 [1] CRAN (R 4.0.3)

[1] /home/joao/R/x86_64-pc-linux-gnu-library/4.0
[2] /usr/local/lib/R/site-library
[3] /usr/lib/R/site-library
[4] /usr/lib/R/library
```





