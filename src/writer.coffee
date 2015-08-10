
{recur} = require 'tail-call/core'

flat = (dsl) ->
  "<$#{dsl.category}|#{dsl.model}|#{dsl.view}$>"

exports.write = (list) ->
  list
  .map (piece) ->
    if (typeof piece) is 'string'
      piece
    else
      flat piece
  .join('')

entityMap =
  "&": "&amp;"
  "<": "&lt;"
  ">": "&gt;"
  '"': '&quot;'
  "'": '&#39;'
  "/": '&#x2F;'
  "\n": '<br>'

escapeHtml = (string) ->
  String(string).replace /[&<>"'\/\n]/g, (s) -> entityMap[s]

makeTag = (dsl) ->
  switch dsl.category
    when 'mention' then "<mention>#{escapeHtml dsl.view}</metion>"
    when '@' then "<mention>#{escapeHtml dsl.view}</metion>"
    when 'at' then "<mention>#{escapeHtml dsl.view}</metion>"
    when 'link' then "<a href=\"#{dsl.model}\">#{escapeHtml dsl.view}</a>"
    when 'bold' then "<strong>#{escapeHtml dsl.view}</strong>"
    else dsl.view

exports.writeHtml = (list) ->
  list
  .map (piece) ->
    if (typeof piece) is 'string'
      escapeHtml piece
    else
      makeTag piece
  .join('')
