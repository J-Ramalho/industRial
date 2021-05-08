

# Foundations

In this book it is assumed that the reader is already familiar with the product development and manufacturing quality methodologies such as dmaic and six sigma and the associated statistical concepts. Furthermore it is considered that he brings at least a beginner knowledge on R. The book focus is then on putting the different areas together.

## Six Sigma

Quality tools have been grouped under varied names and methodologies being Six Sigma one of the most comprehensives ones. One way of summarising the Six Sigma framework is presented below in a step by step approach with definitions. Each of this steps comprises important analyis of the product development and production process steps and puts in everything in context.

For a more detailed description we recommend reviewing the comprehensive Six Sigma certification reference book by @Munro2015.

### Voice of Customer

**1. Product attributes**

**2. Functional analysis**

**3. Functional requirements**

**4. Failure modes and effects analysis (FMEA)**
List of critical product features with failure causes, effects, detection and action plans, rated and sorted by criticality.

**5. Product parts drawings**

### Voice of Process

**1. Equipement drawings**  
Technical drawings of the parts including manufacturing dimensions and tolerances.

**2. Process mapping**  
A visual diagram of the production process with inputs and outputs for each step.

**3. Process FMEA**
List of critical production process steps with failure causes, effects, detection and action plans, rated and sorted by criticality.

**4. Quality Control plan**
List of control points including measurement method, sample size, frequency and acceptance criteria. When needed, critical control points are handled by Statistical Process Control (SPC)

**5. Measurement system analysis**
A thorough assessment of a measurement process, and typically includes a specially designed experiment that seeks to identify the components of variation in that measurement process. 

**6. Process capability analysis**
Comparison of the variability of a production process with its engineered specifications.


## Statistics

Statistic concepts are picked up and applied throught the Cases Studies on a needed basis. To get a better understanding of how they fit together we are reminding below some definitions coming from @Yakir2011. For a deep and comprehensive course on statistics we recommend the free online [kahn academy](https://www.khanacademy.org/math/statistics-probability) courses.

### Descriptive statistics

**Statistic:** A numerical characteristic of the data. A statistic estimates the
corresponding population parameter.  

**Population:** The collection, or set, of all individuals, objects, or measurements whose properties are being studied.

**Sample:** A portion of the population understudy. A sample is representative
if it characterizes the population being studied.

**Frequency:** The number of times a value occurs in the data.

**Relative Frequency:** The ratio between the frequency and the size of data. $f / n$

**Median:** A number that separates ordered data into halves.

**Mean:** A number that measures the central tendency. A common name for
mean is ‘average.’ 

**Sample size:** $n$

**Sample mean:** $\bar{x} = \frac{1}{n}\sum_{i=1}^{n}x_i = \sum_{x}(x\times f_x / n)$

**Population size:** $N$

**Population mean:** $\bar{\mu} = \frac{\sum_{i=1}^{N}x_i}{N}$

**Variance:** Mean of the squared deviations from the mean. 

**Sample variance:** $s^{2} = \frac{1}{n-1}\sum_{i=1}^{n}(x_i-\bar{x})^2 = \frac{n}{n-1}\sum_{x}((x-\bar{x})^2\times(f_x/n))$

**Standard Deviation**: A number that is equal to the square root of the variance and measures how far data values are from their mean.

**Sample standard deviation:** $\sqrt[]{s^{2}}$

### Probability

**Random Variable:** The probabilistic model for the value of a measurement,
before the measurement is taken (e.g. Binomial, Poisson, Uniform, Exponential, Normal). It is denoted with latin capitals $X, Y$ and $Z$

**Expectation:** The central value for a random variable. The expectation of the
random variable X is marked by E($X$).

**Variance:** The (squared) spread of a random variable. The variance of the
random variable X is marked by Var($X$).

**Normal Random Variable:** A bell-shaped distribution that is frequently used
to model a measurement. The distribution is marked with Normal($\mu,\sigma^2$).

**Standard Normal Distribution:** The Normal(0,1). The distribution of stan-
dardized Normal measurement.

**Percentile:** Given a percent p · 100% (or a probability p), the value x is the
percentile of a random variable X if it satisfies the equation P$(X ≤ x) = p$.

**Sampling distribution**

**Random Sample:** The probabilistic model for the values of a measurements
in the sample, before the measurement is taken.

**Sampling Distribution:** The distribution of a random sample.

**Sampling Distribution of a Statistic:** A statistic is a function of the data;
i.e. a formula applied to the data. The statistic becomes a random variable
when the formula is applied to a random sample. The distribution of this
random variable, which is inherited from the distribution of the sample,
is its sampling distribution.

**Sampling Distribution of the Sample Average:** The distribution of the sample average, considered as a random variable.

**The Law of Large Numbers:** A mathematical result regarding the sampling
distribution of the sample average. States that the distribution of the av-
erage of measurements is highly concentrated in the vicinity of the expec-
tation of a measurement when the sample size is large.

**The Central Limit Theorem:** A mathematical result regarding the sampling
distribution of the sample average. States that the distribution of the average is approximately Normal when the sample size is large.

<div class="marginnote">
(note: the central limit theorem is a key notion for understanding industrial measurement and its consequences will be applied in most case studies)
</div>

**Expectation of the sample average:** the expectation of the sample mean is
equal to the theoretical expectation of its components E$(\bar{X})$ = E($X$)

**Variance of the sample average:** the variance of the sample average
is equal to the variance of each of the components, divided by the sample size Var($X$) = Var$(X)/n$

### Statistical Inference

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

### Design of experiments

Below key definitions from @Montgomery2012.

**Factorial design:** in each complete trial or replicate of the experiment all possible combinations of the levels of the factors are investigated.

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




