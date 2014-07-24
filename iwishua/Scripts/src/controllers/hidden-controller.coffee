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
  ['$scope', '$window', '$location', '$route', '$localStorage', 'logger', 'datacontext', 'config', 'cache', 'usSpinnerService',
  ($scope, $window, $location, $route, $localStorage, logger, datacontext, config, cache, usSpinnerService) ->

    new class HiddenController


      constructor: ->
        logger.log "HiddenController initialized"
        cache.importEntities()
        @products = cache.getDeleted()
        @config = config

      restore: (product) =>

        $scope.$on cache.eventName(), () =>
          usSpinnerService.stop 'spinner-restore'
          if datacontext.counts.Deleted is 0
            $location.path($window.location.pathname)
          else
            $route.reload()

        datacontext.unDeleteProduct product
        usSpinnerService.spin 'spinner-restore'

      reset: =>
        $localStorage.$reset()
        $window.location.replace($window.location.origin+$window.location.pathname)


  ]