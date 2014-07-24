#+--------------------------------------------------------------------+
#| entity-manager-factory.coffee
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
# entityManagerFactory creates the model and delivers a new EntityManager
#
angular.module('iwishua')
.factory 'entityManagerFactory',
  ($q, breeze, config, model, cache, logger) ->

    new class EntityManager

      _manager              : null
      _dataService:
        hasServerMetadata   : false
        serviceName         : config.serviceName

      constructor: ->
        logger.log "EntityManager initialized"

        dataService = new breeze.DataService(@_dataService)
        @_manager = new breeze.EntityManager(dataService: dataService)
        cache.initialize @_manager
        model.setModel @_manager


      getEntityManager: () ->
        $q.when(@_manager)
