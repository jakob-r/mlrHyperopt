#' @title Uploads a Parameter Set to the mlrHyperopt servers
#'
#' @description Uploads a ParamSet and returns the ID.
#'
#' @param id [\code{character}]
#'  A unique identifier of the Parameter Set
#' @return [\code{character}]
#' @export

uploadParSet = function(par.set, learner = NULL, user.email = NULL) {
  assert_class(par.set, "ParamSet")
  assert_string(user.email, null.ok = TRUE)

  # if a learner is given, check that it fits to the par.set otherwise use info in par.set$ref.learner.id to upload the par.set
  if (!is.null(learner)) {
    assert_class(learner, "Learner")
    learner.fits.par.set = checkLearnerParamSet(learner = learner, par.set = par.set)
    if (!learner.fits.par.set) {
      stop(attr(learner.fits.par.set, "error"))
    }
    learner.id = getLearnerId(learner)
  } else if (is.null(par.set$ref.learner.id)) {
    stopf("The ParamSet is not referenced to a Learner and no Learner is passed!")
  } else {
    learner.id = par.set$ref.learner.id
  }

  # establish connection to DB
  if (file.exists("pardb.Rds")) {
    pardb = readRDS("pardb.Rds")
  } else {
    pardb = new.env()
  }
  new.id = getNewId(pardb)

  # upload to DB
  pardb[[new.id]] = list(par.set.backup = par.set, learner.id = learner.id, user.email = user.email, par.set.json = paramSetToJSON(par.set))
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