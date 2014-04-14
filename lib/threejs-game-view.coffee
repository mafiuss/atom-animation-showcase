{View} = require 'atom'
THREE = require "three"

module.exports =
class ThreejsGameView extends View
  SCREEN_WIDTH: window.innerWidth
  SCREEN_HEIGHT: window.innerHeight
  mouseX: 0
  mouseY: 0
  windowHalfX: window.innerWidth / 2
  windowHalfY: window.innerHeight / 2
  SEPARATION: 200
  AMOUNTX: 10
  AMOUNTY: 10
  camera: null
  scene: null
  renderer: null

  @content: ->
    @div class: 'threejs-examples overlay from-top', =>
      @div class: "viewer", mousemove: 'onDocumentMouseMove', outlet: "threeContainer"

  initialize: (serializeState) ->
    console.log 'init'
    atom.workspaceView.command "threejs-examples:doggle", => @doggle()

  serialize: ->

  destroy: ->
    @detach()

  doggle: ->
    console.log "ThreejsExamplesView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
      @threeInit()
      @animate()

  threeInit: ->
    separation = 100
    amountX = 50
    amountY = 50
    particles = null
    particle = null

    @camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 10000)
    @camera.position.z = 100

    @scene = new THREE.Scene()
    @renderer = new THREE.CanvasRenderer()
    @renderer.setSize(@SCREEN_WIDTH, @SCREEN_HEIGHT)
    @threeContainer.empty()
    @threeContainer.append(@renderer.domElement)


    #particles
    PI2 = Math.PI * 2
    options =
      color: 0xffffff
      program: (context) ->
        context.beginPath()
        context.arc(0, 0, 0.5, 0, PI2, true)
        context.fill()

    material = new THREE.SpriteCanvasMaterial options

    for n in [0...100]
      particle = new THREE.Sprite material
      particle.position.x = Math.random() * 2 - 1
      particle.position.y = Math.random() * 2 - 1
      particle.position.z = Math.random() * 2 - 1
      particle.position.normalize()
      particle.position.multiplyScalar(Math.random() * 10 + 450)
      particle.scale.multiplyScalar 2
      @scene.add particle



    for n in [0...300]
      geometry = new THREE.Geometry()
      vertex = new THREE.Vector3(Math.random() * 2 - 1, Math.random() * 2 - 1, Math.random() * 2 - 1)
      vertex.normalize()
      vertex.multiplyScalar 450
      vertex2 = vertex.clone()
      geometry.vertices.push(vertex)
      vertex2.multiplyScalar(Math.random() * 0.3 + 1)
      geometry.vertices.push vertex2

      line = new THREE.Line(geometry, new THREE.LineBasicMaterial({color: 0xffffff, opacity: Math.random()}))
      @scene.add line

  animate: =>
    try
      requestAnimationFrame @animate
    catch error
      console.log "The error was #{error}"
    @render()

  render: ->
    @camera.position.x += (@mouseX - @camera.position.x) * .05
    @camera.position.y += (-@mouseY + 200 - @camera.position.y) * .05
    @camera.lookAt(@scene.position)
    @renderer.render(@scene, @camera)

  onDocumentMouseMove: (event) ->
    @mouseX = event.clientX - @windowHalfX
		@mouseY = event.clientY - @windowHalfY
