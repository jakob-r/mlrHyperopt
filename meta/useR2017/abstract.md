---
title: "mlrHyperopt: Effortless and collaborative hyperparameter optimization experiments"
author: |
   | Jakob Richter^1^ and Jörg Rahnenführer^1^ and Michel Lang^1^
   |
   | 1. TU Dortmund University, Germany
institute: 
   - $^1$TU Dortmund University
output: html_document
bibliography: abstract.bib
nocite: | 
  @bischl_mlr:_2016, @bischl_mlrmbo:_2017
---

**Keywords**: machine learning, hyperparameter optimization, tuning, classification, networked science

**Webpages**: http://github.com/jakob-r/mlrHyperopt

Most machine learning tasks demand hyperparameter tuning to achieve a good performance. 
For example, Support Vector Machines with radial basis functions are very sensitive to the choice of both kernel width and soft margin penalty C. 
However, for a wide range of machine learning algorithms these “search spaces” are less known. 
Even worse, experts for the particular methods might have conflicting views.
The popular package **caret** approaches this problem by providing two simple optimizers _grid search_ and _random search_ and individual search spaces for all implemented methods.
To prevent training on misconfigured methods a _grid search_ is performed by default.
Unfortunately it is only documented which parameters will be tuned but the exact bounds have to be obtained from the source code.
As a counterpart **mlr** [@bischl_mlr:_2016] offers more flexible parameter tuning methods such as an interface to **mlrMBO** [@bischl_mlrmbo:_2017] for conducting Bayesian optimization.
Unfortunately **mlr** lacks of default search spaces and thus parameter tuning becomes difficult.
Here **mlrHyperopt** steps in to make hyperparameter optimization as easy as in **caret**.
As a matter of fact, for a developer of a machine learning package, it is unquestionable impossible to be an expert of all implemented methods and provide perfect search spaces.
Hence **mlrHyperopt** aims at:

* improving the search spaces of **caret** with simple tricks.
* letting the users submit and download improved search spaces to a database.
* providing advanced tuning methods interfacing **mlr** and **mlrMBO**.

A study on selected data sets and numerous popular machine learning methods compares the performance of the grid and random search implemented in **caret** to the performance of **mlrHyperopt** for different budgets.

# References
