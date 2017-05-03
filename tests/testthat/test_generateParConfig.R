context("generateParConfig")

test_that("generateParConfig works for all avaiable defaults", {
  task = iris.task
  def.par.set.vals = getDefaultParSetValues()
  def.names = names(def.par.set.vals)
  ind.untyped = stri_startswith(str = def.names, fixed = ".")
  def.names[ind.untyped] = paste0("classif",def.names[ind.untyped])
  def.names = stri_subset(def.names, regex = "^classif")
  for (lrn.class in def.names) {
    par.config = generateParConfig(learner = lrn.class, task = task)
    expect_class(par.config, "ParConfig")
    expect_equal(getParConfigLearnerClass(par.config), lrn.class)
  }
})
