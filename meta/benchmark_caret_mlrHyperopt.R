# compare caret to mlrHyperopt

library(batchtools)
library(mlr)
library(mlrHyperopt)
library(OpenML)
library(BBmisc)
library(stringi)

# define what learners to benchmark
lrns = data.frame(
  mlr = c("boosting", "C50", "RFF", "ada", "blackboost", "extraTrees", "randomForest", "ksvm", "glmboost"),
  caret = c("AdaBoost.M1", "C5.0", "RFFglobal", "ada", "blackboost", "extraTrees", "randomForest", "svmRadial", "glmboost")
  )

# define the datasets
# https://www.openml.org/s/30 #formally 14

task_infos = listOMLTasks(tag = "study_30")
oml.tasks = lapply(task_infos$task.id, getOMLTask)
mlr.taskslist = lapply(oml.tasks, convertOMLTaskToMlr)

# batchtools stuff ####
unlink("~/nobackup/mlrHyperCaret", recursive = TRUE)
reg = makeExperimentRegistry(file.dir = "~/nobackup/mlrHyperCaret", seed = 1, packages = c("methods","utils", "mlr", "mlrHyperopt", "BBmisc", "stringi"))
reg$cluster.functions = makeClusterFunctionsMulticore(ncpus = 3)

## Problem generation
pdes = lapply(mlr.taskslist, function(data) {
  addProblem(name = getTaskId(data$mlr.task), data = data, fun = function(...) list(...), seed = reg$seed)
  res = list(data.frame(fold = seq_along(data$mlr.rin$train.inds)))
  names(res) =  getTaskId(data$mlr.task)
  res
})
pdes = unlist(pdes, recursive = FALSE)

## Define Algorithm Functions
algo.caret = function(job, data, instance, learner, budget = NULL, search = "grid") {
  library(caret)
  fitControl = trainControl(method = "cv", number = 10, search = search)
  train.inds = data$mlr.rin$train.inds[[instance$fold]]
  test.inds = data$mlr.rin$test.inds[[instance$fold]]
  train.data = getTaskData(data$mlr.task, target.extra = TRUE, subset = train.inds)
  test.data = getTaskData(data$mlr.task, target.extra = TRUE, subset = test.inds)
  train.args = list(x = train.data$data, y = train.data$target, method = learner, trControl = fitControl, verbose = FALSE)
  if (!is.null(budget)) {
    train.args = c(train.args, tuneLength = budget)
  }
  time.start = Sys.time()
  m = do.call(what = train, args = train.args)
  time.end = Sys.time()
  p = predict(m, newdata = test.data$data)
  accFun = paste0("measure",toupper(data$mlr.measures[[1]]$id))
  r = do.call(accFun, list(truth = test.data$target, response = p))

  return(list(
    model = m,
    prediction = p,
    measure = r,
    time = difftime(time.end, time.start, units = "secs")))
}

algo.mlrHyperopt = function(job, data, instance, learner, budget = NULL, search = NULL) {
  train.inds = data$mlr.rin$train.inds[[instance$fold]]
  test.inds = data$mlr.rin$test.inds[[instance$fold]]
  train.task = subsetTask(data$mlr.task, subset = train.inds)
  test.task = subsetTask(data$mlr.task, subset = test.inds)
  learner.type = stri_trans_tolower(stri_replace_all_fixed(class(train.task)[1], "Task", ""))
  time.start = Sys.time()
  lrn = makeLearner(sprintf("%s.%s", learner.type, learner))
  par.config = generateParConfig(task = train.task, learner = lrn)
  hc = generateHyperControl(task = train.task, learner = lrn, par.config = par.config)
  hc$measures = data$mlr.measures
  r = hyperopt(task = train.task, hyper.control = hc, learner = lrn, par.config = par.config)
  m = train(learner = r$learner, task = train.task)
  time.end = Sys.time()
  p = predict(m, task = test.task)
  r2 = performance(pred = p, measures = data$mlr.measures, task = test.task, model = m)
  return(list(
    model = list(hyperopt.res = r, trained.model = m, all.measures = r2),
    prediction = p,
    measure = r2[1],
    time = difftime(time.end, time.start, units = "secs")))
}

## Add Algorithms
addAlgorithm(name = "caret", fun = algo.caret)
addAlgorithm(name = "mlrHyperopt", fun = algo.mlrHyperopt)
ades = list(
  caret = expand.grid(learner = lrns$caret, budget = c(10,25,50), search = c("grid", "random")),
  mlrHyperopt = data.frame(learner = lrns$mlr)
)


## Experiments
addExperiments(pdes, ades)

### subset to a small test set
run.ids = findExperiments(prob.name = "sonar", prob.pars = (fold %in% 1:3), algo.pars = (learner %in% c("svmRadial", "ksvm")))
submitJobs(run.ids)
#testJob(548)
Sys.sleep(2)
## Finding Resuls
res = reduceResultsDataTable(fun = function(job, res) data.table(measure = res$measure, time = res$time))
res = res[getJobPars(res)]

# Visualizing Results
library(ggplot2)
g = ggplot(data = res, aes(x = paste(learner, algorithm, search, budget), y = measure, fill = paste(learner, algorithm)))
g + geom_boxplot()
g = ggplot(data = res, aes(x = 1-measure, y = time, color = paste(learner, algorithm, search)))
g + geom_point()


# Detailed Analysis
res.list = reduceResultsList()
good.caret = res.list[[10]]
good.mlrHyper = res.list[[20]]
good.caret$model$results
as.data.frame(good.mlrHyper$model$hyperopt.res$opt.path)
