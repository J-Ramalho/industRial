#' Thickness measurements of pharmaceutical tablets
#' 
#' @format An object of class tibble with 675 observations on 11 variables
#' 
#' @description This data set contains physical measurements of pharmaceutical 
#' tablets (pills) including measurement room conditions. The data and the 
#' insights it provides are typical of an industrial context with high production
#' throughput and stringent dimensional requirements.
#' 
#' @details
#' The data set contains other variables not used in the text book related with 
#' to the measurement room conditions (not listed).
#' 
#' \describe{
#'   \item{Position}{Position of the part on the measurement device}
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