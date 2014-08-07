#+--------------------------------------------------------------------+
#| iwishua.coffee
#+--------------------------------------------------------------------+
#| Copyright fivetwofivetwo, LLC (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of iwishua
#|
#| This file is subject to the terms and conditions defined in
#| file 'license.md', which is part of this source code package.
#|
#+--------------------------------------------------------------------+
#
# Application store
#
#
angular.module('iwishua')
.factory 'iwishua',
  (logger, config) ->

    new class Iwishua

      constructor: ->
        logger.log "#{this} initialized"

      version: '0.0.1'
      
      
      toString: =>
        "Iwishua store v#{@version}"
