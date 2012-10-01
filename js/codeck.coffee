THREE = require '../lib/three.min', 'THREE'
{Patch, createPatchContext} = require './patch'
{Loop, createLoopContext} = require './loop'

class CODECK
  constructor: (container) ->
    @shapes = {}
    @patches = []
    @loops = []
    # set the scene size
    @WIDTH = container.offsetWidth
    @HEIGHT = container.offsetHeight

    # set some camera attributes
    VIEW_ANGLE = 45
    ASPECT = @WIDTH / @HEIGHT
    NEAR = 0.1
    FAR = 1000

    # create a WebGL renderer, camera
    # and a scene
    @renderer = new THREE.WebGLRenderer()
    @camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR)
    @scene = new THREE.Scene()

    # the camera starts at 0,0,0 so pull it back
    @camera.position.z = 65

    @camera.lookAt(@scene.position)

    # start the renderer
    @renderer.setSize(@WIDTH, @HEIGHT)

    # attach the render-supplied DOM element
    container.appendChild(@renderer.domElement)

    # create the plane's material
    #segments = 100
    #segmentsHalf = segments/2
    #planeMaterial = new THREE.MeshLambertMaterial({ color: 0xCC6600 })
    #planeGeometry = new THREE.PlaneGeometry(200, 200, segments-1, segments-1)

    #plane = new THREE.Mesh(planeGeometry, planeMaterial)
    #plane.geometry.dynamic = true
    #plane.matrixAutoUpdate = false

    # add the plane to the scene
    #scene.add(plane)

    # and the camera
    @scene.add(@camera)

    # create a point light
    pointLight = new THREE.PointLight(0xFFFFFF)

    # set its position
    pointLight.position.x = 10
    pointLight.position.y = 50
    pointLight.position.z = 130

    # add to the scene
    @scene.add(pointLight)

    # initialize object to perform world/screen calculations
    @projector = new THREE.Projector()
    # create a Ray with origin at the mouse position
    #   and direction into the scene (camera direction)
    @controls = new THREE.TrackballControls(@camera, @renderer.domElement)
    @patchContext = createPatchContext @scene, @camera
    @loopContext = createLoopContext @patchContext

  runLoops: -> codeLoop.run(@loopContext) for codeLoop in @loops

  addPatch: (patch) ->
    @patches.push patch
    patch.run @patchContext

  addLoop: (codeLoop) ->
    @loops.push codeLoop

  # draw!
  render: ->
    @renderer.render(@scene, @camera)
    #plane.updateMatrix()
    @controls.update()

  #function ripple (t) {
  #  for (var x, y, z, vert, i = 0, len = plane.geometry.vertices.length; i < len; i++) {
  #    x = (i % (segments)) - segmentsHalf
  #    y = Math.floor(i / (segments)) - segmentsHalf
  #    vert = plane.geometry.vertices[i]
  #    #z = Math.sin(ix*iy) * 50
  #    z = Math.cos(Math.sqrt((x * x + y * y) * 100)/100 + t) / Math.exp((x * x + y * y)/1000)
  #    vert.z = z * 100
  #  }
  #  plane.geometry.verticesNeedUpdate = true
  #}

  #container.onmousemove = function (e) {
  #  var axisX = e.offsetX * 2 / container.offsetWidth - 1
  #  var axisY = e.offsetY * 2 / container.offsetHeight - 1
  #  camera.rotation.set(0, axisX, axisY)
  #}

  start: ->
    lc = @loopContext
    timeStart = Date.now()
    animloop = =>
      lc.frame += 1
      lc.time = Date.now() - timeStart
      @runLoops()
      @render()
      requestAnimationFrame(animloop)
    animloop()

module.exports = CODECK
