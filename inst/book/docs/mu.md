

## Uncertainty

A final step in the validation of our measurement device is now the calculation of the total measurement uncertainty. 

In some reports the terminology uncertainty is prefered instead of gage r&R.
In this case the formula usually used to evaluate the measurement uncertainty is:

$$
u^2=u_{repeat.}^2+ u_{reprod.}^2+ u_{cal.}^2
$$

where the repeatability and reproducibility members can be obtained from the variances calculated in the r&R study

$$
u_{reprod.}^2 = σ_{reprod.}^2\\
u_{repeat.}^2 = σ_{repeat.}^2
$$

From the variance components table in our example we have:

$$
σ_{repeat.}^2 = 157.21\\
σ_{reprod.}^2 = 6.89
$$

The calibration uncertainty has in this case been obtained from the equipment notice:

$$
u_(cal) = 200\mu m^3 <=> 200e^{-9} <=> 2.10^{-7}mm^3 <=> 4.10^{-14}
$$

we consider this value negligible, thus we have a final uncertainty of:

$$
u = \sqrt[2]{157.21 + 6.89}\\
u = 12.81015
$$

Finally what is usually reported is the expanded uncertainty corresponding to 2 standard deviations. To be recalled that +/- 2 std corresponds to 95% of the values when a repeative measurement is done. In this case we have $U = 2*u$ which rounded gives $U = 25.6$

For a specific measurement of say 18'000 we then say: the axis volume is 18'000 mm^3 plus or minus
25.6 mm3, at the 95 percent confidence level. Or written in short 18'000 mm^3 ± 25.6 mm^3, at a level of confidence of 95%

Knowing that the specification is [17'750; 18'250] $mm^3$ we have a range of 500 which when compared to 2 * 25.6 = 51.2 is aproximately 10 times. This is another way of looking into the ratio between method variation and specification, that was in fact 15.37% in the study variation table because there it was considered 3 standard deviations.
