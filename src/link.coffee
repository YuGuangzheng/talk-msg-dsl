#{recur} = require 'tail-call/core'
util = require './util'
linkify = require('linkify-it')()

makeLinkDsl = (schema) ->
  category: 'link'
  model: schema.text
  view: schema.text

toDsl = (text) ->
  links = linkify.match(text)
  lastPos = 0
  nodes = []

  links.forEach (schema) ->
    pos = schema.index

    if pos > lastPos
      nodes.push text.slice(lastPos, pos)

    nodes.push makeLinkDsl(schema)

    lastPos = schema.lastIndex

  if lastPos < text.length
    nodes.push text.slice(lastPos)

  nodes

exports.mark = (dslArray) ->
  dslArray.reduce (array, item) ->
    if util.isString(item) and linkify.test(item)
      array.concat(toDsl(item))
    else
      array.concat(item)
  , []
