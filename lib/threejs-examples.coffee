ThreejsExamplesView = require './threejs-examples-view'
ThreejsGameView = require './threejs-game-view'

module.exports =
  threejsExamplesView: null
  threejsGameView: null

  activate: (state) ->
    console.log "activating."
    @threejsExamplesView = new ThreejsExamplesView(state.threejsExamplesViewState)
    @threejsGameView = new ThreejsGameView(state.threejsGameViewState)

  deactivate: ->
    @threejsExamplesView.destroy()
    @threejsGameView.destroy()

  serialize: ->
    threejsExamplesViewState: @threejsExamplesView.serialize()
    threejsGameViewState: @threejsGameView.serialize()
