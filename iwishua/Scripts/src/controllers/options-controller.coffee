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
  ($scope, $window, $location, $route, $localStorage, $timeout, logger, config) ->

    new class OptionsController

      logThreshold: null
      themes: null
      theme: ''

      constructor: ->
        logger.log "OptionsController initialized"

        @themes = config.themeNames
        @theme = config.theme

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
        bootbox.confirm 'Reset (Y/N)?', (isYes) =>

          if isYes
            $localStorage.$reset()
            $timeout ->
              # reboot to reset memory
              $window.location.replace($window.location.origin+$window.location.pathname)
            ,300
        return

      #
      # Clear Cache
      #
      clearCache: =>
        bootbox.confirm 'Clear (Y/N)?', (isYes) =>

          if isYes
            $localStorage.$reset(config: config)
            $timeout ->
              # reboot to reset memory
              $window.location.replace($window.location.origin+$window.location.pathname)
            ,300
        return

      #
      # First record
      #
      first: =>
        $localStorage.skip = 0
        $location.path('/')
        return


      saveTheme: =>
        config.setTheme @theme
        $localStorage.config = config
        $location.path('/')
        return

      cancel: =>
        $location.path('/')
        return

      #
      # Update config with new log Threshold values
      #
      update: =>

        if @logThreshold.ERROR
          config.logThreshold |= 1
        else config.logThreshold &= ~1

        if @logThreshold.INFO
          config.logThreshold |= 2
        else config.logThreshold &= ~2

        if @logThreshold.WARNING
          config.logThreshold |= 4
        else config.logThreshold &= ~4

        if @logThreshold.SUCCESS
          config.logThreshold |= 8
        else config.logThreshold &= ~8

        if @logThreshold.LOG
          config.logThreshold |= 16
        else config.logThreshold &= ~16

        $localStorage.config = config
        $location.path('/')
        return


