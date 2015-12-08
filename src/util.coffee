type = require 'type-of'

module.exports.isString = (s) ->
  (type s) is 'string'

module.exports.identity = (x)->
  x
