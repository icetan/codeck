csCompile = require('coffee-script-browser').compile

class Code
  compile: (@code) -> 
    js = csCompile 'return '+@code, {bare:true}
    @fn = eval "function(v){with(v||{}){#{js}}}"

  # dict meta:
  #   int frame: count
  #   int time: elapsed in ms
  #   int beat: count
  #   float bpms: beats per ms
  #   int width: of canvas
  #   int height: of canvas
  #   dict plug: plugins
  run: (meta) -> @fn meta
