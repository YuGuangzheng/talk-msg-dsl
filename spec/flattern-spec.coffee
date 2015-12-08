
msgDsl = require '../src'

describe "flattern", ->
  exampleList = [
    'this is a '
    {category: 'at', model: 'id1', view: 'Curry Haskell'}
    {category: 'at', model: 'all', view: '@all'}
  ]
  exampleTable = [
    {model: 'id1', view: 'Haskell'}
    {model: 'id2', view: 'Clojure'}
    {model: 'id3', view: 'Elixir'}
  ]

  it 'should match default', ->
    result = msgDsl.flattern exampleList, exampleTable
    expect(result).toEqual 'this is a Haskell@all'

  it 'should handle undefined dsl table', ->
    result = msgDsl.flattern exampleList
    expect(result).toEqual 'this is a Curry Haskell@all'

  it 'can provide custom makeTag function', ->
    makeTag = (dsl) ->
      if dsl.category is 'at'
        "*#{dsl.view}*"
      else
        dsl

    result = msgDsl.flattern exampleList, null, makeTag
    expect(result).toEqual 'this is a *Curry Haskell**@all*'
