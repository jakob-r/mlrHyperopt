#' @title
#' Generates a suitable Parameter Configuration Set for a given Task and a Learner
#'
#' @description
#' This function tries to find a good Parameter Configuration for the given learner.
#'
#' @template note_repro
#'
#' @template arg_learner
#' @template arg_task
#' @return [\code{ParConfig}]
#' @examples
#' par.config = generateParConfig("classif.svm")
#' print(par.config)
#' @export
generateParConfig = function(learner, task = NULL) {
  learner = checkLearner(learner)
  if (!is.null(task)) {
    assertClass(task, "Task")
    assertSetEqual(getTaskType(task), getLearnerType(learner))
  }
  # in the future we might generate a different par.config based on the task
  # for now we have expressions in the ParamSet, which should cover data based
  # parameters in the beginning.
  getDefaultParConfig(learner)
}