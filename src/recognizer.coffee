
{recur} = require 'tail-call/core'
_ = require 'lodash'

# dlsTable :: [{category: String, model: String, view: String}]
# for example [{category: '@', model: '57acb39', view: 'talkai'}]

matchHead = (chunk, view) ->
  (chunk.indexOf view) is 0

reduceText = recur (result, buffer, text, category, dlsTable) ->
  # console.log 'recuring', result, buffer, text, category
  if text.length is 0
    # push is dirty
    if buffer.length > 0 then result.push buffer
    result
  else
    firstChar = text[0]
    restText = text[1..]
    if firstChar is category
      # matching the rest
      aMatch = _.find dlsTable, (dsl) -> matchHead restText, dsl.view
      # console.log 'aMatch:', aMatch
      if aMatch?
        if buffer.length > 0
          result.push buffer
          buffer = ''
        result.push
          category: category
          model: aMatch.model
          view: "#{category}#{aMatch.view}"
        jumpLength = aMatch.view.length
        behindText = restText[jumpLength..]
        reduceText result, buffer, behindText, category, dlsTable
      else
        reduceText result, "#{buffer}#{firstChar}", restText, category, dlsTable
    else
      reduceText result, "#{buffer}#{firstChar}", restText, category, dlsTable

# support only one category by now
exports.findDsl = (text, category, dlsTable) ->
  # give long views higher priority
  sortedTable = _.sortBy dlsTable, (dsl) ->
    -dsl.view.length
  reduceText [], '', text, category, sortedTable
