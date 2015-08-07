
_ = require 'lodash'

# dslTable = [{model: String, view: String}]

exports.render = (dslList, dslTable) ->
  dslMap = {}
  _.forEach dslTable, (item) ->
    dslMap[item.model] = item.view
  # console.log dslMap
  newDslList = dslList.map (piece) ->
    if (typeof piece) is 'string'
      piece
    else
      if dslMap[piece.model]?
        newPiece = {}
        _.assign {}, piece, view: dslMap[piece.model]
      else
        piece

  result = newDslList.map (item) ->
    if (typeof item) is 'string'
      item
    else
      item.view
  .join('')
