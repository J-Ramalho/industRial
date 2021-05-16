#' Dry matter content of different juices obtained with two different devices
#' 
#' @format A tibble with 108 observations on 7 variables
#' 
#' @description This data set contains laboratory measurements of the dry matter
#' content of different fruit juices obtained with two different measurement 
#' devices. One of the devices is considered the reference (REF) and the other
#' one is a new device (DRX) on which a linearity and bias study has to be 
#' performed.
#' 
#' \describe{
#'   \item{product}{The juice base fruit ("Apple", "Beetroot")}
#'   \item{drymatter_TGT}{Target drymatter content in [g]}
#'   \item{speed}{Production line speed}
#'   \item{particle_size}{Dry matter powder particle size [micrometers]}
#'   \item{part}{Part number}
#'   \item{drymatter_DRX}{Drymatter content measured with device DRX}
#'   \item{drymatter_REF}{Drymatter content measured with reference device}
#' }
#' 
#' @source
#' Adapted from a real gage bias and linearity study performed in 2021 on 
#' industrial beverages dry matter content measurement.
#' 
#' @references 
#' For a complete case study application refer to \url{https://j-ramalho.github.io/industRial/}
#' 
#' @examples
"juice_drymatter"
