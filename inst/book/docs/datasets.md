

# Datasets

All examples presented throughout the book are published either fully anonymized or the with the original entities authorization and reference. All datasets are made available for further exploration. The books original datasets are available in the books github repository. Instructions for downloading them are presented specifically for each dataset, the general approach is described below.

Get the book companion package from github:

```
devtools::install_github("J-Ramalho/industRial")
```

Datasets become immediatly available by invoking the package name and the dataset, e.g.:


```r
head(industRial::dial_control)
```

```
  Operator       Date  Defect Location
1     Jane 2018.01.31  Indent        3
2     Jane 2018.02.02  Indent        3
3     Jane 2018.02.02  Indent        4
4    Peter 2018.02.02  Indent       10
5     Jane 2018.02.03 Scratch        3
6     Jane 2018.02.03  Indent        3
```

If repetitive use is required then it is best to directly load the package in the current session:


```r
library(industRial)
```

and load any other packages needed for the data handling, e.g.:


```r
library(dplyr)
library(knitr)
```

as the package is loaded the dataset is in memory and ready to go, e.g.:


```r
dial_control %>%
  head() %>%
  kable()
```



|Operator |Date       |Defect  | Location|
|:--------|:----------|:-------|--------:|
|Jane     |2018.01.31 |Indent  |        3|
|Jane     |2018.02.02 |Indent  |        3|
|Jane     |2018.02.02 |Indent  |        4|
|Peter    |2018.02.02 |Indent  |       10|
|Jane     |2018.02.03 |Scratch |        3|
|Jane     |2018.02.03 |Indent  |        3|

The dateset can be used and manipulated like any other dataset created in the session or loaded otherwise. For example it can be filtered and assigned to a new variable name:


```r
dial_peter <- dial_control %>%
  filter(Operator == "Peter") 
dial_peter %>%
  head(2) %>%
  kable()
```



|Operator |Date       |Defect  | Location|
|:--------|:----------|:-------|--------:|
|Peter    |2018.02.02 |Indent  |       10|
|Peter    |2018.02.03 |Scratch |        4|





