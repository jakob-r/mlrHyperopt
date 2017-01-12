#' @title Downloads multiple Parameter Configurations from the mlrHyperopt servers
#'
#' @description Retrieve the Paramater Configurations for the given ids from the mlrHyperopt servers.
#' @param ids [\code{character}]
#'  One ore more unique identifiers of the Parameter Set
#' @return [List of \code{ParConfig}s]
#' @export

downloadParConfigs = function(ids) {

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
  par.configs = lapply(db.res, function(x) {
    par.set = JSONtoParSet(x$par.set.json)
    par.vals = JSONtoParVals(x$par.vals.json)
    makeParConfig(par.set = par.set, par.vals = par.vals, learner = x$learner.class)
  })

}

#' @title Downloads a single ParConfig.
#' 
#' @description Retrieve a Paramater Configuration for the given id from the mlrHyperopt servers.
#' @param id [\code{character}]
#'  Unique identifier for a Parameter Set.
#'  This will be downloaded from the mlrHyperopt servers.
#' @return [\code{ParConfig}]
downloadParConfig = function(id) {
  assert_string(id)
  downloadParConfigs(id)[[1]]
}