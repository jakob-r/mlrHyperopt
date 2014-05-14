#FIXME: conditionals and defaults and forbiddens
parseParamFile = function(scen) {
  checkArg(scen, "AClibScenario")
  path = file.path(scen$aclib.dir, scen$paramfile)

  lines = readTxtTrimAndRemove(path)
  lines = removeComments(lines)
  result = list()

  # lines with | are conditions on params
  j = str_detect(lines, "\\|")
  lines.cond = lines[j]
  lines = lines[!j]

  # lines enclosed in {} are forbidden
  j = str_detect(lines, "^\\{.*\\}$")
  lines.forbidden = lines[j]
  lines = lines[!j]

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
      makeP = if (str_detect(z$rest, "i"))
        makeIntegerParam
      else
        makeNumericParam
      def = parseDefault(z$rest)
      par = makeP(id = id, lower = bounds[1L], upper = bounds[2L], default = def)
    } else if (str_detect(z$rest, "^\\{.*\\}")) {
      # discrete
      constraints = str_extract(z$rest, "^\\{.*\\}")
      values = removeChars(constraints, c("\\{", "\\}"))
      values = splitAndTrim(values, ",")
      def = parseDefault(z$rest)
      par = makeDiscreteParam(id = id, values = values, default = def)
    } else {
      stop("Should not happen!")
    }
    result[[id]] = par
  }

  makeParamSet(params = pars)
}

parseDefault = function(s, convert = as.character) {
  s = removeChars(s, c("\\[", "\\]"))
  convert(s)
}


