#' @title Uploads a Parameter Set to the mlrHyperopt servers
#'
#' @description Uploads a ParConfig and returns the ID.
#'
#' @template arg_parconfig
#' @param user.email [\code{character(1)}]
#'  Your email to identify yourself to the server.
#'  Does not have to be a valid one, but this identifier makes it easier to find your own submissions or submissions by colleagues.
#'  In the future we might switch to an authentication system.
#'  It could be advantageous to supply a working email if you want to migrate your submissions then.
#' @return [\code{character}]
#' @examples
#' par.set = makeParamSet(
#'   makeIntegerParam(
#'     id = "mtry",
#'     lower = expression(floor(p^0.25)),
#'     upper = expression(ceiling(p^0.75)),
#'     default = expression(round(p^0.5))),
#'   keys = "p")
#' par.config = makeParConfig(
#'   par.set = par.set,
#'   par.vals = list(ntree = 200),
#'   learner.name = "randomForest"
#'   )
#' id = uploadParConfig(par.config, "jon.doe@example.com")
#' print(id)
#' @import httr
#' @export



uploadParConfig = function(par.config, user.email = NULL) {
  assert_class(par.config, "ParConfig")
  assert_string(user.email, null.ok = TRUE)
  if (is.null(user.email)) {
    user.email = "<anonymous>"
  }

  learner.class = getParConfigLearnerClass(par.config)
  post = list(
    user_email = user.email,
    json_parconfig = parSetToJSON(getParConfigParSet(par.config)),
    json_parvals = parValsToJSON(getParConfigParVals(par.config)),
    learner_class = learner.class
    )

  req = httr::POST("http://mlrhyperopt.jakob-r.de/upload.php", body = post, encode = "json", httr::accept_json())
  if (httr::status_code(req) != 200) {
    stopf("The server returned an unexpected result: %s", content(req, "text"))
  }
  as.character(httr::content(req)$id)
}