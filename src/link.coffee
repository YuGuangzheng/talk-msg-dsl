
{recur} = require 'tail-call/core'
type = require 'type-of'

concat = (a, b) ->
  a.concat b

flatMapHelper = (list, method, result) ->
  if list.length is 0
    result
  else
    first = list[0]
    mapped = method first
    flatMapHelper list[1..], method, (concat result, mapped)

flatMap = (list, method) ->
  flatMapHelper list, method, []

grabLinkFrom = recur (result, text) ->
  if text.length > 0
    firstChar = text[0]
    restText = text[1..]
    if firstChar in [' ', '\n', '\t']
      [result, text]
    else
      grabLinkFrom "#{result}#{firstChar}", restText
  else
    [result, text]

reduceText = (result, buffer, text) ->
  if text.length is 0
    if buffer.length is 0
      result
    else
      result.push buffer
      result
  else
    firstChar = text[0]
    restText = text[1..]
    if firstChar is 'h'
      matchHttp = text[0...7] is 'http://' and text.length > 7
      matchHttps = text[0...8] is 'https://' and text.length > 8
      if matchHttp or matchHttps
        [link, rest] = grabLinkFrom '', text
        if buffer.length > 0
          result.push buffer
          buffer = ''
        result.push
          category: 'link'
          model: link
          view: link
        reduceText result, buffer, rest
      else
        buffer = "#{buffer}#{firstChar}"
        reduceText result, buffer, restText
    else
      buffer = "#{buffer}#{firstChar}"
      reduceText result, buffer, restText

exports.mark = (list) ->
  flatMap list, (item) ->
    if (type item) is 'string'
      reduceText [], '', item
    else
      [item]
