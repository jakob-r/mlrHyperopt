#' @title Create a dictionary based on the task.
#'
#' @description Returns a dictionary, which contains the \link{Task} itself
#' (\code{task}), the number of features (\code{p}) the model is trained on, the number of
#' observations (\code{n.task}) of the task in general, the number of observations (\code{n})
#' in the current subset, the task type (\code{type}) and in case of
#' classification tasks, the number of class levels (\code{k}) in the general task.
#'
#' @template arg_task
#' @return [\code{\link[base]{list}}]. Used for evaluating the expressions
#' within a parameter, parameter set or list of parameters.
#' @family task
#' @export
#' @examples
#' task = makeClassifTask(data = iris, target = "Species")
#' getTaskDictionary(task)
# FIXME: This Function should be part of mlr
# It is taken from the branch expressions, mostly written by: https://github.com/kerschke and https://github.com/mllg
getTaskDictionary = function(task) {
  assertClass(task, classes = "Task")
  dict = list(
    task = task,
    p = getTaskNFeats(task),
    n.task = getTaskSize(task),
    type = getTaskType(task),
    n = getTaskSize(task)
  )
  if (dict$type == "classif")
    dict$k = length(getTaskClassLevels(task))
  return(dict)
}