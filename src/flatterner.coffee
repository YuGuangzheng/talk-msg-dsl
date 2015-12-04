
assign = require 'lodash.assign'
util = require './util'

# dslTable = [{model: String, view: String}]

exports.update = (dslList, dslTable = []) ->
  dslMap = {}
  dslTable.forEach (item) ->
    dslMap[item.model] = item.view

  dslList.map (piece) ->
    if util.isString(piece)
      piece
    else
      if dslMap[piece.model]?
        assign {}, piece, view: dslMap[piece.model]
      else
        piece

exports.render = (dslList, dslTable = [], customMakeTag = util.identity) ->
  newDslList = exports.update dslList, dslTable
  newDslList
  .map (item) ->
    newItem = customMakeTag(item)
    if util.isString(newItem)
      newItem
    else
      newItem.view
  .join('')
