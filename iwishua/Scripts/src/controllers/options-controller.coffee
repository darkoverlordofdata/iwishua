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

    Logger = Object.getClass(logger)

    new class OptionsController

      logThreshold: null
      themes: null
      theme: ''

      constructor: ->
        logger.log "OptionsController initialized"

        @themes = config.themeNames
        @theme = config.theme


        @logThreshold =
          ERROR:    (config.logThreshold & Logger.ERROR)    is Logger.ERROR
          INFO:     (config.logThreshold & Logger.INFO)     is Logger.INFO
          WARNING:  (config.logThreshold & Logger.WARNING)  is Logger.WARNING
          SUCCESS:  (config.logThreshold & Logger.SUCCESS)  is Logger.SUCCESS
          LOG:      (config.logThreshold & Logger.LOG)      is Logger.LOG


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
        return

      cancel: =>
        $location.path('/')
        return

      #
      # Update config with new log Threshold values
      #
      update: =>

        if @logThreshold.ERROR
          config.logThreshold |= Logger.ERROR
        else
          config.logThreshold &= ~Logger.ERROR

        if @logThreshold.INFO
          config.logThreshold |= Logger.INFO
        else
          config.logThreshold &= ~Logger.INFO

        if @logThreshold.WARNING
          config.logThreshold |= Logger.WARNING
        else
          config.logThreshold &= ~Logger.WARNING

        if @logThreshold.SUCCESS
          config.logThreshold |= Logger.SUCCESS
        else
          config.logThreshold &= ~Logger.SUCCESS

        if @logThreshold.LOG
          config.logThreshold |= Logger.LOG
        else
          config.logThreshold &= ~Logger.LOG

        $localStorage.config = config
        $location.path('/')
        return


