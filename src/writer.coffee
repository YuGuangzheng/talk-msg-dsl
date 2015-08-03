
{recur} = require 'tail-call/core'

flat = (dsl) ->
  "<$#{dsl.category}|#{dsl.model}|#{dsl.view}$>"

stringify = recur (result, content) ->
  if content.length is 0
    result
  else
    first = content[0]
    rest = content[1..]
    if (typeof first) is 'string'
      stringify (result + first), rest
    else
      stringify (result + (flat first)), rest

exports.write = (list) ->
  stringify '', list
