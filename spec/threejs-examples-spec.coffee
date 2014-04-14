ThreejsExamples = require '../lib/threejs-examples'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "ThreejsExamples", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('threejsExamples')

  describe "when the threejs-examples:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.threejs-examples')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'threejs-examples:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.threejs-examples')).toExist()
        atom.workspaceView.trigger 'threejs-examples:toggle'
        expect(atom.workspaceView.find('.threejs-examples')).not.toExist()
