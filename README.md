
Message DSL reader/writer of Jianliao.com
----

### Usage

```coffee
msgDsl = require 'msg-dsl'
msgBody = '<$mark|model|view$>'
result = msgDsl.read msgBody
msgDsl.write result
```

### License

Closed
