#
#  Lightweight module manager using AMD-wrapped CommonJS pattern
#   @see http://know.cujojs.com/tutorials/modules/authoring-amd-modules#AMD-wrapped-CommonJS
#
#  The page still needs to load the modules explicitly and in the
#  correct order. Modular creates only the Define/Require semantics.
#
#
modules = {}

require = (name) ->
  modules[name]

Object.defineProperties @,
  'define': value: (name, define) ->
    module = {}
    exports = {}
    define require, exports, module
    #
    # Check semantics
    #
    if module.exports?
      #
      # module.exports = ->
      #
      modules[name] = module.exports
    else
      #
      # exports = {...}
      #
      module[key] = {}
      for key, value of exports
        module[key] = value
      modules[name] = module

