# compare caret to mlrHyperopt

library(batchtools)
library(mlr)
library(mlrHyperopt)
library(OpenML)
library(BBmisc)
library(stringi)

# define what learners to benchmark
lrns = data.frame(
  mlr = c("boosting", "C50", "RRF", "ada", "blackboost", "extraTrees", "randomForest", "ksvm", "glmboost"),
  caret = c("AdaBoost.M1", "C5.0", "RRFglobal", "ada", "blackboost", "extraTrees", "rf", "svmRadial", "glmboost")
  )

# define the datasets
# https://www.openml.org/s/30 #formally 14

task_infos = listOMLTasks(tag = "study_30")
oml.tasks = lapply(task_infos$task.id, getOMLTask)
mlr.taskslist = lapply(oml.tasks, convertOMLTaskToMlr)

# batchtools stuff ####
#unlink("~/nobackup/mlrHyperCaret", recursive = TRUE)
reg = makeExperimentRegistry(file.dir = "~/nobackup/mlrHyperCaret2", seed = 1, packages = c("methods","utils", "mlr", "mlrHyperopt", "BBmisc", "stringi"))
if (reg$cluster.functions$name == "Interactive") {
  reg$cluster.functions = makeClusterFunctionsMulticore(ncpus = 3)
}

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
  train.args = list(x = train.data$data, y = train.data$target, method = learner, trControl = fitControl)
  if (!is.null(budget)) {
    train.args = c(train.args, tuneLength = budget)
  }

  time.start = Sys.time()
  m = do.call(what = train, args = train.args)
  p = predict(m, newdata = test.data$data)
  time.end = Sys.time()

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
  par.config = generateParConfig(learner = lrn, task = train.task)
  hc = generateHyperControl(task = train.task, learner = lrn, par.config = par.config, budget.evals = budget)
  hc$measures = data$mlr.measures
  r = hyperopt(task = train.task, hyper.control = hc, learner = lrn, par.config = par.config)
  m = train(learner = r$learner, task = train.task)
  p = predict(m, task = test.task)
  time.end = Sys.time()

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
  mlrHyperopt = expand.grid(learner = lrns$mlr, budget = c(10,25,50))
)


## Experiments
addExperiments(pdes, ades)

### subset to a small test set
#run.ids = findExperiments(prob.name = "sonar", prob.pars = (fold %in% 1:3), algo.pars = (learner %in% c("svmRadial", "ksvm")))
run.ids = findExperiments(prob.pars = (fold %in% 1:5))
submitJobs(run.ids)
#testJob(548)
waitForJobs()

stop("Finished!")
##
# Finding Resuls ####
##
reg = loadRegistry("~/sfbrdata/nobackup/mlrHyperCaret2/", update.paths = FALSE)
res = reduceResultsDataTable(fun = function(job, res) data.table(measure = res$measure, time = res$time))
res.backup = res
res = res[getJobPars(res)]

# matching learner names
lrns2 = as.data.table(lrns)
lrns2 = plyr::rename(lrns2, c(caret = "learner"))
res = merge(res, lrns2, all.x = TRUE, by = "learner")
res[!is.na(mlr), learner := mlr, ]
# Visualizing Results
library(ggplot2)
res$time = as.numeric(res$time, units = "secs")
g = ggplot(data = res, aes(x = paste(algorithm, search, budget), y = measure, fill = paste(algorithm,search)))
g + geom_boxplot() + facet_grid(problem~learner, scales = "free")
g = ggplot(data = res, aes(x = measure, y = time, color = algorithm, size = as.factor(budget)))
g + geom_point(alpha = 0.1) + facet_grid(learner~problem, scales = "free") + scale_y_log10()
# extract the good parameter settings


# Detailed Analysis
res.list = reduceResultsList(ids = res[algorithm == "mlrHyperopt", job.id[1:10]])
res.x = reduceResultsDataTable(fun = function(job, res) if(!is.null(res$model$bestTune)) res$model$bestTune else res$model$hyperopt.res$x, fill = TRUE)
res.x = merge(res.x, getJobPars(res), all.y = FALSE)
res.x.b = res.x
hifu = function(x) {
  if (all(is.na(x))) {
    x[1:2]
  } else if (is.integer(x)) {
    as.integer(range(x, na.rm = TRUE))
  } else if (is.numeric(x)) {
    range(x, na.rm = TRUE)
  } else if (is.factor(x) | is.character(x)) {
    names(sort(table(x), decreasing = TRUE))[1:2]
  } else {
    x[1:2]
  }
}
res.x[budget > 10 & algorithm == "caret", lapply(.SD, hifu), by = .(learner)]
id.vars = c("algorithm", "fold", "learner", "budget", "search", "problem", "job.id")
col.numeric = setdiff(names(which(sapply(res.x, is.numeric))), id.vars)
m.res.x = melt(res.x[,c(id.vars, col.numeric),with = FALSE], id.vars = id.vars)
m.res.x[variable %in% c("C", "sigma"), value := log2(value)]
g = ggplot(m.res.x, mapping = aes(y = value, x = algorithm, color = learner))
g + geom_violin() + geom_point(position = position_jitter(width = 0.2, height = 0)) + facet_wrap(~variable, scales = "free")
good.caret = res.list[[10]]
good.mlrHyper = res.list[[20]]
good.caret$model$results
as.data.frame(trafoOptPath(good.mlrHyper$model$hyperopt.res$opt.path))
