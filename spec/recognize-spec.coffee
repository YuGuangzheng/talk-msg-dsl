msgDsl = require '../src'

describe 'recognize', ->

  categories = [
    {category: 'at', view: '@'}
    {category: 'room', view: '#'}
    {category: 'story', view: '#'}
    {category: 'group', view: '@'}
  ]

  it 'should handle empty categories', ->
    dslTable = []
    text = "Hi @test"
    output = msgDsl.recognize text, [], dslTable
    expect(output).toEqual [text]

  it 'should handle empty dslTable', ->
    dslTable = []
    text = "Hi @test"
    output = msgDsl.recognize text, categories, dslTable
    expect(output).toEqual [text]

  it 'should handle a simple case', ->
    dslTable = [
      {category: 'at', model: '1', view: 'test'}
    ]
    text = "@test"
    result = [
      {category: 'at', model: '1', view: '@test'}
    ]
    output = msgDsl.recognize text, categories, dslTable
    expect(output).toEqual result

  it 'should match a result', ->
    dslTable = [
      {category: 'at',    model: '1', view: 'C'}
      {category: 'at',    model: '2', view: 'React'}
      {category: 'at',    model: '3', view: 'Haskell'}
      {category: 'at',    model: '4', view: 'Clojure'}
      {category: 'at',    model: '5', view: 'Chen Yong'}
      {category: 'at',    model: '6', view: 'ClojureScript'}
      {category: 'room',  model: '7', view: 'room1'}
      {category: 'story', model: '8', view: 'story1'}
      {category: 'group', model: '9', view: 'group1'}
    ]
    text =
      "My name is @Chen Yong, I prefer @Clojure @React than @C, #room1, #story1, @group1"
    result = [
      'My name is '
      {category: 'at', model: '5', view: '@Chen Yong'}
      ', I prefer ',
      {category: 'at', model: '4', view: '@Clojure'}
      ' '
      {category: 'at', model: '2', view: '@React'}
      ' than '
      {category: 'at', model: '1', view: '@C' }
      ', '
      {category: 'room', model: '7', view: '#room1' }
      ', '
      {category: 'story', model: '8', view: '#story1' }
      ', '
      {category: 'group', model: '9', view: '@group1' }
    ]
    output = msgDsl.recognize text, categories, dslTable
    expect(output).toEqual(result)

  it 'should match werid texts', ->
    dslTable = [
      {category: 'at', model: '1', view: 'mention#1'}
      {category: 'room', model: '2', view: 'room@2'}
      {category: 'at', model: '3', view: 'Chen Yong'}
    ]
    text =
      "Hi@mention#1#room@2@Chen YongBye"
    result = [
      "Hi"
      {category: 'at', model: '1', view: '@mention#1'}
      {category: 'room', model: '2', view: '#room@2'}
      {category: 'at', model: '3', view: '@Chen Yong'}
      "Bye"
    ]
    output = msgDsl.recognize text, categories,  dslTable
    expect(output).toEqual(result)

  it 'should match even more werid texts', ->
    dslTable = [
      {category: 'at', model: '1', view: '#mention'}
      {category: 'room', model: '2', view: '@room'}
    ]
    text =
      "@#mention #@room"
    result = [
      {category: 'at', model: '1', view: '@#mention'}
      ' '
      {category: 'room', model: '2', view: '#@room'}
    ]
    output = msgDsl.recognize text, categories, dslTable
    expect(output).toEqual(result)

  it 'should match same views but different categories', ->
    dslTable = [
      {category: 'at', model: '1', view: '小艾'}
      {category: 'room', model: '2', view: '小艾'}
    ]
    text =
      "@小艾#小艾"
    result = [
      {category: 'at', model: '1', view: '@小艾'}
      {category: 'room', model: '2', view: '#小艾'}
    ]
    output = msgDsl.recognize text, categories, dslTable
    expect(output).toEqual(result)

  it 'should handle texts that are not in the dsl table', ->
    dslTable = [
      {category: 'at', model: '1', view: '小艾'}
    ]
    text =
      "@小艾 @Chen Yong"
    result = [
      {category: 'at', model: '1', view: '@小艾'}
      ' @Chen Yong'
    ]
    output = msgDsl.recognize text, categories, dslTable
    expect(output).toEqual(result)

  it 'should handle large texts', ->
    dslTable = [1..10000].map (i) ->
      {category: 'at', model: i, view: 'test' + i}
    text = [1..10000].map((i) -> "@test" + i).join('')
    result = [1..10000].map (i) ->
      {category: 'at', model: i, view: '@test' + i}

    start = new Date().valueOf()
    output = msgDsl.recognize text, categories, dslTable
    end = new Date().valueOf()
    expect(output).toEqual result
    expect(end - start).toBeLessThan 100
