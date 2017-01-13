# ' @title
# ' Generates a Learner for a given task and ParConfig.
# '
# ' @description
# ' Generates a Learner for a given task and ParConfig
# '
# ' @param task [\code{Task}]
# '  The Task
# ' @param par.config [\code{ParConfig}]
# ' @return [\code{Learner}]
# ' @export
generateLearner = function(task, par.config) {
  assert_class(task, "Task")
  assert_class(par.config, "ParConfig")
  if (is.null(getParConfigLearnerName(par.config))) {
    stopf("The ParConfig does not contain informations on a specific Learner!")
  }
  task.type = getTaskType(task)
  learner.type = getParConfigLearnerType(par.config)
  if (!is.null(learner.type) && learner.type != task.type) {
    warningf("The learner type of the par.config will be changed from %s to %s to suit the task.", learner.type, task.type)
  }
  par.config = setParConfigLearnerType(par.config, task.type)
  learner = makeLearner(getParConfigLearnerClass(par.config))
  learner
}