#' @title
#' Hyperparameter Tuning Control Object
#'
#' @description
#' Defines how the hyperparameter tuning should be conducted
#'
#' @param control [\code{\link[mlr]{TuneControl}}]\cr
#'   Control object for search method. Also selects the optimization algorithm for tuning.
#' @param resampling [\code{\link[mlr]{ResampleDesc}}]
#'  The resampling determines how the performance is obtained during tuning.
#' @param measures [\code{\link[mlr]{Measure}} | list of \code{\link[mlr]{Measure}}]\cr
#'   Performance measure(s) to evaluate.
#'   Default is the default measure for the task, see here \code{\link{getDefaultMeasure}}.
#' @return [\code{HyperControl}]
#' @family HyperControl
#' @aliases HyperControl
#' @export

makeHyperControl = function(control = NULL, resampling = NULL, measures = NULL) {
  
  assert_class(control, classes = "TuneControl")
  
  if (!inherits(resampling, "ResampleDesc") &&  !inherits(resampling, "ResampleInstance"))
  stop("Argument resampling must be of class ResampleDesc or ResampleInstance!")
  
  ensureVector(measures, n = 1L, cl = "Measure")
  assert_list(measures, min.len = 1, types = "Measure")

  makeS3Obj(
    classes = "HyperControl",
    control = control,
    resampling = resampling,
    measures = measures)
}