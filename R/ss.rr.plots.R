#' Gage R & R plots
#' 
#' Extracts stand alone plots from the ss.rr function of the SixSigma package.
#' 
#' This is a modified version of the function \code{\link[SixSigma]{ss.rr}}  
#' from the SixSigma package that allows to extract the individual plots from 
#' the output report. The input arguments of the function are the same
#' as the original function. See the original function help with ?ss.rr for 
#' full documentation.
#' 
#' @return
#' Generates a list output that can be assigned to a 
#' user created variable. The plots can then be accessed with the syntax
#' variable$plot1 to plot6. 
#' 
#' @references 
#' For an example application refer to \url{https://j-ramalho.github.io/industRial/}
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
