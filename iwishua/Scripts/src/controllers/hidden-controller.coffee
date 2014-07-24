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
  ($scope, $window, $location, $route, $localStorage, logger, datacontext, config, cache, usSpinnerService) ->

    new class HiddenController

      isBusy: true
      spinnerName: 'spinner-restore'

      constructor: ->
        logger.log "HiddenController initialized"
        cache.importEntities()
        @products = cache.getDeleted()
        @config = config

      #
      # restore - Undelete the product
      #
      # @parm product
      #
      restore: (product) =>

        $scope.$on cache.eventName(), () =>
          @spinner false
          if datacontext.counts.Deleted is 0
            $location.path($window.location.pathname)
          else
            $route.reload()

        datacontext.unDeleteProduct product
        @spinner true

      #
      # reset - Clear the cache
      #
      reset: =>

        $localStorage.$reset()
        $window.location.replace($window.location.origin+$window.location.pathname)

      #
      # spinner - Start/Stop the spinner
      #
      # @parm start - true/false
      #
      spinner: (start) =>

        if (@isBusy = start)
          usSpinnerService.spin @spinnerName
        else
          usSpinnerService.stop @spinnerName

