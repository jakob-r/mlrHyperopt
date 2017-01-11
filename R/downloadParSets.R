#' @title Downloads a Parameter Set from the mlrHyperopt servers
#'
#' @param ids [\code{character}]
#'  One ore more unique identifiers of the Parameter Set
#' @return [List of \code{ParamSets}]
#' @export

downloadParSets = function(ids) {
  assert_character(ids)

  # establish connection to DB
  if (file.exists("pardb.Rds")) {
    pardb = readRDS("pardb.Rds")
  } else {
    stop("Connection to database could not be established!")
  }

  # query for results
  assert_subset(x = ids, choices = names(pardb))
  db.res = mget(ids, envir=pardb)

  # loop through ids
  par.sets = lapply(db.res, function(x) {
    par.set = JSONtoParamSet(x$par.set.json)
    par.set$ref.learner.id = x$learner.id
    par.set
  })

  par.sets
}