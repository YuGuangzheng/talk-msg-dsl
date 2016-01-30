
assign = require 'object-assign'
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

makeTag = (dsl) ->
  if util.isString(dsl)
    dsl
  else
    switch dsl.category
      when 'at'
        "<mention>#{dsl.view}</mention>"
      when 'link'
        "<a href=\"#{util.escapeHtml(dsl.model)}\">#{dsl.view}</a>"
      when 'bold'
        "<strong>#{dsl.view}</strong>"
      else
        dsl.view

exports.writeHtml = (list, customMakeTag = util.identity) ->
  link.mark(list)
  .map (piece) ->
    newPiece =
      if util.isString(piece)
        util.escapeView piece
      else
        assign {}, piece, view: util.escapeView(piece.view)

    makeTag(customMakeTag(newPiece))
  .join('')
