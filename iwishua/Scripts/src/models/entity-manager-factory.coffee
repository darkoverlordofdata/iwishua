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
angular.module('iwishua.models')
.factory 'entityManagerFactory',
  ['$q', '$log', 'breeze', 'config', 'model', 'unit-of-work', 'logger',
  ($q, $log, breeze, config, model, unitOfWork, logger) ->

    new class EntityManager

      _manager              : null
      _dataService:
        hasServerMetadata   : false # config.hasServerMetadata
        serviceName         : config.serviceName

      constructor: ->
        logger.log "EntityManager initialized"

        dataService = new breeze.DataService(@_dataService)
        @_manager = new breeze.EntityManager(dataService: dataService)
        unitOfWork.initialize @_manager
        model.setModel @_manager


      getEntityManager: () ->
        $q.when(@_manager)

  ]