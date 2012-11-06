THREE = require '../lib/three.min', 'THREE'
csCompile = require('coffee-script-browser', 'CoffeeScript').compile


class Patch
  compile: (code) ->
    js = csCompile code, {bare:yes}
    @fn = eval "f=function(__v__){with(__v__){#{js}}}"

  # dict meta:
  #   int frame: count
  #   int time: elapsed in ms
  #   int beat: count
  #   float bpms: beats per ms
  #   int width: of canvas
  #   int height: of canvas
  #   dict plugs: plugins
  #   Object3D shapes: THREE objects in workspace
  run: (meta) -> @fn meta

  getCode: -> @fn.toString()

createPatchContext = (scene, camera) ->
  objs = []
  context =
    THREE: THREE
    scene: scene
    camera: camera
    lc: {}
    frame: 0
    time: 0
    projector: new THREE.Projector()

    clear: -> @scene.remove obj for name, obj of objs

    obj: (name, fn) ->
      obj = objs[name]
      fn.call(obj) if fn?
      obj

    material: (color, wf, vcolor) ->
      new THREE.MeshBasicMaterial
        color: color
        wireframe: wf
        transparent: true
        shading: THREE.FlatShading
        vertexColors: (if vcolor? then vcolor else false)

    icosphere: (name, radius, seg, material) ->
      #new THREE.SceneUtils.createMultiMaterialObject(
      obj = new THREE.Mesh(
        new THREE.IcosahedronGeometry(radius or 1, seg or 1),
        material or @material(0xffffff, true)
      )
      @scene.add(obj)
      objs[name] = obj

    box: (name, width, height, depth, material) ->
      obj = new THREE.Mesh(
        new THREE.CubeGeometry(
          width or 1,
          height or 1,
          depth or 1,
          1, 1, 1),
        material or @material(0xffffff, true)
      )
      @scene.add(obj)
      objs[name] = obj

    color: (c) -> new THREE.Color c
    vec2: (x, y) -> new THREE.Vector2 x, y
    vec3: (x, y, z) -> new THREE.Vector3 x, y, z
    vec4: (a, b, c, d) -> new THREE.Vector4 a, b, c, d
    ray: (v1, v2) -> new THREE.Ray v1, v2
  context[k] = Math[k] for k in Object.getOwnPropertyNames(Math)
  context

module.exports = {Patch, createPatchContext}
