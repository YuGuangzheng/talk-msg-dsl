
msgDsl = require '../src'

exampleDslTable = [
  {model: '1', view: 'C'}
  {model: '1', view: 'React'}
  {model: '1', view: 'Haskell'}
  {model: '1', view: 'Clojure'}
  {model: '1', view: 'Chen Yong'}
  {model: '1', view: 'ClojureScript'}
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
