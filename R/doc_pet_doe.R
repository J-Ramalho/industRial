#' A factorial design for the improvement of PET film tensile strength. 
#' 
#' @format An object of classes design and data.frame with 12 observations of 
#' 4 variables.
#' 
#' @description The data corresponds to full factorial design with two factors
#' coded as +/- and 3 replicates for each combination.
#' 
#' \describe{
#'   \item{A}{PET formulation A (factor)}
#'   \item{B}{PET formulation B (factor)}
#'   \item{replicate}{the measurement replicate I to III (factor)}
#'   \item{yield}{the output variable measured on the PET, (numerical)}
#' }
#' 
#' @source
#' Original data set generated with the function 
#' \code{\link[DoE.base]{fac.design}} form the package DoE.base.
#' 
#' @references 
#' For a complete case study application refer to \url{https://j-ramalho.github.io/industRial/}
#' 
#' @examples
"pet_doe"
