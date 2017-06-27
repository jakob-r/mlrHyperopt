# compare caret to mlrHyperopt

library(batchtools)
library(mlr)
library(mlrHyperopt)
library(OpenML)
library(BBmisc)
library(stringi)
library(data.table)
set.seed(030)

# define what learners to benchmark (removing gbm becaus it crashes to often, blackboost because it does not give good results at all)
lrns = data.frame(
  mlr =   c("ksvm",      "randomForest", "glmnet", "rpart", "nnet", "xgboost", "extraTrees"),
  caret = c("svmRadial", "rf",           "glmnet", "rpart", "nnet", "xgbTree", "extraTrees")
  )

# define the datasets
task_infos = listOMLTasks(tag = "study_14")
task_infos = as.data.table(task_infos)
task_infos = task_infos[number.of.missing.values == 0 & number.of.numeric.features == number.of.features - 1]
# random.task.ids = sample(task_infos$task.id, size = 10)
# dput(random.task.ids)
random.task.ids = c(18L, 9914L, 3896L, 3903L, 3510L) #, 28L, 9986L, 43L, 10101L, 14970L)
tunable.task.ids = c(9914L, 3883L, 3493L, 34536L, 9970L)
tunable.task.ids = setdiff(tunable.task.ids, random.task.ids)
oml.tasks = lapply(random.task.ids, getOMLTask)
mlr.taskslist = lapply(oml.tasks, convertOMLTaskToMlr)
names(mlr.taskslist) = extractSubList(mlr.taskslist, c("mlr.task", "task.desc", "id"))

# batchtools stuff ####
#unlink("~/nobackup/mlrHyperCaret", recursive = TRUE)
reg = makeExperimentRegistry(file.dir = "~/nobackup/mlrHyperCaret5", seed = 1, packages = c("methods","utils", "mlr", "mlrHyperopt", "BBmisc", "stringi"))
if (reg$cluster.functions$name == "Interactive") {
  reg$cluster.functions = makeClusterFunctionsMulticore(ncpus = 3)
}

## Problem generation
pdes = lapply(mlr.taskslist, function(data) {
  addProblem(name = getTaskId(data$mlr.task), data = data, fun = function(...) list(...), seed = reg$seed)
  res = list(data.frame(fold = seq_along(data$mlr.rin$train.inds)))
  res
})
pdes = unlist(pdes, recursive = FALSE)
names(pdes) = names(mlr.taskslist)

## Define Algorithm Functions
algo.caret = function(job, data, instance, learner, budget = NULL, search = "grid") {
  library(caret)
  fitControl = trainControl(method = "cv", number = 10, search = search, allowParallel = FALSE)
  train.inds = data$mlr.rin$train.inds[[instance$fold]]
  test.inds = data$mlr.rin$test.inds[[instance$fold]]
  train.data = getTaskData(data$mlr.task, target.extra = TRUE, subset = train.inds)
  test.data = getTaskData(data$mlr.task, target.extra = TRUE, subset = test.inds)
  train.args = list(x = train.data$data, y = train.data$target, method = learner, trControl = fitControl)
  if (learner == "nnet") {
    train.args = c(train.args, MaxNWts=5000) # avoids error "too many (...) weights"
  }
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
  if (learner == "nnet") {
    lrn = makeLearner(sprintf("%s.%s", learner.type, learner), MaxNWts=5000) # avoids error "too many (...) weights"
  } else {
    lrn = makeLearner(sprintf("%s.%s", learner.type, learner))
  }
  par.config = generateParConfig(learner = lrn, task = train.task)
  hc = generateHyperControl(task = train.task, par.config = par.config, budget.evals = budget * 10)
  hc$measures = data$mlr.measures
  r = hyperopt(task = train.task, hyper.control = hc, learner = lrn, par.config = par.config)
  m = train(learner = r$learner, task = train.task)
  p = predict(m, task = test.task)
  time.end = Sys.time()

  r2 = performance(pred = p, measures = data$mlr.measures, task = test.task, model = m)
  return(list(
    model = list(hyperopt.res = r, trained.model = m, all.measures = r2, hyperopt.control = hc),
    prediction = p,
    measure = r2[1],
    time = difftime(time.end, time.start, units = "secs")))
}

algo.mlrDefault = function(job, data, instance, learner, budget = NULL, search = NULL) {
  train.inds = data$mlr.rin$train.inds[[instance$fold]]
  test.inds = data$mlr.rin$test.inds[[instance$fold]]
  train.task = subsetTask(data$mlr.task, subset = train.inds)
  test.task = subsetTask(data$mlr.task, subset = test.inds)
  learner.type = stri_trans_tolower(stri_replace_all_fixed(class(train.task)[1], "Task", ""))

  time.start = Sys.time()
  if (learner == "nnet") {
    lrn = makeLearner(sprintf("%s.%s", learner.type, learner), MaxNWts=5000) # avoids error "too many (...) weights"
  } else {
    lrn = makeLearner(sprintf("%s.%s", learner.type, learner))
  }
  m = train(learner = lrn, task = train.task)
  p = predict(m, task = test.task)
  time.end = Sys.time()
  r2 = performance(pred = p, measures = data$mlr.measures, task = test.task, model = m)
  return(list(
    model = list(trained.model = m, all.measures = r2),
    prediction = p,
    measure = r2[1],
    time = difftime(time.end, time.start, units = "secs")))
}

## Add Algorithms
addAlgorithm(name = "caret", fun = algo.caret)
addAlgorithm(name = "mlrHyperopt", fun = algo.mlrHyperopt)
addAlgorithm(name = "mlrDefault", fun = algo.mlrDefault)
ades = list(
  caret = expand.grid(learner = lrns$caret, budget = c(10,50), search = c("grid", "random")),
  mlrHyperopt = expand.grid(learner = lrns$mlr, budget = c(10,50)),
  mlrDefault = expand.grid(learner = lrns$mlr)
)


## Experiments
addExperiments(pdes, ades)

### subset to a small test set
#run.ids = findExperiments(prob.name = "sonar", prob.pars = (fold %in% 1:3), algo.pars = (learner %in% c("svmRadial", "ksvm")))
run.ids = findExperiments(prob.pars = (fold %in% 1:5))
submitJobs(run.ids, sleep = 2, resources = list(memory = 16000, walltime = 24 * 60 * 60))
#testJob(548)
waitForJobs()

stop("Finished!")
##
# Finding Resuls ####
##
reg5 = loadRegistry("~/sfbrdata/nobackup/mlrHyperCaret5/", update.paths = TRUE, make.default = TRUE)
res5 = reduceResultsList(fun = function(job, res) list(job.id = job$id, measure = res$measure, time = res$time))
res5 = rbindlist(res5)
res5.backup = res5
res5 = merge(res5, getJobTable(), by = "job.id", all = TRUE)
saveRDS(res5, "meta/res5.rds")
# res5 = readRDS("meta/res5.rds")
res = res5

# helper functions ####
myrank = function(x, ties.method) {
  ranks = rank(x, na.last = TRUE, ties.method = ties.method)
  ranks[is.na(x)] = max(ranks)
  ranks
}

# matching learner names
lrns2 = as.data.table(lrns)
lrns2 = plyr::rename(lrns2, c(caret = "learner"))
res = merge(res, lrns2, all.x = TRUE, by = "learner")
res[!is.na(mlr), learner := mlr, ]

# set measure from expired jobs to worst value
res[findExpired(), measure := 0, on = "job.id"]

# find incomplete sets ####
runs.on.set = res[!is.na(measure), list(expected.folds = length(unique(fold))), by = .(learner, problem)]
res = merge(res, runs.on.set, all.x = TRUE)
res[fold < expected.folds & problem != "segment", if(expected.folds[1] != length(unique(fold))) .SD[is.na(measure),] else NULL , by = .(learner, problem, budget, algorithm, search)]

# Visualizing Results ####
res[algorithm == "mlrDefault", budget := 1]
library(ggplot2)
res$time = as.numeric(res$time, units = "secs")
g = ggplot(data = res[expected.folds == 10], aes(x = as.factor(budget), y = measure, color = paste(algorithm,search)))
g + geom_boxplot() + facet_grid(problem~learner, scales = "free")

g2 = g + geom_boxplot() + facet_wrap(c("problem", "learner"), scales = "free", ncol = length(unique(res$learner)))
ggsave("plot.pdf", g2, width = 20, height = 20)


# Time needed vs. budget
g = ggplot(data = res, aes(x = budget, y = time))
g + geom_line(aes(color = paste(algorithm,search), group = paste(algorithm,search,fold)), alpha = 0.7) + geom_point(aes(fill = measure), shape = 21) + facet_grid(learner~problem, scales = "free") + scale_y_log10()
# extract the good parameter settings

# Best Top Learner on each Dataset
mean.res = res[, list(mean.measure = mean(measure[fold <= expected.folds])), by = .(learner, problem, algorithm, budget, search)]
mean.top.res = mean.res[, {ordr = order(mean.measure, decreasing = TRUE); ordr.learner = learner[ordr]; dupl = duplicated(ordr.learner); .SD[ordr[!dupl]]} ,by = .(problem, budget, algorithm, search)]
mean.top.res = mean.top.res[, rank := rank(-mean.measure), by = .(problem, budget)]
g = ggplot(mapping = aes(x = learner, y = mean.measure, color = paste(algorithm, search)))
g + geom_point(data = mean.top.res[mean.measure > 0.5]) + geom_text(data = mean.top.res[rank < 4,], mapping = aes(label = rank), color = "black") + facet_grid(budget~problem) + coord_flip()

# Rank and average results for each learner
rank.res = res[fold <= expected.folds, list(measure = measure, rank = rank(-measure), method = paste(algorithm, search)) , by = .(problem, learner, fold, budget)]
rank.res = rank.res[, list(mean.rank = mean(rank), mean.measure = mean(measure)), by = .(problem, learner, budget, method)]
g = ggplot(rank.res, aes(x = learner, y = mean.rank, color = method))
g + geom_boxplot() + facet_grid(~budget)

# Rank and average results for each budget
g = ggplot(rank.res, aes(x = as.factor(budget), y = mean.rank, color = method))
g + geom_boxplot()

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

## find incomplete runs ####
jdt = getJobTable()
err.rate = jdt[!is.na(started), list(err.rate = mean(is.na(error))) , by = .(problem, learner, budget)]
err.rate[err.rate %nin% c(0,1)]
jdt[findExpired()]
