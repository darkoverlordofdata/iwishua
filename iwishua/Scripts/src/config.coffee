#+--------------------------------------------------------------------+
#| config.coffee
#+--------------------------------------------------------------------+
#| Copyright fivetwofivetwo, LLC (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of iwishua
#|
#| This file is subject to the terms and conditions defined in
#| file 'license.md', which is part of this source code package.
#|
#+--------------------------------------------------------------------+
#
# Configuration values for the iwishua application
#
angular.module('iwishua')
.factory 'config',
  ($q, $localStorage, $log, breeze) ->

    new class Config

      appUrl = 'https://iwishuadata.azure-mobile.net/'

      appTitle            : 'iwishua'
      theme               : "//netdna.bootstrapcdn.com/bootswatch/3.1.1/slate/bootstrap.min.css"
      serviceType         : 'zumo'
      serviceName         : appUrl + 'tables/'
      serverTitle         : 'Microsoft Azure'
      pageSize            : 5
      chunkSize           : 10
      interfaceName       : 'dataService'
      adapterName         : 'azure-mobile-services'
      logThreshold        : 1 | 4 | 8 | 16            #   Defaults
                                                      #   --------
                          #Logger.ERROR        : 1    #   ON
                          #Logger.INFO         : 2    #   OFF
                          #Logger.WARNING      : 4    #   ON
                          #Logger.SUCCESS      : 8    #   ON
                          #Logger.LOG          : 16   #   ON

      theme               : 'slate'
      themeTemplate       : "//cdnjs.cloudflare.com/ajax/libs/bootswatch/3.2.0+1/__theme__/bootstrap.min.css"
      themeUrl            : "//cdnjs.cloudflare.com/ajax/libs/bootswatch/3.2.0+1/slate/bootstrap.min.css"
      themeNames: [ # valid bootswatch theme names
        'amelia'
        'cerulean'
        'cosmo'
        'cyborg'
        'darkly'
        'flatly'
        'journal'
        'lumen'
        'readable'
        'simplex'
        'slate'       # Default
        'spacelab'
        'superhero'
        'united'
        'yeti'
        ]


      constructor: ->

        $log.log "Config initialized"

        adapter = breeze.config.initializeAdapterInstance(@interfaceName, @adapterName, true)
        adapter.mobileServicesInfo = url: appUrl
        adapter.Q = $q

        sync @
        @chunkSize = @pageSize * 2
        @setTheme @theme


      #
      # setTheme - Set the gui theme
      #
      # @param  theme
      #
      setTheme: (theme) =>
        @theme = theme
        @themeUrl = @themeTemplate.replace('__theme__', @theme)
        $('#theme').attr 'href', @themeUrl
        return

      #
      # Sync - sync the config object with web storage
      #
      # @param  config
      #
      sync = (config) ->
        if $localStorage.config?
          for key, value of $localStorage.config
            config[key] = value
        else
          $localStorage.config = {}
          for key, value of config
            $localStorage.config[key] = value




