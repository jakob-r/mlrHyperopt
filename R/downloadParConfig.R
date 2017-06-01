#' @title Downloads multiple Parameter Configurations from the mlrHyperopt servers
#'
#' @description Retrieve the Paramater Configurations for the given ids from the mlrHyperopt servers.
#' @param ids [\code{character}] \cr
#'  One ore more unique identifiers of the Parameter Set
#' @param learner.class [\code{character(1)}] \cr
#'  The \code{learner.class} you want to download the Parameter Configrations for.
#' @param learner.name [\code{character(1)}] \cr
#'  The \code{learner.name} you want to download the Parameter Configrations for.
#' @param custom.query [\code{list(2)}] \cr
#'  List of the form \code{list(key = "key", value = "value")} for custom queries.
#' @return [List of \code{ParConfig}s]
#' @examples
#' par.configs = downloadParConfigs(learner.name = "svm")
#' print(par.configs)
#' @export

downloadParConfigs = function(ids = NULL, learner.class = NULL, learner.name = NULL, custom.query = NULL) {
  if (!is.null(ids)) {
    assert_character(ids)
    return(lapply(ids, downloadParConfig))
  } else if (!is.null(learner.class)) {
    assertString(learner.class)
    query = list("learner_class" = learner.class)
  } else if (!is.null(learner.name)) {
    assertString(learner.name)
    query = list("learner_name" = learner.name)
  }
  if (!is.null(custom.query)) {
    assertList(custom.query, any.missing = FALSE, len = 1, names = "named")
    query = insert(query, custom.query)
  }
  query = lapply(query, function(x) if (is.logical(x)) as.numeric(x) else x)
  httr.res = httr::GET(sprintf("%s.json", getURL()), query = query, httr::accept_json())
  if (httr::status_code(httr.res) != 200) {
    stopf("The server returned an unexpected result: %s", httr::content(httr.res, "text"))
  }
  res = httr::content(httr.res)
  lapply(res, downloadToParConfig)
}

#' @title Downloads a single ParConfig.
#'
#' @description Retrieve a Paramater Configuration for the given id from the mlrHyperopt servers.
#' @param id [\code{character}]
#'  Unique identifier for a Parameter Set.
#'  This will be downloaded from the mlrHyperopt servers.
#' @return [\code{ParConfig}]
#' @examples
#' par.config = downloadParConfig("1")
#' print(par.config)
#' @export
downloadParConfig = function(id) {
  as.character(id)
  assert_string(id)
  httr.res = httr::GET(sprintf("%s/%s.json", getURL(), id), httr::accept_json())
  if (httr::status_code(httr.res) != 200) {
    stopf("The server returned an unexpected result: %s", httr::content(httr.res, "text"))
  }
  res = httr::content(httr.res)
  res = downloadToParConfig(res)
}

downloadToParConfig = function(res) {
  par.set = JSONtoParSet(res$json_parset)
  par.vals = JSONtoParVals(res$json_parvals)
  res = res[nzchar(res)]
  res$note = coalesce(res$note, "")
  setAttribute(
    makeParConfig(par.set = par.set, par.vals = par.vals, learner = res$learner_class, learner.name = res$learner_name, note = res$note),
    "on.server", res)
}

