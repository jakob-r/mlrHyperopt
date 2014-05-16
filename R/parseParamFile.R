#FIXME: conditionals and defaults and forbiddens
parseParamFile = function(scen) {
  checkArg(scen, "AClibScenario")
  path = file.path(scen$aclib.dir, scen$paramfile)

  lines = readTxtTrimAndRemove(path)
  lines = removeComments(lines)
  result = list()
  param.requires = list()

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

  # parse conditionals first
  for (i in seq_along(lines.cond)) {
    line = lines.cond[i]
    # print(line)
    s = str_split(line, "\\|")[[1L]]
    # print(s)
    id = str_trim(s[1L])
    # print(id)
    req = str_trim(s[2L])
    # transform to R expression and parse
    req = str_replace(req, "in", "%in%")
    req = str_replace(req, "\\{", "c(")
    req = str_replace(req, "\\}", ")")
    req = parse(text = req)
    print(req)
    param.requires[[id]] = req
  }
 
  #FIXME: can it happen that we have more than 1 condition for a param? probably yes! we need to add them up!
   
  # parse param lines
  for (i in seq_along(lines.params)) {
    line = lines.params[i]
    # print(line)
    z = consume(line, "[a-zA-Z0-9_\\-]+\\s*")
    id = str_trim(z$match)

    # get conditional
    req = param.requires[[id]]
    param.requires[[id]] = NULL

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
      par = makeP(id = id, lower = bounds[1L], upper = bounds[2L], default = def, requires = req)
    } else if (str_detect(z$rest, "^\\{.*\\}")) {
      # discrete
      z = consume(z$rest, "^\\{.*\\}")
      values = removeChars(z$match, c("\\{", "\\}"))
      values = splitAndTrim(values, ",")
      # print(z$rest)
      def = parseDefault(z$rest)
      # print(def)
      par = makeDiscreteParam(id = id, values = values, default = def, requires = req)
    } else {
      stop("Should not happen!")
    }
    result[[id]] = par
  }

  # there should no conditionals be left
  if (length(param.requires) > 0L) {
    print(param.requires)
    stop("Should not happen!")
  }

  makeParamSet(params = result)
}

parseDefault = function(s, convert = as.character) {
  s = consume(s, "\\[.*\\]")
  s = str_trim(removeChars(s$match, c("\\[", "\\]")))
  convert(s)
}


