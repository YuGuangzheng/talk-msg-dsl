
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
    # console.log JSON.stringify result
    convertBack = writer.write result
    # console.log convertBack
    console.assert (body is convertBack), 'should match after convert'

  # test performance and tco
  longText = [1..1000].map(-> 'a <$mark|model|view$> a').join(' ')
  longTextBack = writer.write reader.read longText
  console.assert (longText is longTextBack), 'should handle long content'

  generatedHtml = writer.writeHtml [
    category: 'mention', model: 'a', view: 'b'
  ,
    category: 'bold', model: 'a', view: 'b'
  ,
    category: 'link', model: 'a', view: 'b'
  ]
  expectedHtml = '<mention>b</metion><strong>b</strong><a href="a">b</a>'
  console.assert (generatedHtml is expectedHtml), 'should return html'
