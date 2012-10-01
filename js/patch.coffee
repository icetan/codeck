THREE = require '../lib/three.min', 'THREE'
csCompile = require('coffee-script-browser', 'CoffeeScript').compile

class Patch
  compile: (code) ->
    js = csCompile code, {bare:yes}
    @fn = eval "f=function(__values__){with(__values__||{}){#{js}}}"

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
  context =
    THREE: THREE
    scene: scene
    camera: camera
    objs: []
    lc: {}

    projector: new THREE.Projector()
    obj: (name, fn) ->
      obj = @objs[name]
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
      @objs[name] = obj

    box: (name, width, height, depth, material) ->
      obj = new THREE.Mesh(
      #new THREE.SceneUtils.createMultiMaterialObject(
        #new THREE.SphereGeometry(radius, segments, rings),
        new THREE.CubeGeometry(
          width or 1,
          height or 1,
          depth or 1,
          1, 1, 1),
        material or @material(0xffffff, true)
      )
      @scene.add(obj)
      @objs[name] = obj

    color: (args...) -> new THREE.Color args...
    vec2: (args...) -> new THREE.Vector2 args...
    vec3: (args...) -> new THREE.Vector3 args...
    vec4: (args...) -> new THREE.Vector4 args...
    ray: (args...) -> new THREE.Ray args...
  context[k] = Math[k] for k in Object.getOwnPropertyNames(Math)
  context

module.exports = {Patch, createPatchContext}
