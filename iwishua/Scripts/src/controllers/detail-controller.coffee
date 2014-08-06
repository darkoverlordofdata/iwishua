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
  (logger, $scope, $modalInstance, $route, productData) ->

    fields = [
      'id'
      'productId'
      'productTitle'
      'productDescription'
      'productImageUrl'
      'productBuyUrl'
      'productKeywords'
      'impressionUrl'
      'isPublished'
      ]

    #
    #   modal popup controller
    #
    new class DetailController

      constructor: () ->
        logger.log "DetailController initialized"

        for field in fields
          this[field] = productData[field]
        $scope.product = @


      ok: () =>
        $modalInstance.close 'OK'

      cancel: () =>
        $modalInstance.dismiss 'cancel'

      delete: () =>
        $modalInstance.close 'DELETE'

      wish: () ->
        $modalInstance.close 'WISH'

