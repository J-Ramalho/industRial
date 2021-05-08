

# Foundations

In this book it is assumed that the reader is already familiar with the product development and manufacturing quality methodologies such as dmaic and six sigma and the associated statistical concepts. Furthermore it is considered that he brings at least a beginner knowledge on R. The book focus is then on putting the different areas together.

### Six Sigma

Below a selection of Six Sigma tools relevant for our case studies and describing how they can help framing the data analysis presented throughout the rest of book. These tools support the Design for Six Sigma methodology that links the features of a product with its production process. One way of summarising the Six Sigma framework is the following:

Voice of Customer

1. Product attributes
2. Functional analysis
3. Functional requirements
4. Failure modes and effects analysis (FMEA)
5. Product parts drawings

Voice of Process

1. Equipement drawings
2. Process mapping
3. Process FMEA
4. Control plan
5. Measurement system analysis
6. Process capability

Each of this steps comprises important analyis of the product and process characteristics. For a more detailed description we recommend reviewing the comprehensive Six Sigma certification reference book by @Munro2015.

### Statistics

The key statistical concepts used throughout this book are listed below:

**Descriptive statistics**

-   mean
-   median
-   mode
-   variance
-   standard deviation
-   range

**Modeling data distributions**

-   Normal distribution
-   Central limit theorem
-   Confidence intervals
-   Linear Models

**Significance tests**

-   comparing means
-   comparing variances
-   linear models
-   Anova
-   Ancova

For a deep and comprehensive course on statistics we recommend the free online [kahn academy](https://www.khanacademy.org/math/statistics-probability) courses.

### R programming

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

When selecting new packages it is recommended to check the latest package update. Packages that have had no improvements since more than a couple of years should be questionned. The field evolves rapidly and compatibility and other issues can become painfull. A way to obtain statistics on package history is on [metacran](https://www.r-pkg.org/). A comprehensive list of the different packages used in the book and how to obtain them is available in the toolbox chapter. 

This book has been entirely written with the excellent R package Bookdown from Yihui Xie [@Xie2016], that has the ability of automatically generate reports with plots and text together.


