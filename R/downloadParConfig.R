#' @title Downloads multiple Parameter Configurations from the mlrHyperopt servers
#'
#' @description Retrieve the Paramater Configurations for the given ids from the mlrHyperopt servers.
#' @param ids [\code{character}]
#'  One ore more unique identifiers of the Parameter Set
#' @return [List of \code{ParConfig}s]
#' @export

downloadParConfigs = function(ids) {

  assert_character(ids)

  req = httr::POST("http://mlrhyperopt.jakob-r.de/download.php", body = list(ids = as.numeric(ids)), encode = "json", httr::accept_json())
  if (status_code(req) != 200) {
    stopf("The server returned an unexpected result: %s", content(req, "text"))
  }

  db.res = httr::content(req)

  # loop through ids
  par.configs = lapply(db.res, function(x) {
    par.set = JSONtoParSet(x$json_parconfig)
    par.vals = JSONtoParVals(x$json_parvals)
    makeParConfig(par.set = par.set, par.vals = par.vals, learner = x$learner_class)
  })

  par.configs
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