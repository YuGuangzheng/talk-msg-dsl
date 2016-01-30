assign = require 'object-assign'
type = require 'type-of'

exports.isString = (s) ->
  (type s) is 'string'

exports.identity = (x)->
  x

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

exports.escapeHtml = (string) -> escape(string, htmlReplacementsRegex, htmlReplacements)
exports.escapeView = (string) -> escape(string, viewReplacementsRegex, viewReplacements)
