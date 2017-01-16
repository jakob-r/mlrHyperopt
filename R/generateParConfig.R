#' @title
#' Gemerates a suitable Parameter Configuration Set for a given Task and a Learner
#'
#' @description
#' If now good Parameter Configuration Set is known this function tries to find one based on the given info.
#'
#' @template note_repro
#'
#' @param task [\code{Task}]
#'  Task the learner should be tuned on.
#' @param learner [\code{Learner}]
#'  The learner that is subject to the Hyperparameter Tuning.
#' @return [\code{ParConfig}]
#' @export
generateParConfig = function(task, learner) {
  assertClass(task, "Task")
  learner = checkLearner(learner)
  assert_set_equal(getTaskType(task), getLearnerType(learner))
  getDefaultParConfig(learner)
}