
msgDsl = require '../src'

exampleList = [
  'this is a '
  {category: '@', model: '1', view: 'Curry Haskell'}
]
exampleTable = [
  {model: '1', view: 'Haskell'}
  {model: '2', view: 'Clojure'}
  {model: '3', view: 'Elixir'}
]

exampleResult = 'this is a Haskell'

describe "flattern", ->
  it 'should match default', ->
    result = msgDsl.flattern exampleList, exampleTable
    expect(result).toEqual (exampleResult)

  it 'should handle undefined dsl table', ->
    result = msgDsl.flattern exampleList
    expect(result).toEqual 'this is a Curry Haskell'
