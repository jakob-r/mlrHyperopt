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

  # remove Conditionals start line
  lines = lines[!str_detect(lines, "Conditionals:")]

  lines.params = lines
  
  #FIXME: remove debug prints 

  for (i in seq_along(lines.params)) {
    line = lines.params[i]
    # print(line)
    z = consume(line, "[a-zA-Z0-9_\\-]+\\s*")
    id = str_trim(z$match)
    if (str_detect(z$rest, "^\\[.*\\]")) {
      # num or int param
      z = consume(z$rest, "^\\[.*?\\]")
      bounds = removeChars(z$match, c("\\[", "\\]"))
      bounds = splitAndTrim(bounds, ",", convert = as.numeric)
      if (str_detect(z$rest, "i")) {
        makeP = makeIntegerParam
        defConv = as.integer
      } else {
        makeP = makeNumericParam
        defConv = as.numeric
      }
      def = parseDefault(z$rest, convert = defConv)
      # print(str(def))
      par = makeP(id = id, lower = bounds[1L], upper = bounds[2L], default = def)
    } else if (str_detect(z$rest, "^\\{.*\\}")) {
      # discrete
      z = consume(z$rest, "^\\{.*\\}")
      values = removeChars(z$match, c("\\{", "\\}"))
      values = splitAndTrim(values, ",")
      # print(z$rest)
      def = parseDefault(z$rest)
      # print(def)
      par = makeDiscreteParam(id = id, values = values, default = def)
    } else {
      stop("Should not happen!")
    }
    result[[id]] = par
  }

  makeParamSet(params = result)
}

parseDefault = function(s, convert = as.character) {
  s = consume(s, "\\[.*\\]")
  s = str_trim(removeChars(s$match, c("\\[", "\\]")))
  convert(s)
}


