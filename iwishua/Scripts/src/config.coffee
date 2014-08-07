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

      @LAYOUT_LIST  = 0
      @LAYOUT_TILED = 1
      
      appUrl = 'https://iwishuadata.azure-mobile.net/'

      appTitle            : 'iwishua'                 #
      serviceType         : 'zumo'                    #
      serviceName         : appUrl + 'tables/'        #
      serverTitle         : 'Microsoft Azure'         #
      pageSize            : 5                         # number of items per page
      chunkSize           : 10                        #  
      scrub               : true                      # scrub item description
      layout              : @LAYOUT_TILED             # item layout style
      layoutNames         : ['LAYOUT_LIST', 'LAYOUT_ TILED']
      interfaceName       : 'dataService'             #
      adapterName         : 'azure-mobile-services'   #
      logThreshold        : 1 | 4 | 8 | 16            #   Defaults
                                                      #   --------
                          #Logger.ERROR        : 1    #   ON
                          #Logger.INFO         : 2    #   OFF
                          #Logger.WARNING      : 4    #   ON
                          #Logger.SUCCESS      : 8    #   ON
                          #Logger.LOG          : 16   #   ON

#      theme               : "//netdna.bootstrapcdn.com/bootswatch/3.1.1/slate/bootstrap.min.css"
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
        
      toastr:
        timeOut           : 2000 # 2 second toast timeout
        positionClass     : 'toast-bottom-right'
        


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

      setLayout: (layout) =>
        @layout = layout
        
      #
      # Sync - sync the config object with web storage
      #
      # @param  config
      #
      sync = (config) ->
        if $localStorage.config?
          for key, value of $localStorage.config
            config[key] = value
          for key, value of config
            $localStorage.config[key] = value unless $localStorage.config[key]?
            
        else
          $localStorage.config = {}
          for key, value of config
            $localStorage.config[key] = value




