{Patch} = require './patch'

class Loop extends Patch
  mute: off

  run: (context) -> @fn(context) if not @mute


module.exports = {Loop}
