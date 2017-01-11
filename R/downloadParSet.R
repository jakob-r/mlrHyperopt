#' @title Downloads a Parameter Set from the mlrHyperopt servers
#'
#' @param ids [\code{character}]
#'  One ore more unique identifiers of the Parameter Set
#' @return [\code{ParamSet}|list of ParamSets]
#' @export

downloadParSet = function(ids) {
  assert_character(ids)

  # establish connection to DB
  if (file.exists("pardb.Rds")) {
    pardb = readRDS("pardb.Rds")
  } else {
    stop("Connection to database could not be established!")
  }

  # query for results
  db.res = pardb[[ids]]

  # loop through ids
  par.sets = lapply(db.res, function(x) {
    par.set = JSONtoParamSet(x$par.set.json)
    par.set$ref.learner.id = x$learner.id
  })

  # return a list only if multiple par.sets are requested
  if (length(ids) == 1) {
    return(par.sets[[1]])
  } else {
    return(par.sets)
  }
}