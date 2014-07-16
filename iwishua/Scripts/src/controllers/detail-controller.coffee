#+--------------------------------------------------------------------+
#| DetailController.coffee
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
# Show ths wish list
#
angular.module('iwishua')
.controller 'DetailController',
  ['logger', '$scope', '$modalInstance', 'productData',
  (logger, $scope, $modalInstance, productData) ->

    #
    #   modal popup controller
    #
    new class DetailController

      constructor: () ->
        logger.log "DetailController initialized"

        @productName = productData.productName
        @productImageUrl = productData.productImageUrl
        @productTitle = productData.productTitle
        $scope.product = @

      ok: () =>
        $modalInstance.close()

      cancel: () =>
        $modalInstance.dismiss('cancel')

      delete: () =>
        productData.isPublished = false
        $modalInstance.close()

      wish: () ->
        $modalInstance.close()

  ]