
msgDsl = require '../src'

describe "some cases should be parsed", ->
  msgBodyExamples = [
    '<$mark|model|view$>'
    '<$@|a1b2c3|@陈涌$>'
    's <$m|m|v$> s <$m|m|v$> s'
    '<$mark|model|view'
  ]

  it 'should parse all', ->
    msgBodyExamples.forEach (body) ->
      result = msgDsl.read body
      # console.log JSON.stringify result
      convertBack = msgDsl.write result
      # console.log convertBack
      result = body is convertBack
      expect(result).toBe(true)

describe 'generate html for some reason', ->
  htmlData = [
    category: 'at', model: 'a', view: 'b'
  ,
    category: 'bold', model: 'a', view: 'b'
  ,
    category: 'link', model: 'a', view: 'b'
  ,
    '<a>\n<b/>'
  ]
  expectedHtml = '<mention>b</mention><strong>b</strong><a href="a">b</a>&lt;a&gt;<br>&lt;b&#x2F;&gt;'

  it 'should result html', ->
    generatedHtml = msgDsl.writeHtml htmlData
    result = generatedHtml is expectedHtml
    expect(result).toBe(true)

describe 'can provide additional custom make tag function to provide the defaults', ->
  htmlData = [
    category: 'at', model: 'id1', view: 'view1'
  ,
    category: 'at', model: 'all', view: '@all'
  ,
    category: 'bold', model: 'id2', view: 'view2'
  ,
    category: 'link', model: 'id3', view: 'view3'
  ,
    '<a>\n<b/>'
  ,
    category: 'other', model: 'id4', view: 'view4'
  ]
  expectedHtml = [
    '<a data-mention-id="id1">view1</a>'
    '<b>@all</b>'
    '<strong>view2</strong>'
    '<a href="id3">view3</a>'
    '&lt;a&gt;<br>&lt;b&#x2F;&gt;'
    '<other>view4</other>'
  ].join('')

  makeTag = (dsl) ->
    switch dsl.category
      when 'at'
        if dsl.model is 'all'
          "<b>#{dsl.view}</b>"
        else
          "<a data-mention-id=\"#{dsl.model}\">#{dsl.view}</a>"
      when 'other'
        "<other>#{dsl.view}</other>"
      else dsl

  it 'should result html', ->
    generatedHtml = msgDsl.writeHtml htmlData, makeTag
    result = generatedHtml is expectedHtml
    expect(result).toBe(true)

describe 'long text support with tail call recursion', ->
  longText = [1..1000].map(-> 'a <$mark|model|view$> a').join(' ')

  it 'should parse through', ->
    longTextBack = msgDsl.write msgDsl.read longText
    result = longText is longTextBack
    expect(result).toBe(true)
