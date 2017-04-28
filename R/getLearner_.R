#' @title
#' Get the class of an mlr Learner
#'
#' @description
#' The class consits of the type such as \dQuote{classif} or \dQuote{regr} and the name.
#' For example \dQuote{classif.svm}.
#'
#' @template arg_learner
#' @return [\code{character(1)}]
#' @export
getLearnerClass = function(learner) {
  class(learner)[[1]]
}

#' @title
#' Get the name of an mlr Learner
#'
#' @description
#' The name describes the general \dQuote{learner} that is used without narrowing it down to  of the type such as \dQuote{classif} or \dQuote{regr} and the name.
#' For example the name \dQuote{classif.svm} is \dQuote{svm}.
#'
#' @template arg_learner
#' @return [\code{character(1)}]
#' @export
getLearnerName = function(learner) {
  learner.class = getLearnerClass(learner)
  learner.type = getLearnerType(learner)
  stri_replace_first_fixed(learner.class, paste0(learner.type,"."), "")
}