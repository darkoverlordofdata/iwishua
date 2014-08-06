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
  (logger, $scope, $modalInstance, $route, productData, datacontext) ->

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

      OK    : 1
      CANCEL: 2
      DELETE: 3
      WISH  : 4
      
      constructor: () ->
        logger.log "DetailController initialized"

        for field in fields
          this[field] = productData[field]
        $scope.product = @


      ok: () =>
        $modalInstance.close @OK

      cancel: () =>
        $modalInstance.dismiss 'cancel'

      delete: () =>
        datacontext.deleteProduct productData
        $route.reload()
        $modalInstance.close @DELETE

      wish: () ->
        $modalInstance.close @WISH

