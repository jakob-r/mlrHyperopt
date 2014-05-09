parseParamFile = function(scen) {
  checkArg(scen, "AClibScenario")
  path = file.path(scen$aclib.dir, scen$paramfile)
  checkFile(path)
  lines = readLines(path)
  lines = trimAndRemoveEmptyLines(lines)
  index.cond = which(str_detect(lines, "Conditionals:"))
  lines1 = lines[1:(index.cond-1)]
  pars = list()

  for (i in seq_along(lines1)) {
    line = lines[i]
    line = splitAndTrim(line, " ", n = 2L)
    id = line[1L]
    rest = line[-1L]
    if (str_detect(rest, "^\\[.*\\]")) {
      # num or int param
      z = consume(rest, "^\\[.*?\\]")
      bounds = removeChars(z$match, c("\\[", "\\]"))
      bounds = splitAndTrim(bounds, ",", convert = as.numeric)
      if (str_detect(rest, "i"))
        par = makeIntegerParam(id = id, lower = bounds[1L], upper = bounds[2L])
      else
        par = makeNumericParam(id = id, lower = bounds[1L], upper = bounds[2L])
    } else if (str_detect(rest, "^\\{.*\\}")) {
      # discrete
      constraints = str_extract(rest, "^\\{.*\\}")
      values = removeChars(constraints, c("\\{", "\\}"))
      values = splitAndTrim(values, ",")
      par = makeDiscreteParam(id = id, values = values)
    }
    pars[[id]] = par
  }
  pars = makeParamSet(params = pars)
  return(pars)
}


