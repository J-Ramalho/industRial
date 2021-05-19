

# (PART) APPENDIX {-}

# Glossary {#glossary}

## Statistics

Statistic concepts are picked up and applied throught the Cases Studies on a needed basis. To get a better understanding of how they fit together we are reminding below some definitions coming from @Yakir2011. For a deep and comprehensive course on statistics we recommend the free online [kahn academy](https://www.khanacademy.org/math/statistics-probability) courses.

### Notation conventions

The arithmetic mean of a series of values x1, x2, ..., xn is often denoted by placing an "overbar" over the symbol, e.g. $\bar{x}$ , pronounced "x bar".

Some commonly used symbols for sample statistics are: sample mean $\bar{x}$, sample standard deviation s.

Some commonly used symbols for population parameters: population mean μ, population standard deviation σ.

Random variables are usually written in upper case roman letters: $X, Y$, etc.

Particular realizations of a random variable are written in corresponding lower case letters. For example, x1, x2, …, xn could be a sample corresponding to the random variable $X$. A cumulative probability is formally written P($X$≤x) to differentiate the random variable from its realization.

Greek letters (e.g. θ, β) are commonly used to denote unknown parameters (population parameters).

Placing a hat, or caret, over a true parameter denotes an estimator of it, e.g., $\hat{θ}$ is an estimator for θ.

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

**Statistical Inference:** Methods for gaining insight regarding the population
parameters from the observed data.

**Point Estimation:** An attempt to obtain the best guess of the value of a
population parameter. An estimator is a statistic that produces such a
guess. The estimate is the observed value of the estimator.

**Confidence Interval:** An interval that is most likely to contain the population
parameter. The confidence level of the interval is the sampling probability
that the confidence interval contains the parameter value.

**Hypothesis Testing:** A method for determining between two hypothesis, with
one of the two being the currently accepted hypothesis. A determination is
based on the value of the test statistic. The probability of falsely rejecting
the currently accepted hypothesis is the significance level of the test.

**Comparing Samples:** Samples emerge from different populations or under
different experimental conditions. Statistical inference may be used to
compare the distributions of the samples to each other.

**Regression:** Relates different variables that are measured on the same sample.
Regression models are used to describe the effect of one of the variables
on the distribution of the other one. The former is called the explanatory
variable and the later is called the response.

**Bias:** The difference between the expectation of the estimator and the value
of the parameter. An estimator is unbiased if the bias is equal to zero.
Otherwise, it is biased.

**Mean Square Error (MSE):** A measure of the concentration of the distribu-
tion of the estimator about the value of the parameter. The mean square
error of an estimator is equal to the sum of the variance and the square of
the bias. If the estimator is unbiased then the mean square error is equal
to the variance.

**Confidence Level:** The sampling probability that random confidence intervals
contain the parameter value. The confidence level of an observed interval
indicates that it was constructed using a formula that produces, when
applied to random samples, such random intervals.

**Null Hypothesis **($H0$): A sub-collection that emerges in response to the sit-
uation when the phenomena is absent. The established scientific theory
that is being challenged. The hypothesis which is worse to erroneously
reject.

**Alternative Hypothesis **($H1$): A sub-collection that emerges in response to
the presence of the investigated phenomena. The new scientific theory
that challenges the currently established theory.

**Test Statistic:** A statistic that summarizes the data in the sample in order to
decide between the two alternative.

**Rejection Region:** A set of values that the test statistic may obtain. If the
observed value of the test statistic belongs to the rejection region then the
null hypothesis is rejected. Otherwise, the null hypothesis is not rejected.

**Type I Error:** The null hypothesis is correct but it is rejected by the test.

**Type II Error:** The alternative hypothesis holds but the null hypothesis is not
rejected by the test.

**Significance Level:** The probability of a Type I error. The probability, com-
puted under the null hypothesis, of rejecting the null hypothesis. The
test is constructed to have a given significance level. A commonly used
significance level is 5%.

**Statistical Power:** The probability, computed under the alternative hypoth-
esis, of rejecting the null hypothesis. The statistical power is equal to 1
minus the probability of a Type II error.

$p$**-value:** A form of a test statistic. It is associated with a specific test statistic
and a structure of the rejection region. The p-value is equal to the signif-
icance level of the test in which the observed value of the statistic serves
as the threshold.

## DFSS

Quality tools have been grouped under varied names and methodologies being Six Sigma one of the most comprehensives ones. One way of summarising the Six Sigma framework is presented below in a step by step approach with definitions. Each steps consists of an analyis of the product development and production process that progressively refines the final product specifications.

For a more detailed description we recommend reviewing the comprehensive Six Sigma certification reference book by @Munro2015.

### Voice of Customer

**1. Product brief**
List of the product features expected by the customer (internal or external), including qualitative indication of the acceptance limits.

**2. Functional analysis**
Translation of the product attributes into lower level functions including interactions between product components and requirements induced by each component on the others.

**3. Failure modes and effects analysis (FMEA)**
List of critical product features with failure causes, effects, detection and action plans, rated and sorted by criticality.

**4. Product specifications and parts drawings**
Implementation of the product components into unique formulations and drawings including detailed values and tolerances of it characteristics (physical, chemical or electric or others).

### Voice of Process

**1. Process mapping**  
A visual diagram of the production process with inputs and outputs for each step.

**2. Process FMEA**
List of critical production process steps with failure causes, effects, detection and action plans, rated and sorted by criticality.

**3. Quality Control plan**
List of control points including measurement method, sample size, frequency and acceptance criteria. When needed, critical control points are handled by Statistical Process Control (SPC)

**4. Measurement system analysis**
A thorough assessment of a measurement process, and typically includes a specially designed experiment that seeks to identify the components of variation in that measurement process. 

**5. Process capability analysis**
Comparison of the variability of a production process with its engineered specifications.

## MSA

It is a fact that different communities utilize different methodologies and terminologies on the domain of measurement uncertainty. Unfortunately these differences are still too often overlapping, see @Muelaner2015 for detailed comparison.

In our text we opt for the industry terminology, in particular to the norm [ISO 5725](https://www.iso.org/obp/ui/#iso:std:11833:en), the practical application guides from @AIAG2010 and some articles on @minitab_gagernR which itself is based on the AIAG guidelines.

Variance components assess the amount of variation contributed by each source of measurement error, plus the contribution of part-to-part variability. The sum of the individual variance components equals the total variation.

**total gage r&R:** the sum of the repeatability and the reproducibility variance components.

**part:** The variation that comes from the parts, with 5 levels in this case.

**operator:** The variation that comes from the operators, with 3 levels in this case.

**replicants, n:** number of replications corresponding to the number of times each part is measured by each operator.

**repeatability (or error, or residuals):** The variation that is not explained by part, operator, or the operator and part interaction. It represents how much variability is caused by the measurement device (the same operator measures the same part many times, using the same gage). The repeatability can be measured directly from the Anova table from the residual mean squares.

**reproducibility:** how much variation is caused by the differences between operators (different operators measure the same part many times, using the same gage).

**operators:** the operators part of the reproducibility is the operators variation minus the interaction divided by the number of different parts times the replicants (zero if negative).

**parts:operators:** The variation that comes from the operator and part interaction. An interaction exists when an operator measures different parts differently. The interaction part of of the reproducibility is the interaction minus the repeatability divided by the number of replicants (zero if negative).

**part-to-part:** the variability due to different parts. Ideally, very little should be due to repeatability and reproducibility. Differences between parts should account for most of the variability (when the %Contribution from part-to-part variation is high, the measurement system can reliably distinguish between parts).

The sum of the individual variance components equals the total variation.

**Accuracy/Uncertainty:** Combination of precision and trueness. In the ISO 5725 both terms are equivalent.

**Precision:** Combination of repeatability and reproducibility

**Trueness:** difference between the mean of many measurements and the reference value. In ISO 5725 the term bias has been replaced by trueness.


## DOE

Below key definitions from @Montgomery2012, complemented with Wikipedia article details on the same topics.

**Randomization:** both the allocation of the experimental material and the order in which the individual runs of the experiment are to be performed are randomly determined.

**Replicate:** independent repeat run of each factor combination.

**Factorial design:** in each complete trial or replicate of the experiment all possible combinations of the levels of the factors are investigated.

**Crossed factors:** factors arranged in a factorial design.

**Coded variable:** the $\pm$ 1 coding for the low and high levels of the factors. Coded variables are very effective for determining the relative size of factor effects. In almost all situations, the coded unit analysis is preferable.

**Contrast:** a linear combination of parameters in the form $\tau=\sum_{i=1}^{a}c_i\mu_i$ where the contrast constants $c_1,c_2, ..., c_a$ sum to zero; that is, $\sum_{i=1}^{a}c_i=0$. 

**Orthogonal contrasts:** two contrasts with coefficients ${c_i}$ and ${d_i}$ are orthogonal if: $\sum_{i=1}^{a}c_id_i$. In a balanced one-way analysis of variance, using orthogonal contrasts has the advantage of completely partitioning the treatment sum of squares into non-overlapping additive components that represent the variation due to each contrast. Contrasts then allow for the comparison between the different means.

**sparsity of effects principle:** states that most systems are dominated by some of the main effects and low-order interactions, and most high-order interactions are negligible.
