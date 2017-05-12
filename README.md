
mlrHyperopt
===========

[![Build Status Linux](https://travis-ci.org/jakob-r/mlrHyperopt.svg?branch=master)](https://travis-ci.org/jakob-r/mlrHyperopt) [![Build Status Windows](https://ci.appveyor.com/api/projects/status/0nyd1gh5p19os07h?svg=true)](https://ci.appveyor.com/project/jakob-r/mlrhyperopt) [![Coverage Status](https://coveralls.io/repos/github/jakob-r/mlrHyperopt/badge.svg?branch=master)](https://coveralls.io/github/jakob-r/mlrHyperopt?branch=master)

Easy Hyper Parameter Optimization with [mlr](https://github.com/mlr-org/mlr/#-machine-learning-in-r) and [mlrMBO](http://mlr-org.github.io/mlrMBO/).

-   [Issues and Bugs](https://github.com/jakob-r/mlrHyperopt/issues)
-   [Tutorial and Documentation](https://jakob-r.github.io/mlrHyperopt)
-   [Webservice](http://mlrhyperopt.jakob-r.de/parconfigs) (Work in progress!)
    -   [Status](http://mlrhyperopt.jakob-r.de/parconfigs) (Experimental)

Installation
------------

``` r
devtools::install_github("jakob-r/mlrHyperopt")
```

Purpose
-------

*mlrHyperopt* aims at making hyperparameter optimization of machine learning methods super simple. It offers tuning in one line:

``` r
library(mlrHyperopt)
res = hyperopt(iris.task, learner = "classif.svm")
res
```

    ## Tune result:
    ## Op. pars: cost=12.6; gamma=0.0159
    ## mmce.test.mean=0.02

Mainly it uses the [learner implemented in *mlr*](http://mlr-org.github.io/mlr-tutorial/devel/html/integrated_learners/index.html) and uses the [tuning methods also available in *mlr*](http://mlr-org.github.io/mlr-tutorial/devel/html/tune/index.html). Unfortunately *mlr* lacks of well defined *search spaces* for each learner to make hyperparameter tuning easy.

*mlrHyperopt* includes default *search spaces* for the most common machine learning methods like *random forest*, *svm* and *boosting*.

As the developer can not be an expert on all machine learning methods available for *R* and *mlr*, *mlrHyperopt* also offers a web service to share, upload and download improved *search spaces*.

Development Status
------------------

### Web Server

*Under heavy construction*. *ParConfigs* are up- and downloaded via JSON and stored on the server in a database. It's a very basic Ruby on Rails CRUD App generated via scaffolding with tiny modifications <https://github.com/jakob-r/mlrHyperoptServer>. ToDo: \* Voting System \* Upload-/Download Count \* Improve API \* Return existing ID when a duplicate is uploaded (instead of error). \* Allow a combined search (intead of one key value pair).

### R package

Basic functionality works reliable. Maybe I will improve the optimization heuristics in the future. Still *needs more default search spaces* for popular learners!

### Collaboration

Is encouraged! 👍
