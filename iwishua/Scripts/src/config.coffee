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
# Iwishua Configuration values
#
#
angular.module('iwishua')
.factory 'config',
  ($q, $localStorage, $log, breeze) ->

    new class Config

      @LAYOUT_LIST  = 0
      @LAYOUT_TILED = 1
      
      appUrl = 'https://iwishuadata.azure-mobile.net/'

      #|
      #|--------------------------------------------------------------------------
      #| Id
      #|--------------------------------------------------------------------------
      #|
      #| Hash of the logged in users facebook id
      #| If not a logged in user, then the empty string
      #|
      #|
      id: ''
      #|
      #|--------------------------------------------------------------------------
      #| Crypto
      #|--------------------------------------------------------------------------
      #|
      #| Algorithm used to hash user id
      #|
      #|
      crypto: 'SHA1'
      #|
      #|--------------------------------------------------------------------------
      #| Service Name
      #|--------------------------------------------------------------------------
      #|
      #| Uri of the BreezeJS data source
      #|
      #|
      serviceName: appUrl + 'tables/'        
      #|
      #|--------------------------------------------------------------------------
      #| Interface Name
      #|--------------------------------------------------------------------------
      #|
      #| BreezeJS connection interface
      #|
      #|
      interfaceName: 'dataService'             
      #|
      #|--------------------------------------------------------------------------
      #| Adapter Name
      #|--------------------------------------------------------------------------
      #|
      #| Name of the BreezeJS data adapter
      #|
      #|
      adapterName: 'azure-mobile-services'   
      #|
      #|--------------------------------------------------------------------------
      #| Page Size
      #|--------------------------------------------------------------------------
      #|
      #| Number of items to show per page
      #|
      #|
      pageSize: 5                         
      chunkSize: 10                       
      #|
      #|--------------------------------------------------------------------------
      #| Scrub
      #|--------------------------------------------------------------------------
      #|
      #| Clean up the description (true/false)
      #|
      #|
      scrub: true                      
      #|
      #|--------------------------------------------------------------------------
      #| Layout
      #|--------------------------------------------------------------------------
      #|
      #| Page layout style
      #|
      #| @LAYOUT_LIST  = 0
      #| @LAYOUT_TILED = 1
      #|
      layout: @LAYOUT_TILED
      tiles: [
        ['vert', 'horz', 'horz', 'vert', 'vert']
        ['vert', 'horz', 'vert', 'vert', 'horz']
        ['vert', 'vert', 'horz', 'vert', 'vert']
        ['vert', 'vert', 'vert', 'vert', 'horz']
        ['vert', 'vert', 'vert', 'vert', 'vert']
      ]
      #|
      #|--------------------------------------------------------------------------
      #| Layout Names
      #|--------------------------------------------------------------------------
      #|
      #| List of possible layout styles
      #|
      #|
      layoutNames: ['LAYOUT_LIST', 'LAYOUT_TILED']
      #|
      #|--------------------------------------------------------------------------
      #| Log Threshold
      #|--------------------------------------------------------------------------
      #|
      #| Flags determine which log types are displayed
      #|
      #|
      logThreshold: 1 | 4 | 8 | 16  #   Defaults
      #|                            #   --------
      #| Logger.ERROR        : 1    #   ON
      #| Logger.INFO         : 2    #   OFF
      #| Logger.WARNING      : 4    #   ON
      #| Logger.SUCCESS      : 8    #   ON
      #| Logger.LOG          : 16   #   ON

      #|
      #|--------------------------------------------------------------------------
      #| Theme
      #|--------------------------------------------------------------------------
      #|
      #| Name of the UI Theme
      #|
      #|
      theme: 'slate'
      #|
      #|--------------------------------------------------------------------------
      #| Theme Template
      #|--------------------------------------------------------------------------
      #|
      #| Template for creating the theme url
      #|
      #|
      themeTemplate: "//cdnjs.cloudflare.com/ajax/libs/bootswatch/3.2.0+1/__theme__/bootstrap.min.css"
      #|
      #|--------------------------------------------------------------------------
      #| Theme Url
      #|--------------------------------------------------------------------------
      #|
      #| Url of the theme
      #|
      #|
      themeUrl: "//cdnjs.cloudflare.com/ajax/libs/bootswatch/3.2.0+1/slate/bootstrap.min.css"
      #|
      #|--------------------------------------------------------------------------
      #| Theme Names
      #|--------------------------------------------------------------------------
      #|
      #| valid bootswatch theme names
      #|
      #|
      themeNames: [ 
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
        
      #|
      #|--------------------------------------------------------------------------
      #| Toastr
      #|--------------------------------------------------------------------------
      #|
      #| Toastr options
      #|
      #|
      toastr:
        timeOut: 2000   # 2 second toast timeout
        positionClass: 'toast-bottom-right'
        


      constructor: ->

        $log.log "Config initialized"

        # initialize the BreezeJS adapter
        adapter = breeze.config.initializeAdapterInstance(@interfaceName, @adapterName, true)
        adapter.mobileServicesInfo = url: appUrl
        adapter.Q = $q

        # initialize config values
        @login ''

      login: (id) =>
        if id is '' then @id = id else @id = String(CryptoJS[@crypto](id))
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
      # setLayout - Set the layout style
      #
      # @param  theme
      #
      setLayout: (layout) =>
        @layout = layout
        
        
        
      #
      # Sync - sync the config object with web storage
      #
      # @param  config
      #
      sync = (config) ->
        k = 'config'+config.id
        if $localStorage[k]?
          for key, value of $localStorage[k]
            config[key] = value
          for key, value of config
            $localStorage[k][key] = value unless $localStorage[k][key]?
            
        else
          $localStorage[k] = {}
          for key, value of config
            $localStorage[k][key] = value




