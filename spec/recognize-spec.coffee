
msgDsl = require '../src'

exampleDslTable = [
  {category: '@', model: '1', view: 'C'}
  {category: '@', model: '1', view: 'React'}
  {category: '@', model: '1', view: 'Haskell'}
  {category: '@', model: '1', view: 'Clojure'}
  {category: '@', model: '1', view: 'Chen Yong'}
  {category: '@', model: '1', view: 'ClojureScript'}
]
exampleText = "My name is @Chen Yong, I prefer @Clojure @React than @C"

exampleResult = ['My name is ', {
  category: '@',
  model: '1',
  view: '@Chen Yong'
}, ', I prefer ', {
  category: '@',
  model: '1',
  view: '@Clojure'
}, ' ', {
  category: '@',
  model: '1',
  view: '@React'
}, ' than ', {
  category: '@',
  model: '1',
  view: '@C'
}]

describe "recognize DSL from text", ->
  it 'should match a result', ->
    result = msgDsl.recognize exampleText, '@', exampleDslTable
    expect(result).toEqual(exampleResult)
