# ' @title
# ' Generates a hyperparameter tuning control object
# '
# ' @description
# ' Tries to automatically create a suitable hyperparameter tuning control.
# '
# ' @param task [\code{Task}]
# '  Task
# ' @param learner [\code{Learner}]
# '  Learner
# ' @param par.config [\code{ParConfig}]
# ' @return [\code{HyperControl}]
# ' @export

generateHyperControl = function(task, learner, par.config) {

  makeHyperControl(
    control = control,
    resampling = resampling,
    measures = measures)
}