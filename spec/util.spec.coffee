msgDsl = require '../src'

describe 'escapeHtml', ->
  it 'should escape html ', ->
    html = ["&", "<", ">", '"', "'", "/"].join('')
    escaped = ["&amp;", "&lt;", "&gt;", '&quot;', '&#39;', '&#x2F;'].join('')
    expect(msgDsl.util.escapeHtml(html)).toEqual escaped

describe 'escapeView', ->
  it 'should also replace \n with <br>', ->
    html = ["&", "<", ">", '"', "'", "/", "\n"].join('')
    escaped = ["&amp;", "&lt;", "&gt;", '&quot;', '&#39;', '&#x2F;', "<br>"].join('')
    expect(msgDsl.util.escapeView(html)).toEqual escaped
