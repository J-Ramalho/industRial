
#' Gage R & R (Measurement System Assessment)
#' 
#' Performs Gage R&R analysis for the assessment of the measurement 
#' system of a process. Related to the Measure phase of the DMAIC
#' strategy of Six Sigma.
#' 
#' Performs an R&R study for the measured variable, taking into account
#'   part and appraiser factors. It outputs the sources of Variability, and
#'   six graphs: bar chart with the sources of Variability, plots by
#'   appraiser, part and interaction and x-bar and R control charts.
#'   
#' @param var Measured variable
#' @param part Factor for parts
#' @param appr Factor for appraisers (operators, machines, ...)
#' @param data Data frame containing the variables
#' @param main Main title for the graphic output
#' @param sub Subtitle for the graphic output (recommended the name of the project)
#' @param lsl Numeric value of lower specification limit used with USL to calculate Study Variation as \%Tolerance
#' @param usl Numeric value of upper specification limit used with LSL to calculate Study Variation as \%Tolerance
#' @param sigma Numeric value for number of std deviations to use in calculating Study Variation
#' @param alphaLim Limit to take into account interaction
#' @param errorTerm Which term of the model should be used as error term (for the model with interation)
#' @param digits Number of decimal digits for output
#' 
#' @return 
#' Analysis of Variance Table/s. Variance composition and \%Study Var. Graphics.
#' \item{anovaTable}{The ANOVA table of the model}
#' \item{anovaRed}{The ANOVA table of the reduced model (without interaction, only
#' if interaction not significant)}
#' \item{varComp}{A matrix with the contribution of each component to the 
#' 	total variation}
#' \item{studyVar}{A matrix with the contribution to the study variation}
#' \item{ncat}{Number of distinct categories}
#' 
#' @note 
#' The F test for the main effects in the ANOVA table is usually made 
#' taken the operator/appraisal
#' interaction as the error term (repeated measures model), thereby computing F as
#' $MS_{factor}/MS_{interaction}$, e.g. in appendix A of AIAG MSA manual, 
#' in Montgomery (2009) and by statistical software such as Minitab.
#' However, in the example provided in page 127 of the AIAG MSA Manual, the
#' F test is performed as $MS_{factor}/MS_{equipment}$, i.e., repeatability.
#' Thus, since version 0.9-3 of the SixSigma package, a new argument
#' \code{errorTerm} controls which term should be used as error Term, one of 
#' "interaction", "repeatability". 
#' 
#' Argument \code{alphaLim} is used as upper limit to use the full model, i.e.,
#' with interaction. Above this value for the interaction effect, the 
#' ANOVA table without the interaction effect is also obtained, and the variance
#' components are computed pooling the interaction term with the repeatibility.
#' 
#' @references 
#' Automotive Industry Action Group. (2010). Measurement Systems Analysis
#' (Fourth Edition). AIAG.
#' 
#' Cano, Emilio L., Moguerza, Javier M. and Redchuk, Andres. 2012.
#' \emph{Six Sigma with {R}. Statistical Engineering for Process
#'   Improvement}, Use R!, vol. 36. Springer, New York.
#'   \url{http://www.springer.com/statistics/book/978-1-4614-3651-5}.
#' 
#' Montgomery, D. C. (2009). Introduction to Statistical Quality Control
#' (Sixth Edition ed.). New York: Wiley & Sons, Inc.
#' 
#' 
#' @seealso 
#' \code{\link{ss.data.rr}}
#' 
#' @author EL Cano with contributions by Kevin C Limburg
#' 
#' @export
#' @keywords reproducibility repeatability Gauge R&R MSA
#'
#' @export
#' 
#' @importFrom stats aggregate aov as.formula pf
#' @importFrom SixSigma ss.cc.getd2 ss.cc.getd3
ss.rr.plots <- function (var,
                         part,
                         appr,
                         lsl = NA,
                         usl = NA,
                         sigma = 6,
                         data,
                         main = "Six Sigma Gage R&R Study",
                         sub = "",
                         alphaLim = 0.05,
                         errorTerm = "interaction",
                         digits = 4)
{
  
  if (is.data.frame(data)) {
    if (deparse(substitute(var)) %in% names(data)) {
      var <- deparse(substitute(var))
    }
    if (!(var %in% names(data))) {
      stop(var, "is not a valid column name for", deparse(substitute(data)))
    }
    if (deparse(substitute(part)) %in% names(data)) {
      part <- deparse(substitute(part))
    }
    if (deparse(substitute(appr)) %in% names(data)) {
      appr <- deparse(substitute(appr))
    }
    if (part %in% names(data)) {
      data[[part]] <- factor(data[[part]])
    }
    else {
      stop(part, "is not a valid column name for", data)
    }
    if (appr %in% names(data)) {
      data[[appr]] <- factor(data[[appr]])
    }
    else {
      stop(appr, "is not a valid column name for", data)
    }
  }
  else {
    stop("A data.frame object is needed as data argument")
  }
  a <- nlevels(data[[part]])
  b <- nlevels(data[[appr]])
  n <- nrow(data) / (a * b)
  options(show.signif.stars = FALSE)
  if (b == 1) {
    modelf <- as.formula(paste(var, "~", part))
    model <- aov(modelf, data = data)
    modelm <- summary(model)
    rownames(modelm[[1]])[2] <- "Repeatability"
    modelm[[1]] <- rbind(modelm[[1]], c(colSums(modelm[[1]][,
                                                            1:2]), rep(NA, 3)))
    rownames(modelm[[1]])[3] <- "Total"
    cat("One-way ANOVA (single appraiser):\n\n")
    print(modelm)
    modelrm <- NULL
  }
  else {
    modelf <- as.formula(paste(var, "~", part, "*", appr))
    modelfm <- as.formula(paste(var, "~", part, "*", appr,
                                "+ Error(", part, "/", appr, ")"))
    model <- aov(modelf, data = data)
    modelm <- summary(model)
    if (errorTerm == "interaction") {
      modelm[[1]][1:2, 4] <- modelm[[1]][1:2, 3] / modelm[[1]][3,
                                                               3]
      modelm[[1]][1:2, 5] <-
        pf(modelm[[1]][1:2, 4], modelm[[1]][1:2,
                                            1], modelm[[1]][3, 1], lower.tail = FALSE)
    }
    rownames(modelm[[1]])[4] <- "Repeatability"
    modelm[[1]] <- rbind(modelm[[1]], c(colSums(modelm[[1]][,
                                                            1:2]), rep(NA, 3)))
    rownames(modelm[[1]])[5] <- "Total"
    cat("Complete model (with interaction):\n\n")
    print(modelm)
    cat("\nalpha for removing interaction:", alphaLim, "\n")
    pint <- modelm[[1]][3, 5]
    if (pint > alphaLim) {
      modelfr <- as.formula(paste(var, "~", part, "+",
                                  appr))
      modelr <- aov(modelfr, data = data)
      modelrm <- summary(modelr)
      rownames(modelrm[[1]])[3] <- "Repeatability"
      modelrm[[1]] <- rbind(modelrm[[1]], c(colSums(modelrm[[1]][,
                                                                 1:2]), rep(NA, 3)))
      rownames(modelrm[[1]])[4] <- "Total"
      cat("\n\nReduced model (without interaction):\n\n")
      print(modelrm)
    }
    else
      modelrm <- NULL
  }
  varComp <- matrix(ncol = 6, nrow = 7)
  rownames(varComp) <- c(
    "Total Gage R&R",
    "  Repeatability",
    "  Reproducibility",
    paste0("    ", appr),
    paste0(part,
           ":", appr),
    "Part-To-Part",
    "Total Variation"
  )
  colnames(varComp) <- c("VarComp",
                         "%Contrib",
                         "StdDev",
                         "StudyVar",
                         "%StudyVar",
                         "%Tolerance")
  if (b == 1) {
    varComp[2, 1] <- modelm[[1]][2, 3]
    varComp[4, 1] <- NA
    varComp[5, 1] <- NA
    varComp[3, 2] <- NA
    varComp[6, 1] <- max(c((modelm[[1]][1, 3] - modelm[[1]][2,
                                                            3]) / (b * n), 0))
    varComp[1, 1] <- varComp[2, 1]
    varComp[7, 1] <- varComp[1, 1] + varComp[6, 1]
  }
  else {
    if (pint > alphaLim) {
      varComp[2, 1] <- modelrm[[1]][3, 3]
      varComp[4, 1] <- max(c((modelrm[[1]][2, 3] - modelrm[[1]][3,
                                                                3]) / (a * n), 0))
      varComp[5, 1] <- NA
      varComp[3, 1] <- varComp[4, 1]
      varComp[6, 1] <- max(c((modelrm[[1]][1, 3] - modelrm[[1]][3,
                                                                3]) / (b * n), 0))
      varComp[1, 1] <- varComp[2, 1] + varComp[3, 1]
      varComp[7, 1] <- varComp[1, 1] + varComp[6, 1]
    }
    else {
      varComp[2, 1] <- modelm[[1]][4, 3]
      varComp[4, 1] <- max(c((modelm[[1]][2, 3] - modelm[[1]][3,
                                                              3]) / (a * n), 0))
      varComp[5, 1] <- max(c((modelm[[1]][3, 3] - modelm[[1]][4,
                                                              3]) / n, 0))
      varComp[3, 1] <- varComp[4, 1] + varComp[5, 1]
      varComp[6, 1] <- max(c((modelm[[1]][1, 3] - modelm[[1]][3,
                                                              3]) / (b * n), 0))
      varComp[1, 1] <- varComp[2, 1] + varComp[3, 1]
      varComp[7, 1] <- varComp[1, 1] + varComp[6, 1]
    }
  }
  varComp[, 2] <- round(100 * (varComp[, 1] / varComp[7, 1]),
                        2)
  varComp[, 3] <- sqrt(varComp[, 1])
  varComp[, 4] <- varComp[, 3] * sigma
  varComp[, 5] <- round(100 * (varComp[, 3] / varComp[7, 3]),
                        2)
  varComp[, 6] <- round(100 * (varComp[, 4] / (usl - lsl)),
                        2)
  ncat <- max(c(1, floor((
    varComp[6, 4] / varComp[1, 4]
  ) * 1.41)))
  if (b == 1) {
    varComp <- varComp[-c(3:5),]
  }
  else {
    if (pint > alphaLim) {
      varComp <- varComp[-c(5),]
    }
  }
  cat(paste("\nGage R&R\n\n"))
  print(varComp[, 1:2])
  cat("\n")
  if (!is.na(usl) && !is.na(lsl)) {
    print(varComp[, c(1, 3:6)])
  }
  else {
    print(varComp[, 3:5])
  }
  cat(paste("\nNumber of Distinct Categories =", ncat, "\n"))
  # .ss.prepCanvas(main, sub)
  vp.plots <-
    grid::viewport(name = "plots", layout = grid::grid.layout(3,
                                                              2))
  grid::pushViewport(vp.plots)
  vp.bar <- grid::viewport(
    name = "barplot",
    layout.pos.row = 1,
    layout.pos.col = 1
  )
  grid::pushViewport(vp.bar)
  if (b == 1) {
    rowstoplot <- c(1, 2, 3)
  }
  else if (pint > alphaLim) {
    rowstoplot <- c(1, 2, 3, 5)
  }
  else {
    rowstoplot <- c(1, 2, 3, 6)
  }
  if (!is.na(usl) & !is.na(lsl)) {
    colstoplot <- c(2, 5, 6)
    klabels <- c("%Contribution", "%Study Var", "%Tolerance")
  }
  else {
    colstoplot <- c(2, 5)
    klabels <- c("%Contribution", "%Study Var")
  }
  databar <- varComp[rowstoplot, colstoplot]
  if (b == 1) {
    rownames(databar) <- c("G.R&R", "Repeat", "Part2Part")
  }
  else {
    rownames(databar) <- c("G.R&R", "Repeat", "Reprod",
                           "Part2Part")
  }
  plot1 <- lattice::barchart(
    databar,
    freq = FALSE,
    grid = TRUE,
    par.settings = list(
      axis.text = list(cex = 0.6),
      par.ylab.text = list(cex = 0.8),
      par.main.text = list(cex = 0.85)
    ),
    ylab = list("Percent",
                fontsize = 8),
    panel = function(...) {
      lattice::panel.barchart(...)
      lattice::panel.abline(h = 0)
      lattice::panel.abline(h = c(10, 30),
                            lty = 2,
                            col = "gray")
    },
    auto.key = list(
      text = klabels,
      cex = 0.8,
      columns = length(colstoplot),
      space = "bottom",
      rectangles = TRUE,
      points = FALSE,
      adj = 1,
      rep = FALSE
    ),
    stack = FALSE,
    horizontal = FALSE,
    main = list("Components of Variation", fontsize = 14)
  )
  print(plot, newpage = FALSE)
  grid::popViewport()
  vp.varByPart <-
    grid::viewport(
      name = "varByPart",
      layout.pos.row = 1,
      layout.pos.col = 2
    )
  grid::pushViewport(vp.varByPart)
  plot2 <- lattice::stripplot(
    as.formula(paste(var, "~", part)),
    data = data,
    grid = TRUE,
    par.settings = list(
      axis.text = list(cex = 0.6),
      par.xlab.text = list(cex = 0.8),
      par.ylab.text = list(cex = 0.8),
      par.main.text = list(cex = 0.9)
    ),
    main = paste(var,
                 "by", part),
    type = c("p", "a")
  )
  print(plot, newpage = FALSE)
  grid::popViewport()
  vp.varByAppr <-
    grid::viewport(
      name = "varByAppr",
      layout.pos.row = 2,
      layout.pos.col = 2
    )
  grid::pushViewport(vp.varByAppr)
  plot3 <- lattice::stripplot(
    as.formula(paste(var, "~", appr)),
    data = data,
    grid = TRUE,
    par.settings = list(
      axis.text = list(cex = 0.6),
      par.xlab.text = list(cex = 0.8),
      par.ylab.text = list(cex = 0.8),
      par.main.text = list(cex = 0.9)
    ),
    main = paste(var,
                 "by", appr),
    type = c("p", "a")
  )
  print(plot, newpage = FALSE)
  grid::popViewport()
  vp.Interact <-
    grid::viewport(
      name = "Interact",
      layout.pos.row = 3,
      layout.pos.col = 2
    )
  grid::pushViewport(vp.Interact)
  data.xbar <- aggregate(as.formula(paste(var, "~", appr,
                                          "+", part)), data = data, mean)
  plot4 <- lattice::stripplot(
    as.formula(paste(var, "~", part)),
    groups = get(appr),
    data = data.xbar,
    pch = 16,
    grid = TRUE,
    par.settings = list(par.main.text = list(cex = 0.9)),
    main = paste0(part, ":", appr, " Interaction"),
    type = c("p",
             "a"),
    auto.key = list(
      text = levels(data[[appr]]),
      columns = nlevels(data[[appr]]),
      space = "bottom",
      cex = 0.5,
      lines = TRUE,
      points = FALSE,
      adj = 1
    )
  )
  print(plot, newpage = FALSE)
  grid::popViewport()
  data.xrange <- aggregate(as.formula(paste(var, "~", appr,
                                            "+", part)), data = data, function(x) {
                                              max(x) - min(x)
                                            })
  ar <- mean(data.xrange[[var]])
  vp.ccMean <- grid::viewport(
    name = "ccMean",
    layout.pos.row = 3,
    layout.pos.col = 1
  )
  grid::pushViewport(vp.ccMean)
  xbar <- mean(data[[var]], na.rm = TRUE)
  ucl <- xbar + (3 / (ss.cc.getd2(n) * sqrt(n))) * ar
  lcl <- xbar - (3 / (ss.cc.getd2(n) * sqrt(n))) * ar
  glimits <-
    c(min(range(data.xbar[[var]])[1], lcl), max(range(data.xbar[[var]])[2],
                                                ucl)) + c(-1, 1) * 0.1 * diff(range(data.xbar[[var]]))
  plot5 <- lattice::xyplot(
    as.formula(paste(var, "~", part,
                     "|", appr)),
    data = data.xbar,
    pch = 16,
    par.settings = list(
      axis.text = list(cex = 0.6),
      par.xlab.text = list(cex = 0.8),
      par.ylab.text = list(cex = 0.8),
      par.main.text = list(cex = 0.9)
    ),
    par.strip.text = list(cex = 0.6),
    main = expression(bold(bar(x) * " Chart by " * appr)),
    grid = TRUE,
    layout = c(b, 1),
    type = "b",
    ylim = glimits,
    panel = function(...) {
      lattice::panel.xyplot(...)
      lattice::panel.abline(h = xbar, lty = 2)
      lattice::panel.abline(h = ucl, col = "red3")
      lattice::panel.abline(h = lcl, col = "red3")
    }
  )
  print(plot, newpage = FALSE)
  grid::popViewport()
  vp.ccRange <-
    grid::viewport(
      name = "ccRange",
      layout.pos.row = 2,
      layout.pos.col = 1
    )
  grid::pushViewport(vp.ccRange)
  this.d3 <- ss.cc.getd3(n)
  this.d2 <- ss.cc.getd2(n)
  rlimits <- c(max(ar * (1 - 3 * (
    this.d3 / (this.d2)
  )), 0),
  ar * (1 + 3 * (this.d3 / (this.d2))))
  glimits <- c(min(range(data.xrange[[var]])[1], rlimits[1]),
               max(range(data.xrange[[var]])[2], rlimits[2])) + c(-1,
                                                                  1) * 0.1 * diff(range(data.xrange[[var]]))
  plot6 <- lattice::xyplot(
    as.formula(paste(var, "~", part,
                     "|", appr)),
    data = data.xrange,
    pch = 16,
    par.settings = list(
      axis.text = list(cex = 0.6),
      par.xlab.text = list(cex = 0.8),
      par.ylab.text = list(cex = 0.8),
      par.main.text = list(cex = 0.9)
    ),
    par.strip.text = list(cex = 0.6),
    main = paste("R Chart by", appr),
    grid = TRUE,
    layout = c(b,
               1),
    type = "b",
    ylim = glimits,
    panel = function(...) {
      lattice::panel.xyplot(...)
      lattice::panel.abline(h = ar, lty = 2)
      lattice::panel.abline(h = rlimits[1], col = "red3")
      lattice::panel.abline(h = rlimits[2], col = "red3")
    }
  )
  print(plot, newpage = FALSE)
  grid::popViewport()
  invisible(
    list(
      anovaTable = modelm,
      anovaRed = modelrm,
      varComp = varComp[, 1:2],
      studyVar = varComp[, 3:6],
      ncat = ncat
    )
  )
  plotlist <- list()
  plotlist$plot1 <- plot1
  plotlist$plot2 <- plot2
  plotlist$plot3 <- plot3
  plotlist$plot4 <- plot4
  plotlist$plot5 <- plot5
  plotlist$plot6 <- plot6
  return(plotlist)
}
