#+--------------------------------------------------------------------+
#| HiddenController.coffee
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
.controller 'HiddenController',
  ['$scope', '$window', '$route', '$cookies', '$localStorage', 'logger', 'datacontext', 'config', 'entity-cache', 'usSpinnerService',
  ($scope, $window, $route, $cookies, $localStorage, logger, datacontext, config, entityCache, usSpinnerService) ->

    new class HiddenController


      constructor: ->
        logger.log "HiddenController initialized"
        @products = entityCache.getDeleted()

      restore: (product) =>
        $scope.$on entityCache.eventName(), () =>
          usSpinnerService.stop 'spinner-restore'
          $route.reload()

        datacontext.unDeleteProduct product
        usSpinnerService.spin 'spinner-restore'

      reset: =>
        $localStorage.$reset()
        delete $cookies['skip']
        $window.location.replace($window.location.origin+$window.location.pathname)


  ]