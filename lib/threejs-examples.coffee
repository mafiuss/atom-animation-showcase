ThreejsExamplesView = require './threejs-examples-view'

module.exports =
  threejsExamplesView: null

  activate: (state) ->
    @threejsExamplesView = new ThreejsExamplesView(state.threejsExamplesViewState)

  deactivate: ->
    @threejsExamplesView.destroy()

  serialize: ->
    threejsExamplesViewState: @threejsExamplesView.serialize()
