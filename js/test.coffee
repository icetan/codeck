THREE = require '../lib/three.min', 'THREE'
CODECK = require './codeck'
{Patch} = require './patch'
{Loop} = require './loop'

patch1 =
  """
  lc.lightOn = no
  lc.lightFreq = lc.lightFreq2 = lc.lastLightFreq = 300
  #icosphere 'globe', 40, 4, material(0xffffff, false, THREE.VertexColors)
  """

loop1 =
  """
  clear()
  box('cube', 10, 20, 2, new THREE.MeshLambertMaterial({ color: 0x333333 }))
  light = lc.lightOn & (frame/2 % 2)
  colors = (color(light * 0xffffff) for i in [1..3])
  v = vec3 0, 0, 1
  projector.unprojectVector(v, camera)
  r = ray camera.position, v.subSelf(camera.position).normalize()
  intersect = r.intersectObjects(scene.children)
  obj 'cube', ->
    #@position.x = 10 * sin(frame/100-i*10)
    #@position.z = 10 * cos frame/100-i*10
    @rotation.y = time
    #@rotation.z = frame/60/i
  obj 'globe', ->
    return
    @rotation.z += 1/lc.lightFreq
    @rotation.x += 1/lc.lightFreq2
    @rotation.y = frame/60
    if frame % lc.lightFreq is 0
      lastLightFreq = lc.lightFreq
      lc.lightOn = round(random()*0.6)
      lc.lightFreq = round(random()*200)+1
      lc.lightFreq2 = round(random()*200)+1
      @material.wireframe = lc.lightOn
    for f in @geometry.faces
      if f.vertexColors.lolz?
        f.vertexColors = (color(random() * 0xffffff) for i in [1..3])
        f.vertexColors.lolz = yes
      else
        f.vertexColors = colors
    if intersect.length > 0
      intersect[0].face.vertexColors = (color(random() * 0xffffff) for i in [1..3])
      intersect[0].face.vertexColors.lolz = yes
      @geometry.colorsNeedUpdate = yes
  """

mainPatch = new Patch
mainPatch.compile patch1

mainLoop = new Loop
mainLoop.compile loop1

module.exports = (container) ->
  @codeck = new CODECK(container)
  @codeck.addPatch mainPatch
  @codeck.addLoop mainLoop
  @codeck.start()
