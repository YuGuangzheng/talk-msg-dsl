link = require '../src/link'

describe 'recognize link among text', ->
  it 'should find link', ->
    textWithOnlyLink = 'http://cirru.org'
    resultWithOnlyLink = [
      category: 'link'
      model: 'http://cirru.org'
      view: 'http://cirru.org'
    ]
    result = link.mark [textWithOnlyLink]
    expect(result).toEqual(resultWithOnlyLink)

  it 'should add http href ', ->
    textWithOnlyLink = 'cirru.org'
    resultWithOnlyLink = [
      category: 'link'
      model: 'http://cirru.org'
      view: 'cirru.org'
    ]
    result = link.mark [textWithOnlyLink]
    expect(result).toEqual(resultWithOnlyLink)

  it 'should find a link inside', ->
    textWithLink = 'a http://cirru.org b'
    resultWithLink = [
      'a '
    ,
      category: 'link'
      model: 'http://cirru.org'
      view: 'http://cirru.org'
    ,
      ' b'
    ]
    result = link.mark [textWithLink]
    expect(result).toEqual(resultWithLink)

  it 'should find links', ->
    textWithLinks = 'a   http://cirru.org    http://tiye.me baidu.com/中文 b'
    resultWithLinks = [
      'a   '
    ,
      category: 'link'
      model: 'http://cirru.org'
      view: 'http://cirru.org'
    ,
      '    '
    ,
      category: 'link'
      model: 'http://tiye.me'
      view: 'http://tiye.me'
    ,
      ' '
    ,
      category: 'link'
      model: 'http://baidu.com/中文'
      view: 'baidu.com/中文'
    ,
      ' b'
    ]
    result = link.mark [textWithLinks]
    expect(result).toEqual(resultWithLinks)

  it 'should handle mixed data', ->
    textMixed = ['a http://cirru.org b',
      category: '@'
      model: '123'
      view: '123'
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
    result = link.mark textMixed
    expect(result).toEqual(resultMixed)
