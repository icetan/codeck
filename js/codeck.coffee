THREE = require '../lib/three.min', 'THREE'

class CODECK
  constructor: (container) ->
    @meta = {}
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

    # create the sphere's material
    #sphereMaterial = new THREE.MeshLambertMaterial({ color: 0xCC0000 })
    wireframeMaterial = new THREE.MeshBasicMaterial(
      color: 0xffffff
      #wireframe: true
      transparent: true
      shading: THREE.FlatShading
      vertexColors: THREE.VertexColors
    )
    #multiMaterial = [ sphereMaterial , wireframeMaterial ]

    # set up the sphere vars
    radius = 50
    segments = 16
    rings = 16

    # create a new mesh with sphere geometry -
    # we will cover the sphereMaterial next!
    @sphere = new THREE.Mesh(
    #new THREE.SceneUtils.createMultiMaterialObject(
      #new THREE.SphereGeometry(radius, segments, rings),
      new THREE.IcosahedronGeometry( 40, 4 ),
      wireframeMaterial)
    @sphere.flipSided = yes
    # add the sphere to the scene
    @scene.add(@sphere)

    # create the plane's material
    segments = 100
    segmentsHalf = segments/2
    planeMaterial = new THREE.MeshLambertMaterial({ color: 0xCC6600 })
    planeGeometry = new THREE.PlaneGeometry(200, 200, segments-1, segments-1)

    plane = new THREE.Mesh(planeGeometry, planeMaterial)
    plane.geometry.dynamic = true
    plane.matrixAutoUpdate = false

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
    lightOn = no
    lightFreq = lightFreq2 = lastLightFreq = 300
    frame = 1
    animloop = =>
      @sphere.rotation.z += 1/lightFreq
      @sphere.rotation.x += 1/lightFreq2
      @sphere.rotation.y = frame/60
      # create an array containing all objects in the scene with which the ray intersects
      vector = new THREE.Vector3( 0, 0, 1 )
      @projector.unprojectVector( vector, @camera )
      @ray = new THREE.Ray( @camera.position, vector.subSelf( @camera.position ).normalize() )
      intersect = @ray.intersectObjects( @scene.children )
      if frame % lightFreq is 0
        lastLightFreq = lightFreq
        lightOn = Math.round(Math.random()*0.6)
        lightFreq = Math.round(Math.random()*200)+1
        lightFreq2 = Math.round(Math.random()*200)+1
        @sphere.material.wireframe = lightOn
      light = lightOn & (frame/2 % 2)
      colors = (new THREE.Color(light * 0xffffff) for i in [1..3])
      for f in @sphere.geometry.faces
        if f.vertexColors.lolz?
          f.vertexColors = (new THREE.Color(Math.random() * 0xffffff) for i in [1..3])
          f.vertexColors.lolz = yes
        else
          f.vertexColors = colors
      if intersect.length > 0
        intersect[0].face.vertexColors = (new THREE.Color(Math.random() * 0xffffff) for i in [1..3])
        intersect[0].face.vertexColors.lolz = yes
        @sphere.geometry.colorsNeedUpdate = yes
      @render()
      requestAnimationFrame(animloop)
      frame += 1
    animloop()

module.exports = CODECK
