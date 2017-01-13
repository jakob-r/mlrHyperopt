# ' @title
# ' Gemerates a suitable Parameter Configuration Set for a given Task and a Learner
# '
# ' @description
# ' If now good Parameter Configuration Set is known this function tries to find one based on the given info.
# '
# ' @template note_repo
# '
# ' @param task [\code{Task}]
# '  Task the learner should be tuned on.
# ' @return [\code{ParConfig}]
# ' @export
generateParConfig = function(task, learner) {
  assertClass(task, "Task")
  assertClass(learner, "Learner")
  assert_set_equal(getTaskType(task), getLearnerType(learner))
  getDefaultParConfig(learner)
}