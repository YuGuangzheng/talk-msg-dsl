
link = require '../src/link'

textWithOnlyLink = 'http://cirru.org'
textWithLink = 'a http://cirru.org b'
textWithLinks = 'a http://cirru.org http://tiye.me b'
textMixed = ['a http://cirru.org b',
  category: '@'
  model: '123'
  view: '123'
]

resultWithOnlyLink = [
  category: 'link'
  model: 'http://cirru.org'
  view: 'http://cirru.org'
]
resultWithLink = [
  'a '
,
  category: 'link'
  model: 'http://cirru.org'
  view: 'http://cirru.org'
,
  ' b'
]
resultWithLinks = [
  'a '
,
  category: 'link'
  model: 'http://cirru.org'
  view: 'http://cirru.org'
,
  category: 'link'
  model: 'http://tiye.me'
  view: 'http://tiye.me'
,
  ' b'
]
resultMixed = [
  'a '
,
  category: 'link'
  model: 'http://cirru.org'
  view: 'http://cirru.org'
,
  ' b'
,
  category: '@'
  model: '123'
  view: '123'
]


describe 'recognize link among text', ->
  it 'should find link', ->
    result = link.mark [textWithOnlyLink]
    expect(result).toEqual(resultWithOnlyLink)

  it 'should find a link inside', ->
    result = link.mark [textWithLink]
    expect(result).toEqual(resultWithLink)

  it 'should find links', ->
    result = link.mark [textWithLink]
    expect(result).toEqual(resultWithLink)

  it 'should handle mixed data', ->
    result = link.mark textMixed
    expect(result).toEqual(resultMixed)
