#' Formula expansion
#'
#' Takes a linear model formula and returns it expanded version. 
#' 
#' @details 
#' Supports verification and understanding of the creation of linear models 
#' syntax such as *,+ and other conventions.
#' 
#' @param formulae 
#' Takes as input object of class formula, e.g.: Y ~ A * B, see ?formula for 
#' syntax details
#' 
#' @references 
#' For an example application refer to \url{https://j-ramalho.github.io/industRial/}
#'
#' @return
#' Returns a character vector such as A + B + A:B
#' @export
expand_formula <- function(formulae) {
  ### Error handling: returns an error is object is not a formula data type
  # Based on 
  # https://adv-r.hadley.nz/conditions.html#custom-conditions
  # https://stackoverflow.com/questions/36361158/how-to-test-if-an-object-is-a-formula-in-base-r/58788220#58788220
  isFormula <- function(x) is.call(x) && x[[1]] == quote(`~`)
  if (!isFormula(formulae)) {
    rlang::abort(paste0(
      "expects as input a formula, e.g. y ~ A * B; not ", typeof(formulae), ".\n
      see ?formula for syntax details."
    ))
  }
  # Extract terms from formula
  # https://stackoverflow.com/questions/12967797/is-there-a-better-alternative-than-string-manipulation-to-programmatically-build
  attr(stats::terms(formulae), "term.labels")
}
