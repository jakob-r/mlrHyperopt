#FIXME: conditionals and defaults and forbiddens
parseParamFile = function(scen) {
  checkAClibScenario(scen)
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
  # remove forbidden start line
  lines = lines[!str_detect(lines, "Forbidden:")]
  
  lines.params = lines

  #FIXME: remove debug prints

  ### parse param lines
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

  ### parse conditionals
  for (i in seq_along(lines.cond)) {
    line = lines.cond[i]
    # print(line)
    # split at | and get id1 and tail
    s = str_split(line, "\\|")[[1L]]
    # print(s)
    id1 = str_trim(s[1L])
    # print(id1)
    stopifnot(id1 %in% names(result))
    # split at 'in' and get id2 and values
    s = str_trim(s[2L])
    s = str_split(s, " in ")[[1L]]
    id2 = str_trim(s[1L])
    # print(id2)
    stopifnot(id2 %in% names(result))

    # now take parse values and quote them
    vals = s[2L]
    vals = removeChars(vals, c("\\{", "\\}"))
    vals = str_split(vals, ",")[[1]]
    vals = paste0("'", vals, "'")

    # build string and parse it to quoted expression
    req = sprintf("%s in c(%s)", id2, collapse(vals))
    req = str_replace(req, " in ", " %in% ")
    req = asQuoted(req)

    param.requires[[id]] = req
    result[[id1]]$requires = req
  }
  
  ### parse forbidden 
  # The syntax for forbidden parameter combinations is as follows: <parameter name N> = <value N>
  if(length(lines.forbidden) >= 1){
    forbidden.list = list()
    for (i in seq_along(lines.forbidden)){
      line = lines.forbidden[i]
      s = removeChars(line, c("\\{", "\\}"))
      s = str_split(s, ",")[[1L]]
      s = str_split(s, "\\=")
      
      # formulate the forbidden condition as an if(... & ... & ...) operation
      forbiddenCond = vector("character")
      for(j in 1:length(s)){
        tmpForbid = s[[j]][2L]
        tmpForbid = sprintf("'%s'",tmpForbid)
        tmpVar = sprintf("'%s'", s[[j]][1L])
        forbiddenCond[j] = sprintf("%s in c(%s)", tmpVar, collapse(tmpForbid))
        forbiddenCond[j] = str_replace(forbiddenCond[j], " in ", " %in% ")
      }
      # FIX: is the format - formulation as a bool cond of the type: if(... & ... & ...) ok?
      
      # combine all conditions into one bool condition
      for(k in 2:length(s)) forbiddenCond[k] = paste0(" & ", forbiddenCond[k])
      forbiddenCond = removeChars(collapse(forbiddenCond),"\\,")
      # FIXME: is "list" format for the forbiddens ok, or should it be "vector"?
      forbidden.list[[i]] = forbiddenCond
    }
  }else{
    forbidden.list = NULL
  }

  #FIXME: can it happen that we have more than 1 condition for a param? probably yes! we need to add them up!

  makeParamSet(params = result,forbidden = forbidden.list)
}

parseDefault = function(s, convert = as.character) {
  s = consume(s, "\\[.*\\]")
  s = str_trim(removeChars(s$match, c("\\[", "\\]")))
  convert(s)
}


