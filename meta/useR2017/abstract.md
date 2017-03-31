---
title: "mlrHyperopt: Effortless and collaborative hyperparameter optimization experiments"
author: |
   | Jakob Richter^1^ and Jörg Rahnenführer^1^
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

Most machine learning tasks demand hyperparameter tuning to achieve a good performance. For example, Support Vector Machines with radial basis functions are very sensitive to the choice of both kernel width and soft margin penalty C. However, for a wide range of machine learning algorithms these “Search Spaces” are lesser known. Even worse, experts for the particular methods might have conflicting views.
The popular package caret approaches this problem by providing two simple optimizers: grid search and random search. Unfortunately, this is somewhat hidden and thus causes confusion especially for beginners. Furthermore the search spaces are not easily accessible and on instances suboptimal as my talk will show.
A study on selected data sets and numerous popular machine learning methods compares the performance of the grid and random search as well as the performance of mlrHyperopt for different budgets.
For a developer of a machine learning package, it is unquestionable impossible to be an expert of all implemented methods.
That’s why mlrHyperopt aims at
improving the search spaces of caret with simple tricks.
letting the users submit and download improved search spaces to a database.
providing advanced tuning methods using mlr and mlrMBO.

# References
