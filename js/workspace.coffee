THREE = require '../lib/three.min', 'THREE'
class Workspace
  constructor: ->
    @scen = new THREE.Scene()
    @started = Date.now()
    @items =
      time: @started
      frame: 0

  update: (items) ->
    for k, v of items
      @items[k] = v
      if k not of @items and v instanceof THREE.Object3D
        v.addToWorkspace @

    for k, v of @items when k not of items
        delete @items[k]
        @scen.remove v if v instanceof THREE.Object3D

  get: ->
    @items.time = Date.now() - @started
    @items.frame++
    @items


