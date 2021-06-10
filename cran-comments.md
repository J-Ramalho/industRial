## Test environments
* Ubuntu 20.04.2 LTS
* Windows 10 Enterprise 1909
* R 4.1.0

## R CMD check results
0 errors | 0 warnings | 0 notes
R CMD check succeeded

## Downstream dependencies
There are currently no downstream dependencies for this package.
(new package, first submission)

## 2021-06-06 General comments 
I get PREPERROR with rhub::check_for_cran() which I understand being related
with bioconductor: 
"Error: Bioconductor does not yet build and check packages for R version 4.2; see
  https://bioconductor.org/install"
I don't intend to deploy on bioconductor.

## 2021-06-07 General comments 
Dear Julia Haider, 
thanks for your quick review and very helpful comments.
I've corrected DESCRIPTION: references with <https:...>, title in quotes;
I've fixed everything that would modify the user session: added dev.off()
after every call to par(); removed options(show.signif.stars = FALSE) from 
ss.rr.plot as it was a leftover and not needed; I've removed options() setting
in the file setup.R. I moved theme_set(industRial::theme_industRial()) inside 
knitr::opts_knit$set which is used only for the Rmd knit and doesn't affect the
use session. 
Hope this addresses all your points but let me know if otherwise.
Best regards,
Joao Ramalho

## 2021-06-09 General comments

Dear Uwe Ligges,
thanks for your remarks. I've changed the title to capitals and added trailing
slashes to the requested url (https://j-ramalho.github.io/industRial/). Hope all
is ready now but don't hesitate to point out anything else missing.
Thanks in advance for your revision and approval.
Kind regards,
Joao Ramalho

## 2021-06-10 General comments

Dear Gregor Seyer,
thanks for your feedback. I've removed all calls to the print() and cat()
functions. There were mostly a legacy from a function I've taken from an old 
package and others were left overs from Shiny debugging. I will be more
attemptive in future submissions. Thanks for your new review.
Kind regards.
Joao Ramalho
