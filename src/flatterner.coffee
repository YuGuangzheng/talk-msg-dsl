
assign = require 'lodash.assign'

# dslTable = [{model: String, view: String}]

exports.update = (dslList, dslTable) ->
  dslMap = {}
  dslTable.forEach (item) ->
    dslMap[item.model] = item.view
  # console.log dslMap
  dslList.map (piece) ->
    if (typeof piece) is 'string'
      piece
    else
      if dslMap[piece.model]?
        newPiece = {}
        assign {}, piece, view: dslMap[piece.model]
      else
        piece

exports.render = (dslList, dslTable) ->
  newDslList = exports.update dslList, dslTable
  result = newDslList.map (item) ->
    if (typeof item) is 'string'
      item
    else
      item.view
  .join('')
