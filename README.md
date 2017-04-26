
mlrHyperopt
===========

[![Build Status](https://travis-ci.org/jakob-r/mlrHyperopt.svg?branch=master)](https://travis-ci.org/jakob-r/mlrHyperopt) [![Coverage Status](https://coveralls.io/repos/github/jakob-r/mlrHyperopt/badge.svg?branch=master)](https://coveralls.io/github/jakob-r/mlrHyperopt?branch=master)

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
```

    ## 
    ## optimisation start
    ## ------------------
    ## * estimation method   : MLE 
    ## * optimisation method : gen 
    ## * analytical gradient : used
    ## * trend model : ~1
    ## * covariance model : 
    ##   - type :  matern3_2 
    ##   - nugget : unknown homogenous nugget effect 
    ##   - parameters lower bounds :  1e-10 1e-10 
    ##   - parameters upper bounds :  57.54937 49.4585 
    ##   - upper bound for alpha   :  1 
    ##   - best initial criterion value(s) :  -1.728506 
    ## 
    ## 
    ## Wed Apr 19 21:45:29 2017
    ## Domains:
    ##  1.000000e-10   <=  X1   <=    5.754937e+01 
    ##  1.000000e-10   <=  X2   <=    4.945850e+01 
    ##  0.000000e+00   <=  X3   <=    1.000000e+00 
    ## 
    ## NOTE: The total number of operators greater than population size
    ## NOTE: I'm increasing the population size to 10 (operators+1).
    ## 
    ## Data Type: Floating Point
    ## Operators (code number, name, population) 
    ##  (1) Cloning...........................  0
    ##  (2) Uniform Mutation..................  1
    ##  (3) Boundary Mutation.................  1
    ##  (4) Non-Uniform Mutation..............  1
    ##  (5) Polytope Crossover................  1
    ##  (6) Simple Crossover..................  2
    ##  (7) Whole Non-Uniform Mutation........  1
    ##  (8) Heuristic Crossover...............  2
    ##  (9) Local-Minimum Crossover...........  0
    ## 
    ## HARD Maximum Number of Generations: 5
    ## Maximum Nonchanging Generations: 2
    ## Population size       : 10
    ## Convergence Tolerance: 1.000000e-03
    ## 
    ## Using the BFGS Derivative Based Optimizer on the Best Individual Each Generation.
    ## Not Checking Gradients before Stopping.
    ## Not Using Out of Bounds Individuals and Not Allowing Trespassing.
    ## 
    ## Maximization Problem.
    ## 
    ## 
    ## Generation#      Solution Value
    ## 
    ##       0  -1.516605e+00
    ##       1  -2.277856e-01
    ## 
    ## 'wait.generations' limit reached.
    ## No significant improvement in 2 generations.
    ## 
    ## Solution Fitness Value: -2.277856e-01
    ## 
    ## Parameters at the Solution (parameter, gradient):
    ## 
    ##  X[ 1] : 1.276321e+01    G[ 1] : -8.657705e-08
    ##  X[ 2] : 1.741251e+01    G[ 2] : -3.664552e-08
    ##  X[ 3] : 1.000000e+00    G[ 3] : 4.637053e+00
    ## 
    ## Solution Found Generation 1
    ## Number of Generations Run 4
    ## 
    ## Wed Apr 19 21:45:29 2017
    ## Total run time : 0 hours 0 minutes and 0 seconds
    ## 
    ## optimisation start
    ## ------------------
    ## * estimation method   : MLE 
    ## * optimisation method : gen 
    ## * analytical gradient : used
    ## * trend model : ~1
    ## * covariance model : 
    ##   - type :  matern3_2 
    ##   - nugget : unknown homogenous nugget effect 
    ##   - parameters lower bounds :  1e-10 1e-10 
    ##   - parameters upper bounds :  57.54937 49.4585 
    ##   - upper bound for alpha   :  1 
    ##   - best initial criterion value(s) :  -0.6359012 
    ## 
    ## 
    ## Wed Apr 19 21:45:29 2017
    ## Domains:
    ##  1.000000e-10   <=  X1   <=    5.754937e+01 
    ##  1.000000e-10   <=  X2   <=    4.945850e+01 
    ##  0.000000e+00   <=  X3   <=    1.000000e+00 
    ## 
    ## NOTE: The total number of operators greater than population size
    ## NOTE: I'm increasing the population size to 10 (operators+1).
    ## 
    ## Data Type: Floating Point
    ## Operators (code number, name, population) 
    ##  (1) Cloning...........................  0
    ##  (2) Uniform Mutation..................  1
    ##  (3) Boundary Mutation.................  1
    ##  (4) Non-Uniform Mutation..............  1
    ##  (5) Polytope Crossover................  1
    ##  (6) Simple Crossover..................  2
    ##  (7) Whole Non-Uniform Mutation........  1
    ##  (8) Heuristic Crossover...............  2
    ##  (9) Local-Minimum Crossover...........  0
    ## 
    ## HARD Maximum Number of Generations: 5
    ## Maximum Nonchanging Generations: 2
    ## Population size       : 10
    ## Convergence Tolerance: 1.000000e-03
    ## 
    ## Using the BFGS Derivative Based Optimizer on the Best Individual Each Generation.
    ## Not Checking Gradients before Stopping.
    ## Not Using Out of Bounds Individuals and Not Allowing Trespassing.
    ## 
    ## Maximization Problem.
    ## 
    ## 
    ## Generation#      Solution Value
    ## 
    ##       0  9.545410e-03
    ##       1  1.052585e+00
    ## 
    ## 'wait.generations' limit reached.
    ## No significant improvement in 2 generations.
    ## 
    ## Solution Fitness Value: 1.052585e+00
    ## 
    ## Parameters at the Solution (parameter, gradient):
    ## 
    ##  X[ 1] : 1.446439e+01    G[ 1] : 1.775599e-08
    ##  X[ 2] : 2.059991e+01    G[ 2] : 1.969461e-09
    ##  X[ 3] : 1.000000e+00    G[ 3] : 1.185018e+01
    ## 
    ## Solution Found Generation 1
    ## Number of Generations Run 4
    ## 
    ## Wed Apr 19 21:45:29 2017
    ## Total run time : 0 hours 0 minutes and 0 seconds
    ## 
    ## optimisation start
    ## ------------------
    ## * estimation method   : MLE 
    ## * optimisation method : gen 
    ## * analytical gradient : used
    ## * trend model : ~1
    ## * covariance model : 
    ##   - type :  matern3_2 
    ##   - nugget : unknown homogenous nugget effect 
    ##   - parameters lower bounds :  1e-10 1e-10 
    ##   - parameters upper bounds :  59.52233 49.4585 
    ##   - upper bound for alpha   :  1 
    ##   - best initial criterion value(s) :  -0.1088723 
    ## 
    ## 
    ## Wed Apr 19 21:45:30 2017
    ## Domains:
    ##  1.000000e-10   <=  X1   <=    5.952233e+01 
    ##  1.000000e-10   <=  X2   <=    4.945850e+01 
    ##  0.000000e+00   <=  X3   <=    1.000000e+00 
    ## 
    ## NOTE: The total number of operators greater than population size
    ## NOTE: I'm increasing the population size to 10 (operators+1).
    ## 
    ## Data Type: Floating Point
    ## Operators (code number, name, population) 
    ##  (1) Cloning...........................  0
    ##  (2) Uniform Mutation..................  1
    ##  (3) Boundary Mutation.................  1
    ##  (4) Non-Uniform Mutation..............  1
    ##  (5) Polytope Crossover................  1
    ##  (6) Simple Crossover..................  2
    ##  (7) Whole Non-Uniform Mutation........  1
    ##  (8) Heuristic Crossover...............  2
    ##  (9) Local-Minimum Crossover...........  0
    ## 
    ## HARD Maximum Number of Generations: 5
    ## Maximum Nonchanging Generations: 2
    ## Population size       : 10
    ## Convergence Tolerance: 1.000000e-03
    ## 
    ## Using the BFGS Derivative Based Optimizer on the Best Individual Each Generation.
    ## Not Checking Gradients before Stopping.
    ## Not Using Out of Bounds Individuals and Not Allowing Trespassing.
    ## 
    ## Maximization Problem.
    ## 
    ## 
    ## Generation#      Solution Value
    ## 
    ##       0  6.283544e-03
    ##       1  2.305719e+00
    ## 
    ## 'wait.generations' limit reached.
    ## No significant improvement in 2 generations.
    ## 
    ## Solution Fitness Value: 2.305719e+00
    ## 
    ## Parameters at the Solution (parameter, gradient):
    ## 
    ##  X[ 1] : 1.563380e+01    G[ 1] : 4.666864e-08
    ##  X[ 2] : 2.362199e+01    G[ 2] : 1.507032e-09
    ##  X[ 3] : 1.000000e+00    G[ 3] : 2.622396e+01
    ## 
    ## Solution Found Generation 1
    ## Number of Generations Run 4
    ## 
    ## Wed Apr 19 21:45:30 2017
    ## Total run time : 0 hours 0 minutes and 0 seconds
    ## 
    ## optimisation start
    ## ------------------
    ## * estimation method   : MLE 
    ## * optimisation method : gen 
    ## * analytical gradient : used
    ## * trend model : ~1
    ## * covariance model : 
    ##   - type :  matern3_2 
    ##   - nugget : unknown homogenous nugget effect 
    ##   - parameters lower bounds :  1e-10 1e-10 
    ##   - parameters upper bounds :  59.52233 49.4585 
    ##   - upper bound for alpha   :  1 
    ##   - best initial criterion value(s) :  2.17275 
    ## 
    ## 
    ## Wed Apr 19 21:45:30 2017
    ## Domains:
    ##  1.000000e-10   <=  X1   <=    5.952233e+01 
    ##  1.000000e-10   <=  X2   <=    4.945850e+01 
    ##  0.000000e+00   <=  X3   <=    1.000000e+00 
    ## 
    ## NOTE: The total number of operators greater than population size
    ## NOTE: I'm increasing the population size to 10 (operators+1).
    ## 
    ## Data Type: Floating Point
    ## Operators (code number, name, population) 
    ##  (1) Cloning...........................  0
    ##  (2) Uniform Mutation..................  1
    ##  (3) Boundary Mutation.................  1
    ##  (4) Non-Uniform Mutation..............  1
    ##  (5) Polytope Crossover................  1
    ##  (6) Simple Crossover..................  2
    ##  (7) Whole Non-Uniform Mutation........  1
    ##  (8) Heuristic Crossover...............  2
    ##  (9) Local-Minimum Crossover...........  0
    ## 
    ## HARD Maximum Number of Generations: 5
    ## Maximum Nonchanging Generations: 2
    ## Population size       : 10
    ## Convergence Tolerance: 1.000000e-03
    ## 
    ## Using the BFGS Derivative Based Optimizer on the Best Individual Each Generation.
    ## Not Checking Gradients before Stopping.
    ## Not Using Out of Bounds Individuals and Not Allowing Trespassing.
    ## 
    ## Maximization Problem.
    ## 
    ## 
    ## Generation#      Solution Value
    ## 
    ##       0  2.172750e+00
    ##       1  4.240402e+00
    ## 
    ## 'wait.generations' limit reached.
    ## No significant improvement in 2 generations.
    ## 
    ## Solution Fitness Value: 4.240402e+00
    ## 
    ## Parameters at the Solution (parameter, gradient):
    ## 
    ##  X[ 1] : 1.819928e+01    G[ 1] : 2.021777e-10
    ##  X[ 2] : 2.483490e+01    G[ 2] : -5.108358e-10
    ##  X[ 3] : 1.000000e+00    G[ 3] : 6.635598e+01
    ## 
    ## Solution Found Generation 1
    ## Number of Generations Run 4
    ## 
    ## Wed Apr 19 21:45:30 2017
    ## Total run time : 0 hours 0 minutes and 0 seconds
    ## 
    ## optimisation start
    ## ------------------
    ## * estimation method   : MLE 
    ## * optimisation method : gen 
    ## * analytical gradient : used
    ## * trend model : ~1
    ## * covariance model : 
    ##   - type :  matern3_2 
    ##   - nugget : unknown homogenous nugget effect 
    ##   - parameters lower bounds :  1e-10 1e-10 
    ##   - parameters upper bounds :  59.52233 49.4585 
    ##   - upper bound for alpha   :  1 
    ##   - best initial criterion value(s) :  4.833084 
    ## 
    ## 
    ## Wed Apr 19 21:45:30 2017
    ## Domains:
    ##  1.000000e-10   <=  X1   <=    5.952233e+01 
    ##  1.000000e-10   <=  X2   <=    4.945850e+01 
    ##  0.000000e+00   <=  X3   <=    1.000000e+00 
    ## 
    ## NOTE: The total number of operators greater than population size
    ## NOTE: I'm increasing the population size to 10 (operators+1).
    ## 
    ## Data Type: Floating Point
    ## Operators (code number, name, population) 
    ##  (1) Cloning...........................  0
    ##  (2) Uniform Mutation..................  1
    ##  (3) Boundary Mutation.................  1
    ##  (4) Non-Uniform Mutation..............  1
    ##  (5) Polytope Crossover................  1
    ##  (6) Simple Crossover..................  2
    ##  (7) Whole Non-Uniform Mutation........  1
    ##  (8) Heuristic Crossover...............  2
    ##  (9) Local-Minimum Crossover...........  0
    ## 
    ## HARD Maximum Number of Generations: 5
    ## Maximum Nonchanging Generations: 2
    ## Population size       : 10
    ## Convergence Tolerance: 1.000000e-03
    ## 
    ## Using the BFGS Derivative Based Optimizer on the Best Individual Each Generation.
    ## Not Checking Gradients before Stopping.
    ## Not Using Out of Bounds Individuals and Not Allowing Trespassing.
    ## 
    ## Maximization Problem.
    ## 
    ## 
    ## Generation#      Solution Value
    ## 
    ##       0  4.833084e+00
    ##       1  6.630977e+00
    ## 
    ## 'wait.generations' limit reached.
    ## No significant improvement in 2 generations.
    ## 
    ## Solution Fitness Value: 6.630977e+00
    ## 
    ## Parameters at the Solution (parameter, gradient):
    ## 
    ##  X[ 1] : 2.063412e+01    G[ 1] : 1.727664e-07
    ##  X[ 2] : 2.608987e+01    G[ 2] : -4.478506e-08
    ##  X[ 3] : 1.000000e+00    G[ 3] : 1.976078e+02
    ## 
    ## Solution Found Generation 1
    ## Number of Generations Run 4
    ## 
    ## Wed Apr 19 21:45:30 2017
    ## Total run time : 0 hours 0 minutes and 0 seconds
    ## 
    ## optimisation start
    ## ------------------
    ## * estimation method   : MLE 
    ## * optimisation method : gen 
    ## * analytical gradient : used
    ## * trend model : ~1
    ## * covariance model : 
    ##   - type :  matern3_2 
    ##   - nugget : unknown homogenous nugget effect 
    ##   - parameters lower bounds :  1e-10 1e-10 
    ##   - parameters upper bounds :  59.52816 49.4585 
    ##   - upper bound for alpha   :  1 
    ##   - best initial criterion value(s) :  4.302414 
    ## 
    ## 
    ## Wed Apr 19 21:45:30 2017
    ## Domains:
    ##  1.000000e-10   <=  X1   <=    5.952816e+01 
    ##  1.000000e-10   <=  X2   <=    4.945850e+01 
    ##  0.000000e+00   <=  X3   <=    1.000000e+00 
    ## 
    ## NOTE: The total number of operators greater than population size
    ## NOTE: I'm increasing the population size to 10 (operators+1).
    ## 
    ## Data Type: Floating Point
    ## Operators (code number, name, population) 
    ##  (1) Cloning...........................  0
    ##  (2) Uniform Mutation..................  1
    ##  (3) Boundary Mutation.................  1
    ##  (4) Non-Uniform Mutation..............  1
    ##  (5) Polytope Crossover................  1
    ##  (6) Simple Crossover..................  2
    ##  (7) Whole Non-Uniform Mutation........  1
    ##  (8) Heuristic Crossover...............  2
    ##  (9) Local-Minimum Crossover...........  0
    ## 
    ## HARD Maximum Number of Generations: 5
    ## Maximum Nonchanging Generations: 2
    ## Population size       : 10
    ## Convergence Tolerance: 1.000000e-03
    ## 
    ## Using the BFGS Derivative Based Optimizer on the Best Individual Each Generation.
    ## Not Checking Gradients before Stopping.
    ## Not Using Out of Bounds Individuals and Not Allowing Trespassing.
    ## 
    ## Maximization Problem.
    ## 
    ## 
    ## Generation#      Solution Value
    ## 
    ##       0  4.542252e+00
    ##       1  9.146525e+00
    ## 
    ## 'wait.generations' limit reached.
    ## No significant improvement in 2 generations.
    ## 
    ## Solution Fitness Value: 9.146525e+00
    ## 
    ## Parameters at the Solution (parameter, gradient):
    ## 
    ##  X[ 1] : 2.080471e+01    G[ 1] : 1.214203e-07
    ##  X[ 2] : 2.594929e+01    G[ 2] : 8.020699e-08
    ##  X[ 3] : 1.000000e+00    G[ 3] : 2.278624e+02
    ## 
    ## Solution Found Generation 1
    ## Number of Generations Run 4
    ## 
    ## Wed Apr 19 21:45:30 2017
    ## Total run time : 0 hours 0 minutes and 0 seconds
    ## 
    ## optimisation start
    ## ------------------
    ## * estimation method   : MLE 
    ## * optimisation method : gen 
    ## * analytical gradient : used
    ## * trend model : ~1
    ## * covariance model : 
    ##   - type :  matern3_2 
    ##   - nugget : unknown homogenous nugget effect 
    ##   - parameters lower bounds :  1e-10 1e-10 
    ##   - parameters upper bounds :  59.52816 55.22778 
    ##   - upper bound for alpha   :  1 
    ##   - best initial criterion value(s) :  6.822623 
    ## 
    ## 
    ## Wed Apr 19 21:45:31 2017
    ## Domains:
    ##  1.000000e-10   <=  X1   <=    5.952816e+01 
    ##  1.000000e-10   <=  X2   <=    5.522778e+01 
    ##  0.000000e+00   <=  X3   <=    1.000000e+00 
    ## 
    ## NOTE: The total number of operators greater than population size
    ## NOTE: I'm increasing the population size to 10 (operators+1).
    ## 
    ## Data Type: Floating Point
    ## Operators (code number, name, population) 
    ##  (1) Cloning...........................  0
    ##  (2) Uniform Mutation..................  1
    ##  (3) Boundary Mutation.................  1
    ##  (4) Non-Uniform Mutation..............  1
    ##  (5) Polytope Crossover................  1
    ##  (6) Simple Crossover..................  2
    ##  (7) Whole Non-Uniform Mutation........  1
    ##  (8) Heuristic Crossover...............  2
    ##  (9) Local-Minimum Crossover...........  0
    ## 
    ## HARD Maximum Number of Generations: 5
    ## Maximum Nonchanging Generations: 2
    ## Population size       : 10
    ## Convergence Tolerance: 1.000000e-03
    ## 
    ## Using the BFGS Derivative Based Optimizer on the Best Individual Each Generation.
    ## Not Checking Gradients before Stopping.
    ## Not Using Out of Bounds Individuals and Not Allowing Trespassing.
    ## 
    ## Maximization Problem.
    ## 
    ## 
    ## Generation#      Solution Value
    ## 
    ##       0  6.822623e+00
    ##       1  1.042780e+01
    ## 
    ## 'wait.generations' limit reached.
    ## No significant improvement in 2 generations.
    ## 
    ## Solution Fitness Value: 1.042780e+01
    ## 
    ## Parameters at the Solution (parameter, gradient):
    ## 
    ##  X[ 1] : 2.048496e+01    G[ 1] : 6.569952e-08
    ##  X[ 2] : 2.754159e+01    G[ 2] : 1.211415e-07
    ##  X[ 3] : 1.000000e+00    G[ 3] : 3.532754e+02
    ## 
    ## Solution Found Generation 1
    ## Number of Generations Run 4
    ## 
    ## Wed Apr 19 21:45:31 2017
    ## Total run time : 0 hours 0 minutes and 0 seconds
    ## 
    ## optimisation start
    ## ------------------
    ## * estimation method   : MLE 
    ## * optimisation method : gen 
    ## * analytical gradient : used
    ## * trend model : ~1
    ## * covariance model : 
    ##   - type :  matern3_2 
    ##   - nugget : unknown homogenous nugget effect 
    ##   - parameters lower bounds :  1e-10 1e-10 
    ##   - parameters upper bounds :  59.52816 55.22778 
    ##   - upper bound for alpha   :  1 
    ##   - best initial criterion value(s) :  9.786363 
    ## 
    ## 
    ## Wed Apr 19 21:45:31 2017
    ## Domains:
    ##  1.000000e-10   <=  X1   <=    5.952816e+01 
    ##  1.000000e-10   <=  X2   <=    5.522778e+01 
    ##  0.000000e+00   <=  X3   <=    1.000000e+00 
    ## 
    ## NOTE: The total number of operators greater than population size
    ## NOTE: I'm increasing the population size to 10 (operators+1).
    ## 
    ## Data Type: Floating Point
    ## Operators (code number, name, population) 
    ##  (1) Cloning...........................  0
    ##  (2) Uniform Mutation..................  1
    ##  (3) Boundary Mutation.................  1
    ##  (4) Non-Uniform Mutation..............  1
    ##  (5) Polytope Crossover................  1
    ##  (6) Simple Crossover..................  2
    ##  (7) Whole Non-Uniform Mutation........  1
    ##  (8) Heuristic Crossover...............  2
    ##  (9) Local-Minimum Crossover...........  0
    ## 
    ## HARD Maximum Number of Generations: 5
    ## Maximum Nonchanging Generations: 2
    ## Population size       : 10
    ## Convergence Tolerance: 1.000000e-03
    ## 
    ## Using the BFGS Derivative Based Optimizer on the Best Individual Each Generation.
    ## Not Checking Gradients before Stopping.
    ## Not Using Out of Bounds Individuals and Not Allowing Trespassing.
    ## 
    ## Maximization Problem.
    ## 
    ## 
    ## Generation#      Solution Value
    ## 
    ##       0  9.786363e+00
    ##       1  1.343053e+01
    ## 
    ## 'wait.generations' limit reached.
    ## No significant improvement in 2 generations.
    ## 
    ## Solution Fitness Value: 1.343053e+01
    ## 
    ## Parameters at the Solution (parameter, gradient):
    ## 
    ##  X[ 1] : 2.169414e+01    G[ 1] : -1.779119e-07
    ##  X[ 2] : 2.958802e+01    G[ 2] : 1.535481e-07
    ##  X[ 3] : 1.000000e+00    G[ 3] : 8.857490e+02
    ## 
    ## Solution Found Generation 1
    ## Number of Generations Run 4
    ## 
    ## Wed Apr 19 21:45:31 2017
    ## Total run time : 0 hours 0 minutes and 0 seconds
    ## 
    ## optimisation start
    ## ------------------
    ## * estimation method   : MLE 
    ## * optimisation method : gen 
    ## * analytical gradient : used
    ## * trend model : ~1
    ## * covariance model : 
    ##   - type :  matern3_2 
    ##   - nugget : unknown homogenous nugget effect 
    ##   - parameters lower bounds :  1e-10 1e-10 
    ##   - parameters upper bounds :  59.52816 55.22778 
    ##   - upper bound for alpha   :  1 
    ##   - best initial criterion value(s) :  7.208179 
    ## 
    ## 
    ## Wed Apr 19 21:45:32 2017
    ## Domains:
    ##  1.000000e-10   <=  X1   <=    5.952816e+01 
    ##  1.000000e-10   <=  X2   <=    5.522778e+01 
    ##  0.000000e+00   <=  X3   <=    1.000000e+00 
    ## 
    ## NOTE: The total number of operators greater than population size
    ## NOTE: I'm increasing the population size to 10 (operators+1).
    ## 
    ## Data Type: Floating Point
    ## Operators (code number, name, population) 
    ##  (1) Cloning...........................  0
    ##  (2) Uniform Mutation..................  1
    ##  (3) Boundary Mutation.................  1
    ##  (4) Non-Uniform Mutation..............  1
    ##  (5) Polytope Crossover................  1
    ##  (6) Simple Crossover..................  2
    ##  (7) Whole Non-Uniform Mutation........  1
    ##  (8) Heuristic Crossover...............  2
    ##  (9) Local-Minimum Crossover...........  0
    ## 
    ## HARD Maximum Number of Generations: 5
    ## Maximum Nonchanging Generations: 2
    ## Population size       : 10
    ## Convergence Tolerance: 1.000000e-03
    ## 
    ## Using the BFGS Derivative Based Optimizer on the Best Individual Each Generation.
    ## Not Checking Gradients before Stopping.
    ## Not Using Out of Bounds Individuals and Not Allowing Trespassing.
    ## 
    ## Maximization Problem.
    ## 
    ## 
    ## Generation#      Solution Value
    ## 
    ##       0  7.208179e+00
    ##       1  1.606341e+01
    ##       2  1.630456e+01
    ##       3  1.632639e+01
    ##       4  1.632890e+01
    ## 
    ## NOTE: HARD MAXIMUM GENERATION LIMIT HIT
    ## 
    ## Solution Fitness Value: 1.632909e+01
    ## 
    ## Parameters at the Solution (parameter, gradient):
    ## 
    ##  X[ 1] : 2.302257e+01    G[ 1] : -3.059566e-04
    ##  X[ 2] : 3.144252e+01    G[ 2] : -3.207895e-04
    ##  X[ 3] : 1.000000e+00    G[ 3] : 1.199636e+03
    ## 
    ## Solution Found Generation 4
    ## Number of Generations Run 5
    ## 
    ## Wed Apr 19 21:45:32 2017
    ## Total run time : 0 hours 0 minutes and 0 seconds
    ## 
    ## optimisation start
    ## ------------------
    ## * estimation method   : MLE 
    ## * optimisation method : gen 
    ## * analytical gradient : used
    ## * trend model : ~1
    ## * covariance model : 
    ##   - type :  matern3_2 
    ##   - nugget : unknown homogenous nugget effect 
    ##   - parameters lower bounds :  1e-10 1e-10 
    ##   - parameters upper bounds :  59.52816 55.22778 
    ##   - upper bound for alpha   :  1 
    ##   - best initial criterion value(s) :  10.37411 
    ## 
    ## 
    ## Wed Apr 19 21:45:32 2017
    ## Domains:
    ##  1.000000e-10   <=  X1   <=    5.952816e+01 
    ##  1.000000e-10   <=  X2   <=    5.522778e+01 
    ##  0.000000e+00   <=  X3   <=    1.000000e+00 
    ## 
    ## NOTE: The total number of operators greater than population size
    ## NOTE: I'm increasing the population size to 10 (operators+1).
    ## 
    ## Data Type: Floating Point
    ## Operators (code number, name, population) 
    ##  (1) Cloning...........................  0
    ##  (2) Uniform Mutation..................  1
    ##  (3) Boundary Mutation.................  1
    ##  (4) Non-Uniform Mutation..............  1
    ##  (5) Polytope Crossover................  1
    ##  (6) Simple Crossover..................  2
    ##  (7) Whole Non-Uniform Mutation........  1
    ##  (8) Heuristic Crossover...............  2
    ##  (9) Local-Minimum Crossover...........  0
    ## 
    ## HARD Maximum Number of Generations: 5
    ## Maximum Nonchanging Generations: 2
    ## Population size       : 10
    ## Convergence Tolerance: 1.000000e-03
    ## 
    ## Using the BFGS Derivative Based Optimizer on the Best Individual Each Generation.
    ## Not Checking Gradients before Stopping.
    ## Not Using Out of Bounds Individuals and Not Allowing Trespassing.
    ## 
    ## Maximization Problem.
    ## 
    ## 
    ## Generation#      Solution Value
    ## 
    ##       0  1.037411e+01
    ##       1  1.971900e+01
    ##       2  1.974575e+01
    ##       3  1.975389e+01
    ##       4  1.975620e+01
    ## 
    ## NOTE: HARD MAXIMUM GENERATION LIMIT HIT
    ## 
    ## Solution Fitness Value: 1.975693e+01
    ## 
    ## Parameters at the Solution (parameter, gradient):
    ## 
    ##  X[ 1] : 2.413263e+01    G[ 1] : 2.065036e-03
    ##  X[ 2] : 3.172811e+01    G[ 2] : 1.010774e-03
    ##  X[ 3] : 1.000000e+00    G[ 3] : 2.190372e+03
    ## 
    ## Solution Found Generation 4
    ## Number of Generations Run 5
    ## 
    ## Wed Apr 19 21:45:32 2017
    ## Total run time : 0 hours 0 minutes and 0 seconds
    ## 
    ## optimisation start
    ## ------------------
    ## * estimation method   : MLE 
    ## * optimisation method : gen 
    ## * analytical gradient : used
    ## * trend model : ~1
    ## * covariance model : 
    ##   - type :  matern3_2 
    ##   - nugget : unknown homogenous nugget effect 
    ##   - parameters lower bounds :  1e-10 1e-10 
    ##   - parameters upper bounds :  59.52816 55.22778 
    ##   - upper bound for alpha   :  1 
    ##   - best initial criterion value(s) :  17.83645 
    ## 
    ## 
    ## Wed Apr 19 21:45:32 2017
    ## Domains:
    ##  1.000000e-10   <=  X1   <=    5.952816e+01 
    ##  1.000000e-10   <=  X2   <=    5.522778e+01 
    ##  0.000000e+00   <=  X3   <=    1.000000e+00 
    ## 
    ## NOTE: The total number of operators greater than population size
    ## NOTE: I'm increasing the population size to 10 (operators+1).
    ## 
    ## Data Type: Floating Point
    ## Operators (code number, name, population) 
    ##  (1) Cloning...........................  0
    ##  (2) Uniform Mutation..................  1
    ##  (3) Boundary Mutation.................  1
    ##  (4) Non-Uniform Mutation..............  1
    ##  (5) Polytope Crossover................  1
    ##  (6) Simple Crossover..................  2
    ##  (7) Whole Non-Uniform Mutation........  1
    ##  (8) Heuristic Crossover...............  2
    ##  (9) Local-Minimum Crossover...........  0
    ## 
    ## HARD Maximum Number of Generations: 5
    ## Maximum Nonchanging Generations: 2
    ## Population size       : 10
    ## Convergence Tolerance: 1.000000e-03
    ## 
    ## Using the BFGS Derivative Based Optimizer on the Best Individual Each Generation.
    ## Not Checking Gradients before Stopping.
    ## Not Using Out of Bounds Individuals and Not Allowing Trespassing.
    ## 
    ## Maximization Problem.
    ## 
    ## 
    ## Generation#      Solution Value
    ## 
    ##       0  1.783645e+01
    ##       1  2.359519e+01
    ## 
    ## 'wait.generations' limit reached.
    ## No significant improvement in 2 generations.
    ## 
    ## Solution Fitness Value: 2.359519e+01
    ## 
    ## Parameters at the Solution (parameter, gradient):
    ## 
    ##  X[ 1] : 2.479107e+01    G[ 1] : 1.029548e-07
    ##  X[ 2] : 3.314570e+01    G[ 2] : 1.148379e-07
    ##  X[ 3] : 1.000000e+00    G[ 3] : 6.592383e+03
    ## 
    ## Solution Found Generation 1
    ## Number of Generations Run 4
    ## 
    ## Wed Apr 19 21:45:32 2017
    ## Total run time : 0 hours 0 minutes and 0 seconds
    ## 
    ## optimisation start
    ## ------------------
    ## * estimation method   : MLE 
    ## * optimisation method : gen 
    ## * analytical gradient : used
    ## * trend model : ~1
    ## * covariance model : 
    ##   - type :  matern3_2 
    ##   - nugget : unknown homogenous nugget effect 
    ##   - parameters lower bounds :  1e-10 1e-10 
    ##   - parameters upper bounds :  59.52816 55.22778 
    ##   - upper bound for alpha   :  1 
    ##   - best initial criterion value(s) :  21.48339 
    ## 
    ## 
    ## Wed Apr 19 21:45:32 2017
    ## Domains:
    ##  1.000000e-10   <=  X1   <=    5.952816e+01 
    ##  1.000000e-10   <=  X2   <=    5.522778e+01 
    ##  0.000000e+00   <=  X3   <=    1.000000e+00 
    ## 
    ## NOTE: The total number of operators greater than population size
    ## NOTE: I'm increasing the population size to 10 (operators+1).
    ## 
    ## Data Type: Floating Point
    ## Operators (code number, name, population) 
    ##  (1) Cloning...........................  0
    ##  (2) Uniform Mutation..................  1
    ##  (3) Boundary Mutation.................  1
    ##  (4) Non-Uniform Mutation..............  1
    ##  (5) Polytope Crossover................  1
    ##  (6) Simple Crossover..................  2
    ##  (7) Whole Non-Uniform Mutation........  1
    ##  (8) Heuristic Crossover...............  2
    ##  (9) Local-Minimum Crossover...........  0
    ## 
    ## HARD Maximum Number of Generations: 5
    ## Maximum Nonchanging Generations: 2
    ## Population size       : 10
    ## Convergence Tolerance: 1.000000e-03
    ## 
    ## Using the BFGS Derivative Based Optimizer on the Best Individual Each Generation.
    ## Not Checking Gradients before Stopping.
    ## Not Using Out of Bounds Individuals and Not Allowing Trespassing.
    ## 
    ## Maximization Problem.
    ## 
    ## 
    ## Generation#      Solution Value
    ## 
    ##       0  2.148339e+01
    ##       1  2.467529e+01
    ##       2  2.475051e+01
    ##       3  2.534657e+01
    ##       5  2.542407e+01
    ## 
    ## NOTE: HARD MAXIMUM GENERATION LIMIT HIT
    ## 
    ## Solution Fitness Value: 2.542407e+01
    ## 
    ## Parameters at the Solution (parameter, gradient):
    ## 
    ##  X[ 1] : 2.204265e+01    G[ 1] : 3.234235e-03
    ##  X[ 2] : 3.019398e+01    G[ 2] : 1.433950e-02
    ##  X[ 3] : 9.997585e-01    G[ 3] : 2.823167e-02
    ## 
    ## Solution Found Generation 5
    ## Number of Generations Run 5
    ## 
    ## Wed Apr 19 21:45:32 2017
    ## Total run time : 0 hours 0 minutes and 0 seconds
    ## 
    ## optimisation start
    ## ------------------
    ## * estimation method   : MLE 
    ## * optimisation method : gen 
    ## * analytical gradient : used
    ## * trend model : ~1
    ## * covariance model : 
    ##   - type :  matern3_2 
    ##   - nugget : unknown homogenous nugget effect 
    ##   - parameters lower bounds :  1e-10 1e-10 
    ##   - parameters upper bounds :  59.52816 55.22778 
    ##   - upper bound for alpha   :  1 
    ##   - best initial criterion value(s) :  10.09561 
    ## 
    ## 
    ## Wed Apr 19 21:45:33 2017
    ## Domains:
    ##  1.000000e-10   <=  X1   <=    5.952816e+01 
    ##  1.000000e-10   <=  X2   <=    5.522778e+01 
    ##  0.000000e+00   <=  X3   <=    1.000000e+00 
    ## 
    ## NOTE: The total number of operators greater than population size
    ## NOTE: I'm increasing the population size to 10 (operators+1).
    ## 
    ## Data Type: Floating Point
    ## Operators (code number, name, population) 
    ##  (1) Cloning...........................  0
    ##  (2) Uniform Mutation..................  1
    ##  (3) Boundary Mutation.................  1
    ##  (4) Non-Uniform Mutation..............  1
    ##  (5) Polytope Crossover................  1
    ##  (6) Simple Crossover..................  2
    ##  (7) Whole Non-Uniform Mutation........  1
    ##  (8) Heuristic Crossover...............  2
    ##  (9) Local-Minimum Crossover...........  0
    ## 
    ## HARD Maximum Number of Generations: 5
    ## Maximum Nonchanging Generations: 2
    ## Population size       : 10
    ## Convergence Tolerance: 1.000000e-03
    ## 
    ## Using the BFGS Derivative Based Optimizer on the Best Individual Each Generation.
    ## Not Checking Gradients before Stopping.
    ## Not Using Out of Bounds Individuals and Not Allowing Trespassing.
    ## 
    ## Maximization Problem.
    ## 
    ## 
    ## Generation#      Solution Value
    ## 
    ##       0  1.009561e+01
    ##       1  2.853310e+01
    ##       3  2.874567e+01
    ##       4  2.884311e+01
    ## 
    ## NOTE: HARD MAXIMUM GENERATION LIMIT HIT
    ## 
    ## Solution Fitness Value: 2.884311e+01
    ## 
    ## Parameters at the Solution (parameter, gradient):
    ## 
    ##  X[ 1] : 2.575359e+01    G[ 1] : -2.978065e-02
    ##  X[ 2] : 3.580520e+01    G[ 2] : -1.384511e-02
    ##  X[ 3] : 9.998468e-01    G[ 3] : 5.859134e-01
    ## 
    ## Solution Found Generation 4
    ## Number of Generations Run 5
    ## 
    ## Wed Apr 19 21:45:33 2017
    ## Total run time : 0 hours 0 minutes and 0 seconds
    ## 
    ## optimisation start
    ## ------------------
    ## * estimation method   : MLE 
    ## * optimisation method : gen 
    ## * analytical gradient : used
    ## * trend model : ~1
    ## * covariance model : 
    ##   - type :  matern3_2 
    ##   - nugget : unknown homogenous nugget effect 
    ##   - parameters lower bounds :  1e-10 1e-10 
    ##   - parameters upper bounds :  59.52816 55.22778 
    ##   - upper bound for alpha   :  1 
    ##   - best initial criterion value(s) :  14.88371 
    ## 
    ## 
    ## Wed Apr 19 21:45:33 2017
    ## Domains:
    ##  1.000000e-10   <=  X1   <=    5.952816e+01 
    ##  1.000000e-10   <=  X2   <=    5.522778e+01 
    ##  0.000000e+00   <=  X3   <=    1.000000e+00 
    ## 
    ## NOTE: The total number of operators greater than population size
    ## NOTE: I'm increasing the population size to 10 (operators+1).
    ## 
    ## Data Type: Floating Point
    ## Operators (code number, name, population) 
    ##  (1) Cloning...........................  0
    ##  (2) Uniform Mutation..................  1
    ##  (3) Boundary Mutation.................  1
    ##  (4) Non-Uniform Mutation..............  1
    ##  (5) Polytope Crossover................  1
    ##  (6) Simple Crossover..................  2
    ##  (7) Whole Non-Uniform Mutation........  1
    ##  (8) Heuristic Crossover...............  2
    ##  (9) Local-Minimum Crossover...........  0
    ## 
    ## HARD Maximum Number of Generations: 5
    ## Maximum Nonchanging Generations: 2
    ## Population size       : 10
    ## Convergence Tolerance: 1.000000e-03
    ## 
    ## Using the BFGS Derivative Based Optimizer on the Best Individual Each Generation.
    ## Not Checking Gradients before Stopping.
    ## Not Using Out of Bounds Individuals and Not Allowing Trespassing.
    ## 
    ## Maximization Problem.
    ## 
    ## 
    ## Generation#      Solution Value
    ## 
    ##       0  1.488371e+01
    ##       1  3.272328e+01
    ##       2  3.301908e+01
    ##       4  3.302012e+01
    ## 
    ## NOTE: HARD MAXIMUM GENERATION LIMIT HIT
    ## 
    ## Solution Fitness Value: 3.302014e+01
    ## 
    ## Parameters at the Solution (parameter, gradient):
    ## 
    ##  X[ 1] : 1.542874e+01    G[ 1] : 8.624249e-05
    ##  X[ 2] : 2.006670e+01    G[ 2] : 1.879290e-05
    ##  X[ 3] : 1.000000e+00    G[ 3] : 4.314239e+04
    ## 
    ## Solution Found Generation 4
    ## Number of Generations Run 5
    ## 
    ## Wed Apr 19 21:45:33 2017
    ## Total run time : 0 hours 0 minutes and 0 seconds
    ## 
    ## optimisation start
    ## ------------------
    ## * estimation method   : MLE 
    ## * optimisation method : gen 
    ## * analytical gradient : used
    ## * trend model : ~1
    ## * covariance model : 
    ##   - type :  matern3_2 
    ##   - nugget : unknown homogenous nugget effect 
    ##   - parameters lower bounds :  1e-10 1e-10 
    ##   - parameters upper bounds :  59.52816 55.23313 
    ##   - upper bound for alpha   :  1 
    ##   - best initial criterion value(s) :  17.60748 
    ## 
    ## 
    ## Wed Apr 19 21:45:34 2017
    ## Domains:
    ##  1.000000e-10   <=  X1   <=    5.952816e+01 
    ##  1.000000e-10   <=  X2   <=    5.523313e+01 
    ##  0.000000e+00   <=  X3   <=    1.000000e+00 
    ## 
    ## NOTE: The total number of operators greater than population size
    ## NOTE: I'm increasing the population size to 10 (operators+1).
    ## 
    ## Data Type: Floating Point
    ## Operators (code number, name, population) 
    ##  (1) Cloning...........................  0
    ##  (2) Uniform Mutation..................  1
    ##  (3) Boundary Mutation.................  1
    ##  (4) Non-Uniform Mutation..............  1
    ##  (5) Polytope Crossover................  1
    ##  (6) Simple Crossover..................  2
    ##  (7) Whole Non-Uniform Mutation........  1
    ##  (8) Heuristic Crossover...............  2
    ##  (9) Local-Minimum Crossover...........  0
    ## 
    ## HARD Maximum Number of Generations: 5
    ## Maximum Nonchanging Generations: 2
    ## Population size       : 10
    ## Convergence Tolerance: 1.000000e-03
    ## 
    ## Using the BFGS Derivative Based Optimizer on the Best Individual Each Generation.
    ## Not Checking Gradients before Stopping.
    ## Not Using Out of Bounds Individuals and Not Allowing Trespassing.
    ## 
    ## Maximization Problem.
    ## 
    ## 
    ## Generation#      Solution Value
    ## 
    ##       0  1.760748e+01
    ##       1  2.104533e+01
    ##       2  2.106809e+01
    ##       3  2.107148e+01
    ## 
    ## Solution Fitness Value: 2.107223e+01
    ## 
    ## Parameters at the Solution (parameter, gradient):
    ## 
    ##  X[ 1] : 8.866611e+00    G[ 1] : 1.637939e-04
    ##  X[ 2] : 1.011591e+01    G[ 2] : -1.380132e-05
    ##  X[ 3] : 1.000000e+00    G[ 3] : 6.645926e+04
    ## 
    ## Solution Found Generation 3
    ## Number of Generations Run 5
    ## 
    ## Wed Apr 19 21:45:34 2017
    ## Total run time : 0 hours 0 minutes and 0 seconds
    ## 
    ## optimisation start
    ## ------------------
    ## * estimation method   : MLE 
    ## * optimisation method : gen 
    ## * analytical gradient : used
    ## * trend model : ~1
    ## * covariance model : 
    ##   - type :  matern3_2 
    ##   - nugget : unknown homogenous nugget effect 
    ##   - parameters lower bounds :  1e-10 1e-10 
    ##   - parameters upper bounds :  59.52816 55.23313 
    ##   - upper bound for alpha   :  1 
    ##   - best initial criterion value(s) :  7.188694 
    ## 
    ## 
    ## Wed Apr 19 21:45:34 2017
    ## Domains:
    ##  1.000000e-10   <=  X1   <=    5.952816e+01 
    ##  1.000000e-10   <=  X2   <=    5.523313e+01 
    ##  0.000000e+00   <=  X3   <=    1.000000e+00 
    ## 
    ## NOTE: The total number of operators greater than population size
    ## NOTE: I'm increasing the population size to 10 (operators+1).
    ## 
    ## Data Type: Floating Point
    ## Operators (code number, name, population) 
    ##  (1) Cloning...........................  0
    ##  (2) Uniform Mutation..................  1
    ##  (3) Boundary Mutation.................  1
    ##  (4) Non-Uniform Mutation..............  1
    ##  (5) Polytope Crossover................  1
    ##  (6) Simple Crossover..................  2
    ##  (7) Whole Non-Uniform Mutation........  1
    ##  (8) Heuristic Crossover...............  2
    ##  (9) Local-Minimum Crossover...........  0
    ## 
    ## HARD Maximum Number of Generations: 5
    ## Maximum Nonchanging Generations: 2
    ## Population size       : 10
    ## Convergence Tolerance: 1.000000e-03
    ## 
    ## Using the BFGS Derivative Based Optimizer on the Best Individual Each Generation.
    ## Not Checking Gradients before Stopping.
    ## Not Using Out of Bounds Individuals and Not Allowing Trespassing.
    ## 
    ## Maximization Problem.
    ## 
    ## 
    ## Generation#      Solution Value
    ## 
    ##       0  7.188694e+00
    ##       1  2.252923e+01
    ##       2  2.260879e+01
    ##       3  2.262281e+01
    ##       4  2.262463e+01
    ## 
    ## NOTE: HARD MAXIMUM GENERATION LIMIT HIT
    ## 
    ## Solution Fitness Value: 2.262489e+01
    ## 
    ## Parameters at the Solution (parameter, gradient):
    ## 
    ##  X[ 1] : 9.268529e+00    G[ 1] : -3.058067e-04
    ##  X[ 2] : 9.890160e+00    G[ 2] : 3.089273e-04
    ##  X[ 3] : 1.000000e+00    G[ 3] : 6.842363e+04
    ## 
    ## Solution Found Generation 4
    ## Number of Generations Run 5
    ## 
    ## Wed Apr 19 21:45:34 2017
    ## Total run time : 0 hours 0 minutes and 0 seconds
    ## 
    ## optimisation start
    ## ------------------
    ## * estimation method   : MLE 
    ## * optimisation method : gen 
    ## * analytical gradient : used
    ## * trend model : ~1
    ## * covariance model : 
    ##   - type :  matern3_2 
    ##   - nugget : unknown homogenous nugget effect 
    ##   - parameters lower bounds :  1e-10 1e-10 
    ##   - parameters upper bounds :  59.52816 55.23313 
    ##   - upper bound for alpha   :  1 
    ##   - best initial criterion value(s) :  14.8022 
    ## 
    ## 
    ## Wed Apr 19 21:45:34 2017
    ## Domains:
    ##  1.000000e-10   <=  X1   <=    5.952816e+01 
    ##  1.000000e-10   <=  X2   <=    5.523313e+01 
    ##  0.000000e+00   <=  X3   <=    1.000000e+00 
    ## 
    ## NOTE: The total number of operators greater than population size
    ## NOTE: I'm increasing the population size to 10 (operators+1).
    ## 
    ## Data Type: Floating Point
    ## Operators (code number, name, population) 
    ##  (1) Cloning...........................  0
    ##  (2) Uniform Mutation..................  1
    ##  (3) Boundary Mutation.................  1
    ##  (4) Non-Uniform Mutation..............  1
    ##  (5) Polytope Crossover................  1
    ##  (6) Simple Crossover..................  2
    ##  (7) Whole Non-Uniform Mutation........  1
    ##  (8) Heuristic Crossover...............  2
    ##  (9) Local-Minimum Crossover...........  0
    ## 
    ## HARD Maximum Number of Generations: 5
    ## Maximum Nonchanging Generations: 2
    ## Population size       : 10
    ## Convergence Tolerance: 1.000000e-03
    ## 
    ## Using the BFGS Derivative Based Optimizer on the Best Individual Each Generation.
    ## Not Checking Gradients before Stopping.
    ## Not Using Out of Bounds Individuals and Not Allowing Trespassing.
    ## 
    ## Maximization Problem.
    ## 
    ## 
    ## Generation#      Solution Value
    ## 
    ##       0  1.480220e+01
    ##       1  2.426969e+01
    ## 
    ## 'wait.generations' limit reached.
    ## No significant improvement in 2 generations.
    ## 
    ## Solution Fitness Value: 2.427007e+01
    ## 
    ## Parameters at the Solution (parameter, gradient):
    ## 
    ##  X[ 1] : 1.095421e+01    G[ 1] : 7.568425e-05
    ##  X[ 2] : 9.222918e+00    G[ 2] : -6.144615e-06
    ##  X[ 3] : 1.000000e+00    G[ 3] : 8.161510e+04
    ## 
    ## Solution Found Generation 1
    ## Number of Generations Run 4
    ## 
    ## Wed Apr 19 21:45:34 2017
    ## Total run time : 0 hours 0 minutes and 0 seconds
    ## 
    ## optimisation start
    ## ------------------
    ## * estimation method   : MLE 
    ## * optimisation method : gen 
    ## * analytical gradient : used
    ## * trend model : ~1
    ## * covariance model : 
    ##   - type :  matern3_2 
    ##   - nugget : unknown homogenous nugget effect 
    ##   - parameters lower bounds :  1e-10 1e-10 
    ##   - parameters upper bounds :  59.52816 55.23313 
    ##   - upper bound for alpha   :  1 
    ##   - best initial criterion value(s) :  7.755372 
    ## 
    ## 
    ## Wed Apr 19 21:45:34 2017
    ## Domains:
    ##  1.000000e-10   <=  X1   <=    5.952816e+01 
    ##  1.000000e-10   <=  X2   <=    5.523313e+01 
    ##  0.000000e+00   <=  X3   <=    1.000000e+00 
    ## 
    ## NOTE: The total number of operators greater than population size
    ## NOTE: I'm increasing the population size to 10 (operators+1).
    ## 
    ## Data Type: Floating Point
    ## Operators (code number, name, population) 
    ##  (1) Cloning...........................  0
    ##  (2) Uniform Mutation..................  1
    ##  (3) Boundary Mutation.................  1
    ##  (4) Non-Uniform Mutation..............  1
    ##  (5) Polytope Crossover................  1
    ##  (6) Simple Crossover..................  2
    ##  (7) Whole Non-Uniform Mutation........  1
    ##  (8) Heuristic Crossover...............  2
    ##  (9) Local-Minimum Crossover...........  0
    ## 
    ## HARD Maximum Number of Generations: 5
    ## Maximum Nonchanging Generations: 2
    ## Population size       : 10
    ## Convergence Tolerance: 1.000000e-03
    ## 
    ## Using the BFGS Derivative Based Optimizer on the Best Individual Each Generation.
    ## Not Checking Gradients before Stopping.
    ## Not Using Out of Bounds Individuals and Not Allowing Trespassing.
    ## 
    ## Maximization Problem.
    ## 
    ## 
    ## Generation#      Solution Value
    ## 
    ##       0  7.755372e+00
    ##       1  1.922646e+01
    ##       2  2.034866e+01
    ##       3  2.258777e+01
    ##       4  2.442287e+01
    ##       5  2.469651e+01
    ## 
    ## NOTE: HARD MAXIMUM GENERATION LIMIT HIT
    ## 
    ## Solution Fitness Value: 2.469651e+01
    ## 
    ## Parameters at the Solution (parameter, gradient):
    ## 
    ##  X[ 1] : 1.301248e+01    G[ 1] : -1.032006e-01
    ##  X[ 2] : 1.043446e+01    G[ 2] : -8.632624e-02
    ##  X[ 3] : 1.000000e+00    G[ 3] : 1.285440e+05
    ## 
    ## Solution Found Generation 5
    ## Number of Generations Run 5
    ## 
    ## Wed Apr 19 21:45:35 2017
    ## Total run time : 0 hours 0 minutes and 1 seconds

``` r
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
