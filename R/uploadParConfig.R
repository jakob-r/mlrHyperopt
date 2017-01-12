#' @title Uploads a Parameter Set to the mlrHyperopt servers
#'
#' @description Uploads a ParConfig and returns the ID.
#'
#' @template arg_parconfig
#' @param learner [\code{Learner}]
#'  The Learner that belongs to that Parameter Set.
#'  Can be left out if the \code{par.config} contains a reference to a learner.
#' @param user.email [\code{character(1)}]
#'  Your email to identify yourself to the server.
#'  Does not have to be a valid one, but this identifier makes it easier to find your own submissions or submissions by colleagues.
#'  In the future we might switch to an authentification system.
#'  It could be advantageous to supply a working email if you want to migrate your submissions then.
#' @return [\code{character}]
#' @export

uploadParConfig= function(par.config, learner = NULL, user.email = NULL) {
  assert_class(par.config, "ParConfig")
  assert_string(user.email, null.ok = TRUE)

  # if a learner is given, check that it fits to the par.config otherwise use info in par.config$associated.learner.class to upload the par.config
  if (!is.null(learner)) {
    assert_class(learner, "Learner")
    learner.fits.par.config = checkLearnerParConfig(learner = learner, par.config = par.config)
    if (!learner.fits.par.config) {
      stop(attr(learner.fits.par.config, "error"))
    }
    learner.class = getLearnerClass(learner)
  } else if (is.null(par.config$associated.learner.class)) {
    stopf("The ParConfig is not referenced to a Learner and no Learner is passed!")
  } else {
    learner.class = par.config$associated.learner.class
  }

  # establish connection to DB
  if (file.exists("pardb.Rds")) {
    pardb = readRDS("pardb.Rds")
  } else {
    pardb = new.env()
  }
  new.id = getNewId(pardb)

  # upload to DB
  pardb[[new.id]] = list(par.config.backup = par.config, learner.class = learner.class, user.email = user.email, par.set.json = paramSetToJSON(par.config))
  saveRDS(pardb, file = "pardb.Rds")

  return(new.id)
}

getNewId = function(pardb) {
  if (length(pardb) == 0) {
    return(as.character(1))
  } else {
    return(as.character(max(as.numeric(names(pardb)))+1))
  }
}