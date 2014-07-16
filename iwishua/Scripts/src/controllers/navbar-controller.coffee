#+--------------------------------------------------------------------+
#| NavbarController.coffee
#+--------------------------------------------------------------------+
#| Copyright fivetwofivetwo, LLC (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of iwishua
#|
#| This file is subject to the terms and conditions defined in
#| file 'license.md', which is part of this source code package.
#|
#| Yu Mo Gui Gwai Fai Di Zao
#|
#+--------------------------------------------------------------------+
#
# Track Navbar active state
#
angular.module('iwishua')
.controller 'NavbarController',
  ['$scope', 'logger', '$location',
  ($scope, logger, $location) ->

    new class NavbarController

      constructor: ->
        logger.log "Navbar initialized"

      active: (viewLocation) ->
        viewLocation is $location.path()

  ]