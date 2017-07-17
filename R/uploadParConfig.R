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
#' @param as.default [\code{logical(1)}]
#'  Do you want to suggest this ParConfig to be the default for the given learner in the online database.
#'  This feature is not completly implemented.
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
#' \dontrun{
#' id = uploadParConfig(par.config, "jon.doe@example.com")
#' print(id)
#' }
#' @import httr
#' @export
uploadParConfig = function(par.config, user.email = NULL, as.default = FALSE) {
  assertClass(par.config, "ParConfig")
  user.email = BBmisc::coalesce(user.email, "<anonymous>")
  assertString(user.email)
  assertFlag(as.default)

  learner.class = BBmisc::coalesce(getParConfigLearnerClass(par.config), "")
  learner.type = BBmisc::coalesce(getParConfigLearnerType(par.config), "")
  learner.name = BBmisc::coalesce(getParConfigLearnerName(par.config), "")

  post = list(
    user_email = user.email,
    json_parset = parSetToJSON(getParConfigParSet(par.config)),
    json_parvals = parValsToJSON(getParConfigParVals(par.config)),
    learner_class = learner.class,
    learner_type = learner.type,
    learner_name = learner.name,
    note = getParConfigNote(par.config),
    default = as.default
    )

  req = httr::POST(getURL(), body = post, encode = "json", httr::accept_json())
  if (httr::status_code(req) %nin% c(200, 201, 202, 203, 204, 205, 206, 207, 208, 228, 422)) {
    stopf("The server returned an unexpected result: %s", httr::content(req, "text"))
  } else if (httr::status_code(req) == 422 && httr::content(req)$json_parset[[1]] == "has already been taken") {
    stopf("This exact par.config was already uploaded.")
  }
  as.character(httr::content(req)$id)
}