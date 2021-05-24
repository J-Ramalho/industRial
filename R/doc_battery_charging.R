#' Charging time of a lithium-ion battery.
#' 
#' @format A tibble with 32 observations on 6 variables.
#' 
#' @description A data set with charging time in hours required to recharge
#' a lithium-ion battery based on a full factorial design of experiment with 
#' four variables (A, B, C, D) coded as +/- 1. Design effects are coded as 
#' numerical variables in order to allow to build models without coding the 
#' contrasts and then to make predictions on a continuous range from -1 to +1.
#' 
#' \describe{
#'   \item{A}{Variable A (numerical)}
#'   \item{B}{Variable B (numerical)}
#'   \item{C}{Variable B (numerical)}
#'   \item{D}{Variable B (numerical)}
#'   \item{Replicate}{The independent repeat of each unique factor combination.}
#'   \item{charging_time}{Battery charging time [h]}
#' }
#' 
#' @source
#' Original data set.
#' 
#' @references 
#' For a complete case study application refer to \url{https://j-ramalho.github.io/industRial/}.
#' 
#' @examples
#' data(battery_charging)
#' head(battery_charging)
#' 
#' # Building a linear model:
#' battery_lm <- lm(
#'     formula = charging_time ~ A * B * C, 
#'     data = battery_charging
#' )
#' summary(battery_lm)
#' 
"battery_charging"