#+--------------------------------------------------------------------+
#| FriendsController.coffee
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
# Show friends
#
angular.module('iwishua').controller 'FriendsController',
  ($scope, $route, $location, logger, $facebook, iwishua) ->


    new class FriendsController


      friends: null

      constructor: ->

        logger.log "FriendsController initialized"
        $facebook.api("/me/friends", fields: "name,first_name,picture").then (response) =>
          logger.log response
          @friends = response.data
          @product = iwishua.product
          
          