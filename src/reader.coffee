
# https://gist.github.com/Gozala/1697037
{recur} = require 'tail-call/core'

parse = recur (result, buffer, dsl, state, remaining) ->
  # console.log result, remaining
  if remaining.length is 0
    return if state is 'text'
      if buffer.length > 0 then result.concat buffer else result
    else
      if dsl.raw.length > 0 then result.concat dsl.raw else result
  switch state
    when 'text'
      if remaining[0..1] is '<$'
        result = result.concat buffer if buffer.length > 0
        buffer = ''
        dsl = category: '', model: '', view: '', raw: '<$'
        state = 'category'
        remaining = remaining[2..]
        parse result, buffer, dsl, state, remaining
      else
        buffer += remaining[0]
        remaining = remaining[1..]
        parse result, buffer, dsl, state, remaining
    when 'category'
      dsl.raw += remaining[0]
      if remaining[0] is '|'
        dsl.category = buffer
        buffer = ''
        state = 'model'
        remaining = remaining[1..]
        parse result, buffer, dsl, state, remaining
      else
        buffer += remaining[0]
        remaining = remaining[1..]
        parse result, buffer, dsl, state, remaining
    when 'model'
      dsl.raw += remaining[0]
      if remaining[0] is '|'
        dsl.model = buffer
        buffer = ''
        state = 'view'
        remaining = remaining[1..]
        parse result, buffer, dsl, state, remaining
      else
        buffer += remaining[0]
        remaining = remaining[1..]
        parse result, buffer, dsl, state, remaining
    when 'view'
      if remaining[0..1] is '$>'
        dsl.view = buffer
        dsl.raw += '$>'
        buffer = ''
        result = result.concat dsl
        dsl = null
        state = 'text'
        remaining = remaining[2..]
        parse result, buffer, dsl, state, remaining
      else
        dsl.raw += remaining[0]
        buffer += remaining[0]
        remaining = remaining[1..]
        parse result, buffer, dsl, state, remaining
    else throw "unknown state '#{state}'"

exports.read = (text) ->
  result = []
  buffer = ''
  dsl = null
  state = 'text' # 'category', 'model', 'view', 'text'
  remaining = text

  parse result, buffer, dsl, state, remaining
