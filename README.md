
Message DSL reader/writer of Jianliao.com
----

### Usage

```coffee
msgDsl = require 'msg-dsl'
msgBody = '<$mark|model|view$>'
result = msgDsl.read msgBody
msgDsl.write result
```

Methods:

* `read :: (string) -> array` read DSL array from string
* `write :: (array) -> string ` write string from DSL array
* `writeHtml :: (array) -> string` write HTML string from DSL array
* `recognize :: (string, string, array) -> array` get DSL array from message text
* `flattern :: (array, array) -> string` generate message text from DSL array
* `update :: (array, array) -> array` update information in DSL array

### License

Closed
