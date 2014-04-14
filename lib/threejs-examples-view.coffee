{View} = require 'atom'
THREE = require "three"

module.exports =
class ThreejsExamplesView extends View
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
    atom.workspaceView.command "threejs-examples:toggle", => @toggle()

  serialize: ->

  destroy: ->
    @detach()

  toggle: ->
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
    @renderer.setSize(window.innerWidth, window.innerHeight)
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

    geometry = new THREE.Geometry()

    for n in [0...100]
      # console.log "creating particle: #{n}"
      particle = new THREE.Sprite material
      particle.position.x = Math.random() * 2 - 1
      particle.position.y = Math.random() * 2 - 1
      particle.position.z = Math.random() * 2 - 1
      particle.position.normalize()
      particle.position.multiplyScalar(Math.random() * 10 + 450)
      particle.scale.x = particle.scale.y = 10
      @scene.add particle
      geometry.vertices.push particle.position

    # lines
    line = new THREE.Line(geometry, new THREE.LineBasicMaterial({color: 0xffffff, opacity: 0.5}))
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
