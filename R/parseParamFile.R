parseParamFile = function(scen) {
  checkArg(scen, "AClibScenario")
  path = file.path(scen$aclib.dir, scen$paramfile)
  checkFile(path)
  lines = readLines(path)
  lines = removeComments(lines)
  lines = trimAndRemoveEmptyLines(lines)
  # result params
  pars = list()

  # lines with | are conditions on params
  j = str_detect(lines, "\\|")
  lines.cond = lines[j]
  lines = lines[!j]

  # FIXME: make this work
  # lines enclosed in {} are forbidden

  lines.params = lines

  for (i in seq_along(lines.params)) {
    line = lines.params[i]
    print(line)
    z = consume(line, "[a-zA-Z0-9_\\-]+\\s*")
    id = str_trim(z$match)
    if (str_detect(z$rest, "^\\[.*\\]")) {
      # num or int param
      z = consume(z$rest, "^\\[.*?\\]")
      bounds = removeChars(z$match, c("\\[", "\\]"))
      bounds = splitAndTrim(bounds, ",", convert = as.numeric)
      if (str_detect(z$rest, "i"))
        par = makeIntegerParam(id = id, lower = bounds[1L], upper = bounds[2L])
      else
        par = makeNumericParam(id = id, lower = bounds[1L], upper = bounds[2L])
    } else if (str_detect(z$rest, "^\\{.*\\}")) {
      # discrete
      constraints = str_extract(z$rest, "^\\{.*\\}")
      values = removeChars(constraints, c("\\{", "\\}"))
      values = splitAndTrim(values, ",")
      par = makeDiscreteParam(id = id, values = values)
    } else {
      stop("Should not happen!")
    }
    pars[[id]] = par
  }

  makeParamSet(params = pars)
}


