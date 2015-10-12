
msgDsl = require '../src'

msgBodyExamples = [
  '<$mark|model|view$>'
  '<$@|a1b2c3|@陈涌$>'
  's <$m|m|v$> s <$m|m|v$> s'
  '<$mark|model|view'
]

describe "some cases should be parsed", ->
  it 'should parse all', ->
    msgBodyExamples.forEach (body) ->
      result = msgDsl.read body
      # console.log JSON.stringify result
      convertBack = msgDsl.write result
      # console.log convertBack
      result = body is convertBack
      expect(result).toBe(true)


htmlData = [
  category: 'mention', model: 'a', view: 'b'
,
  category: 'bold', model: 'a', view: 'b'
,
  category: 'link', model: 'a', view: 'b'
,
  '<a>\n<b/>'
]
expectedHtml = '<mention>b</mention><strong>b</strong><a href="a">b</a>&lt;a&gt;<br>&lt;b&#x2F;&gt;'

describe 'generate html for some reason', ->
  it 'should result html', ->
    generatedHtml = msgDsl.writeHtml htmlData
    result = generatedHtml is expectedHtml
    expect(result).toBe(true)

longText = [1..1000].map(-> 'a <$mark|model|view$> a').join(' ')

describe 'long text support with tail call recursion', ->
  it 'should parse through', ->
    longTextBack = msgDsl.write msgDsl.read longText
    result = longText is longTextBack
    expect(result).toBe(true)
