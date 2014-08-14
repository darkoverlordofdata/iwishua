#+--------------------------------------------------------------------+
#| PostController.coffee
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
# Post the Friend+Gift to facebook
#
angular.module('iwishua')
.controller 'PostController',
  (logger, $scope, $modalInstance, $route, model, productData, friendData) ->

    #
    #   modal popup controller
    #
    new class PostController

      wish: "Enter your wish"
      state: 'OK'
      
      
      constructor: () ->
        logger.log "PostController initialized"

        @productImageUrl = productData.productImageUrl
        @productTitle = productData.productTitle
        @productName = productData.productName
        @name = friendData.name
        @wish = "I wish that #{friendData.first_name} had this #{productData.productTitle}"
        $scope.friend = @


      ok: () =>
        @state = 'OK'
        $modalInstance.close @

      cancel: () =>
        $modalInstance.dismiss 'cancel'

      share: () ->
        @state = 'POST'
        $modalInstance.close @

