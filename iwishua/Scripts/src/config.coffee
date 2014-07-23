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
# configuration values for the iwishua application
#
angular.module('iwishua')
.factory 'config',
  ['$q','breeze',
  ($q, breeze) ->

    new class Config

      appUrl = 'https://iwishuadata.azure-mobile.net/'

      appTitle            : 'iwishua'
      serviceType         : 'zumo'
      serviceName         : appUrl + 'tables/'
      serverTitle         : 'Microsoft Azure'
      pageSize            : 5
      chunkSize           : 10
      storeName           : 'iwishua'
      interfaceName       : 'dataService'
      adapterName         : 'azure-mobile-services'
      logThreshold        : 1 | 4 | 8 | 16
                          #Logger.ERROR        : 1                   #   toastr+log errors
                          #Logger.INFO         : 2                   #   toastr+log info messages
                          #Logger.WARNING      : 4                   #   toastr+log warnings
                          #Logger.SUCCESS      : 8                   #   toastr+log success
                          #Logger.LOG          : 16                  #   console log

      constructor: ->

        adapter = breeze.config.initializeAdapterInstance(@interfaceName, @adapterName, true)
        adapter.mobileServicesInfo = url: appUrl
        adapter.Q = $q

        # todo: Recalculate @pageSize for device form factor

        @chunkSize = @pageSize * 2

  ]

