# please see spec for example usage

exports.findDsl = (str, categories, dslTable) ->
  return [str] if not categories?.length
  return [str] if not dslTable?.length

  # turn dsl into a trie for fast lookups
  trie = new Trie()
  dslTable.forEach (dsl) ->
    categories.forEach (category) ->
      if category.category is dsl.category
        trie.put("#{category.view}#{dsl.view}", dsl)

  # loop through the str and find the dsl substring inside the trie
  items = []
  i = 0
  while i < str.length
    categories.forEach (category) ->
      if category.view is str[i]
        found = trie.find(str.slice(i))
        if found
          item =
            index: i
            lastIndex: i + found.view.length + category.view.length
            value:
              category: found.category
              model: found.model
              view: "#{category.view}#{found.view}"
          items.push item
          i = item.lastIndex - 1
    i += 1

  # turn str into dsl array
  nodes = []
  lastPos = 0
  items.forEach (item) ->
    pos = item.index
    if pos > lastPos
      nodes.push str.slice(lastPos, pos)
    nodes.push item.value
    lastPos = item.lastIndex
  if lastPos < str.length
    nodes.push str.slice(lastPos)

  nodes

# a simple happy little trie ;-)
Trie = (key) ->
  @key = key

Trie::put = (str, value) ->
  node = this

  for s in str
    if not node[s]
      node[s] = new Trie(s)
    node = node[s]

  node.value = value
  node.str = str

Trie::find = (str) ->
  node = this
  found = null

  for s, i in str
    n = node[s]
    if not (n and n.key)
      break
    if n.value and n.value.view.length is i \
    and not n[str[i + 1]] # look ahead to match a longer pattern
      found = n
      break
    node = n

  found?.value
