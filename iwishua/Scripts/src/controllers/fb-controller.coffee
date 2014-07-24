#+--------------------------------------------------------------------+
#| FBController.coffee
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
# Facebook login/logout
#
angular.module('iwishua')
.controller 'FBController',
  ($scope, logger, $facebook) ->

    new class FBController

      constructor: ->
        logger.log "FB Controller initialized"

        $facebook.api("/me").then (response) =>

          @username = response.first_name

