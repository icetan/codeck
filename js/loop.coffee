{Patch} = require './patch'

class Loop extends Patch
  mute: off

  run: (context) -> @fn(context) if not @mute


createLoopContext = (patchContext) ->
  context =
    frame: 0
    time: 0
  context[k] = v for k, v of patchContext
  context

module.exports = {Loop, createLoopContext}
