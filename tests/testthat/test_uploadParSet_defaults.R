context("uploadParConfig")

test_that("All the defaults are in sync with the package defaults", {
  def.par.sets = getDefaultParSetValues()
  names.split = stringi::stri_split_fixed(names(def.par.sets), pattern = ".")
  learner.type = extractSubList(names.split, 1)
  learner.name = extractSubList(names.split, 2)
  for (i in seq_along(def.par.sets)) {
    psv = def.par.sets[[i]]
    if (nchar(learner.type[i])>0) {
      pc = makeParConfig(par.set = psv$par.set, par.vals = psv$par.vals, learner = names(def.par.sets)[i])
    } else {
      pc = makeParConfig(par.set = psv$par.set, par.vals = psv$par.vals, learner.name = learner.name[i])
    }
    upload.try = try({uploadParConfig(pc, user.email = "code@jakob-r.de", as.default = TRUE)}, silent = TRUE)
    i = i + 1
  }
})