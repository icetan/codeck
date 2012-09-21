Code = require 'code'

class Routine
  constructor: ->
    @next = 0
    @subRoutines = []

  run: ->
    sr.run() for sr in @subRoutines


class SubRoutine extends Code
  constructor: (code) -> @compile code

  run: (meta) -> @fn meta

module.exports = {
  Routine
  SubRoutine
}
