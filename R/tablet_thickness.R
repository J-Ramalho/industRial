#' Thickness measurements of pharmaceutical tablets
#' 
#' @format A data frame with 675 observations on 11 variables
#' 
#' @description This dataset contains physical measurements of pharmaceutical tablets (pills) 
#' including measurement room conditions. The data and the insights it provides 
#' are typical of an industrial context with high production throughput and 
#' stringent dimensional requirements.
#' 
#' @details
#' Variable names are deliberately long and not clean and categorical variables 
#' not coded as factors in order to provide material for name cleansing and type 
#' conversions which are part of the industRial Data Science book examples 
#' and exercises. The data set also contains other variables not used in the 
#' text book relating to the measurement room conditions.
#' 
#' \describe{
#'   \item{Position}{Position of the part on the device}
#'   \item{Size}{Size class (L, M, S)}
#'   \item{Tablet}{Part number (L001, L002, ...)}
#'   \item{Replicate}{Measurement replicate, a sequential numbers}
#'   \item{Day}{Measurement Day, a sequential numbers}
#'   \item{Date [DD.MM.YYYY]}{Measurement date (POSIXct)}
#'   \item{Operator}{Operator name (ficticious)}
#'   \item{Thickness [micron]}{Tablet thickness (micrometers)}
#'   \item{Temperature [°C]}{Room temperature}
#' }
#' 
#' @source 
#' Based on a gage r&R (gage reproducibility and repeatability) 
#' study performed in 2020 on a physical measurement of parts coming out of a 
#' high throughput industrial equipment.
#' 
#' @references 
#' For a complete case study application refer to \url{https://j-ramalho.github.io/industRial/}
#' 
#' @examples
"tablet_thickness"
