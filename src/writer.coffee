
assign = require 'lodash.assign'
{recur} = require 'tail-call/core'
link = require './link'
util = require './util'

flat = (dsl) ->
  "<$#{dsl.category}|#{dsl.model}|#{dsl.view}$>"

exports.write = (list) ->
  list
  .map (piece) ->
    if util.isString(piece)
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
  if util.isString(dsl)
    dsl
  else
    switch dsl.category
      when 'at' then "<mention>#{dsl.view}</mention>"
      when 'link' then "<a href=\"#{dsl.model}\">#{dsl.view}</a>"
      when 'bold' then "<strong>#{dsl.view}</strong>"
      else dsl.view

exports.writeHtml = (list, customMakeTag = util.identity) ->
  link.mark(list)
  .map (piece) ->
    newPiece =
      if util.isString(piece)
        escapeHtml piece
      else
        assign {}, piece, view: escapeHtml(piece.view)

    makeTag(customMakeTag(newPiece))
  .join('')
