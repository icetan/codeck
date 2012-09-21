class Loop extends Code
  constructor: (code) ->
    @mute = off
    @compile code

  run: (meta) -> @fn meta if not @mute
