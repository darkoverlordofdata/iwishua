#+--------------------------------------------------------------------+
#| OptionsController.coffee
#+--------------------------------------------------------------------+
#| Copyright fivetwofivetwo, LLC (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of iwishua
#|
#| This file is subject to the terms & conditions defined in
#| file 'license.md', which is part of this source code package.
#|
#| Yu Mo Gui Gwai Fai Di Zao
#|
#+--------------------------------------------------------------------+
#
# Show ths wish list
#
angular.module('iwishua')
.controller 'OptionsController',
  ($scope, $window, $anchorScroll, $location, $route, $localStorage, $timeout, logger, config) ->

    new class OptionsController

      logThreshold: null


      constructor: ->
        logger.log "OptionsController initialized"

        @logThreshold =
          ERROR:    (config.logThreshold & 1) is 1
          INFO:     (config.logThreshold & 2) is 2
          WARNING:  (config.logThreshold & 4) is 4
          SUCCESS:  (config.logThreshold & 8) is 8
          LOG:      (config.logThreshold & 16) is 16


      #
      # Reset
      #
      reset: =>
        $localStorage.$reset()
        $timeout ->
          # reboot to reset memory
          $window.location.replace($window.location.origin+$window.location.pathname)
        ,300

      #
      # Clear Cache
      #
      clearCache: =>
        $localStorage.$reset(config: config)
        $timeout ->
          # reboot to reset memory
          $window.location.replace($window.location.origin+$window.location.pathname)
        ,300

      #
      # First record
      #
      first: =>
        $localStorage.skip = 0
        $location.path('/')


      #
      # Update config with new log Threshold values
      #
      update: =>
        config.logThreshold |= 1  if @logThreshold.ERROR
        config.logThreshold |= 2  if @logThreshold.INFO
        config.logThreshold |= 4  if @logThreshold.WARNING
        config.logThreshold |= 8  if @logThreshold.SUCCESS
        config.logThreshold |= 16 if @logThreshold.LOG

        config.logThreshold &= ~1  unless @logThreshold.ERROR
        config.logThreshold &= ~2  unless @logThreshold.INFO
        config.logThreshold &= ~4  unless @logThreshold.WARNING
        config.logThreshold &= ~8  unless @logThreshold.SUCCESS
        config.logThreshold &= ~16 unless @logThreshold.LOG

