#' @title
#' Hyperparameter Tuning Control Object
#'
#' @description
#' Defines how the hyperparameter tuning should be conducted
#'
#' @param mlr.control [\code{\link[mlr]{TuneControl}}]\cr
#'   Control object for search method. Also selects the optimization algorithm for tuning.
#' @param resampling [\code{\link[mlr]{ResampleDesc}}]
#'  The resampling determines how the performance is obtained during tuning.
#' @param measures [\code{\link[mlr]{Measure}} | list of \code{\link[mlr]{Measure}}]\cr
#'   Performance measure(s) to evaluate.
#'   Default is the default measure for the task, see here \code{\link{getDefaultMeasure}}.
#' @return [\code{HyperControl}]
#' @family HyperControl
#' @aliases HyperControl
#' @examples
#' hyper.control = makeHyperControl(
#'   mlr.control = makeTuneControlDesign(design = generateDesign(n = 10)),
#'   resampling = cv2,
#'   measures = acc
#' )
#' hyperopt(task = iris.task, learner = "classif.svm", hyper.control = hyper.control)
#' @export

makeHyperControl = function(mlr.control = NULL, resampling = NULL, measures = NULL) {

  assert_class(mlr.control, classes = "TuneControl")

  if (!inherits(resampling, "ResampleDesc") &&  !inherits(resampling, "ResampleInstance"))
    stop("Argument resampling must be of class ResampleDesc or ResampleInstance!")

  measures = ensureVector(measures, n = 1L, cl = "Measure")
  assert_list(measures, min.len = 1, types = "Measure")

  makeS3Obj(
    classes = "HyperControl",
    mlr.control = mlr.control,
    resampling = resampling,
    measures = measures)
}

## Getter

#' @title Get the Resample Describtion
#' @description Get the Resample Describtion
#' @template arg_hypercontrol
#' @return [\code{\link[mlr]{ResampleDesc}}|\code{\link[mlr]{ResampleInstance}}].
#' @export
#' @family HyperControl
getHyperControlResampling = function(hyper.control) {
  hyper.control$resampling
}

#' @title Get the Measures
#' @description Get the Measures
#' @template arg_hypercontrol
#' @return [\code{\link[mlr]{measures}}].
#' @export
#' @family HyperControl
getHyperControlMeasures = function(hyper.control) {
  hyper.control$measures
}

#' @title Get the mlr Tuning Object
#' @description Get the mlr Tuning Object
#' @template arg_hypercontrol
#' @return [\code{\link[mlr]{TuneControl}}].
#' @export
#' @family HyperControl
getHyperControlMlrControl = function(hyper.control) {
  hyper.control$mlr.control
}

## Setter

#' @title Set the mlr resampling Object
#' @description Set the mlr resampling Object
#' @template arg_hypercontrol
#' @inheritParams makeHyperControl
#' @return [\code{HyperControl}]
#' @export
#' @family HyperControl
setHyperControlResampling = function(hyper.control, resampling) {
  if (!inherits(resampling, "ResampleDesc") &&  !inherits(resampling, "ResampleInstance"))
    stop("Argument resampling must be of class ResampleDesc or ResampleInstance!")
  hyper.control$resampling = resampling
  hyper.control
}

#' @title Set the measures
#' @description Set the measures
#' @template arg_hypercontrol
#' @inheritParams makeHyperControl
#' @return [\code{HyperControl}]
#' @export
#' @family HyperControl
setHyperControlMeasures = function(hyper.control, measures) {
  measures = ensureVector(measures, n = 1L, cl = "Measure")
  assert_list(measures, min.len = 1, types = "Measure")
  hyper.control$measures = measures
  hyper.control
}

#' @title Set the mlr TuneControl Object
#' @description Set the mlr TuneControl Object
#' @template arg_hypercontrol
#' @inheritParams makeHyperControl
#' @return [\code{HyperControl}]
#' @export
#' @family HyperControl
setHyperControlMlrControl = function(hyper.control, mlr.control) {
  assert_class(mlr.control, classes = "TuneControl")
  hyper.control$mlr.control = mlr.control
  hyper.control
}