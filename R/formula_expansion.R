#' Formula expansion
#'
#' Takes a linear model formula and returns it expanded version. 
#' 
#' @details 
#' This function supports verification and understanding of the creation of 
#' linear models syntax such as *,+ and other conventions.
#' 
#' @param formula 
#' 
#' @references 
#' For an example application refer to \url{https://j-ramalho.github.io/industRial/}
#'
#' @return
#' Returns a character vector such as A + B + A:B
#' @export
#'
#' @examples
formula_expansion <- function(formula) {
  attributes(terms(formula))$term.labels
}
