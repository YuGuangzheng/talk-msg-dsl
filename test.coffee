
reader = require './src/reader'
writer = require './src/writer'

msgBodyExamples = [
  '<$mark|model|view$>'
  '<$@|a1b2c3|@陈涌$>'
  's <$m|m|v$> s <$m|m|v$> s'
  '<$mark|model|view'
]

do main = ->
  msgBodyExamples.forEach (body) ->
    result = reader.read body
    console.log JSON.stringify result
    convertBack = writer.write result
    console.log convertBack
    console.log (body is convertBack)

  # test performance and tco
  longText = [1..1000].map(-> 'a <$mark|model|view$> a').join(' ')
  longTextBack = writer.write reader.read longText
  console.log (longText is longTextBack)
