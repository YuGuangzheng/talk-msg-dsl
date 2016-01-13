
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

htmlReplacementsRegex = /[&<>"'\/]/g
htmlReplacements =
  "&": "&amp;"
  "<": "&lt;"
  ">": "&gt;"
  '"': '&quot;'
  "'": '&#39;'
  "/": '&#x2F;'

viewReplacementsRegex = /[&<>"'\/\n]/g
viewReplacements = assign htmlReplacements,
  '\n': '<br>'

escape = (string, regex, replacements) ->
  String(string).replace regex, (s) ->
    replacements[s]

escapeHtml = (string) -> escape(string, htmlReplacementsRegex, htmlReplacements)
escapeView = (string) -> escape(string, viewReplacementsRegex, viewReplacements)

makeTag = (dsl) ->
  if util.isString(dsl)
    dsl
  else
    switch dsl.category
      when 'at'
        "<mention>#{dsl.view}</mention>"
      when 'link'
        "<a href=\"#{escapeHtml(dsl.model)}\">#{dsl.view}</a>"
      when 'bold'
        "<strong>#{dsl.view}</strong>"
      else
        dsl.view

exports.writeHtml = (list, customMakeTag = util.identity) ->
  link.mark(list)
  .map (piece) ->
    newPiece =
      if util.isString(piece)
        escapeView piece
      else
        assign {}, piece, view: escapeView(piece.view)

    makeTag(customMakeTag(newPiece))
  .join('')
