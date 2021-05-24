#' Production measurements of the inner diameter of syringes barrels.
#' 
#' @format A tibble with 25 observations on 7 variables.
#' 
#' @description This dataset contains process control measurements of
#' the barrel diameters of pharmaceutical syringes. The sampling rate is hourly
#' and the sample size is 6 syringes.
#' 
#' \describe{
#'   \item{Hour}{The sampling hour expressed as Hour1, Hour2 (character)}
#'   \item{Sample1}{Syringe diameter of sample 1 (numerical)}
#'   \item{Sample2}{Syringe diameter of sample 2 (numerical)}
#' }
#' 
#' @source
#' Original data set.
#' 
#' @references 
#' For a complete case study application refer to \url{https://j-ramalho.github.io/industRial/}.
#' 
#' @examples
#' data(syringe_diameter)
#' 
"syringe_diameter"