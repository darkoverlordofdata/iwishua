#+--------------------------------------------------------------------+
#| entity-cache.coffee
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
# EntityCache service listens for changes and stores the changed entities in browser local storage.
#
# We're mainly interested in Deletes, but changes to descriptions also get tracked
#
angular.module('iwishua')
.factory 'cache',
  ($rootScope, $timeout, $localStorage, breeze, logger, config) ->

    new class EntityCache

      _tableName          : 'iwishuaproducts'
      _storeName          : 'products-cache'
      _delay              : 3000          # debounce for 3 seconds
      _disabled           : undefined     # service disabled
      _entityChangedToken : undefined     # event subscription
      _eventName          : "entity-cache"
      _isRestoring        : false
      _manager            : undefined
      _priorTimeout       : undefined
      _storeTypes         : null
      _stopped            : false
      _storeCount         : undefined

      eventName: => @_eventName
      isEnabled: => not @_disabled
      isStopped: => not not @_stopped
      storeCount: => @_storeCount

      constructor: ->
        logger.log "Entity Cache Service initialized"

        @_storeTypes = []

      clear: () =>
        if @_disabled then return
        try
          delete $localStorage[@_storeName+config.id]
          @_storeCount = 0
          @sendMessage "Cleared Entity Cache store"
          return
        catch e
          @_storeCount = undefined #/* err doesn't matter */
          return

      entityChanged: (changeArgs) =>
        if @_isRestoring or @_stopped then return # ignore Entity Cache service's own changes.

        if changeArgs.action is breeze.PropertyChange
          $timeout.cancel @_priorTimeout
          @_priorTimeout = $timeout(@store, @_delay, true)
        return


      initialize: (entityManager) =>
        if typeof @_disabled is 'boolean'
          throw new Error("Entity Cache already enabled, can't enable twice.")

        @_manager = entityManager
        @listenForChanges()
        @_disabled = false
        @sendMessage "Entity Cache enabled"
        return
          
      listenForChanges: () =>
        if @_entityChangedToken then return # already listening
        @_entityChangedToken = @_manager.entityChanged.subscribe(@entityChanged)
        @_disabled = false
        return

      importEntities: () =>
        if $localStorage[@_storeName+config.id]?
          @imports = @_manager.importEntities($localStorage[@_storeName+config.id]).entities
          @_storeCount = @imports.length
          @sendMessage "Imported #{@_storeCount} records(s) from store"
          @imports
        else false

      exportEntities: (data) =>
        @exports = @_manager.exportEntities(data)
        @sendMessage "Exported #{@_storeCount} records(s) to store"
        $localStorage[@_storeName+config.id] = @exports

      restore: () =>
        @imports = []
        @_storeCount = 0
        if @_disabled then return @imports
        # imports changes from store
        @_isRestoring = true
        try
          @changes = $localStorage[@_storeName+config.id]
          if @changes
            # should confirm that metadata and app version
            # are still valid but this is a demo
            @imports = @_manager.importEntities(@changes).entities
            @_storeCount = @imports.length
            @sendMessage "Restored #{@_storeCount} change(s) from store"
          else
            @sendMessage "Restore found no stored changes"

        catch error #/* log but don't crash */
          logger.error "Entity Cache restore failed"
          logger.error error
        finally
          @_isRestoring = false

        @imports
      
      start: () =>
        @resume()

      resume: () =>
        if not @_disabled and @_stopped
          @_stopped = false
          @store()
          @listenForChanges()
          @sendMessage "Entity Cache re-enabled"
        return

          
      sendMessage: (message) =>
        logger.log "Entity Cache event: #{message}"
        $rootScope.$broadcast @_eventName, message
        return

      store: () =>
        if @_manager.hasChanges()
          # export changes w/o metadata
          # Get only these entity types
          # (which we only have 1 in this app)
          @changes = @_manager.getChanges()
          @_storeCount = @changes.length
          @sendMessage "Storing #{@_storeCount} change(s)"
          @exported = @_manager.exportEntities(@changes, false)
          $localStorage[@_storeName+config.id] = @exported
        else if @_storeCount isnt 0
          @sendMessage "No changes clearing store"
          delete $localStorage[@_storeName+config.id]
          @_storeCount = 0
        return

      stop: () =>
        if not @_disabled and not @_stopped
          @_stopped = true
          @stopListeningForChanges()
          @sendMessage "Entity Cache has been stopped"
        return

      stopListeningForChanges: () =>
        @_manager.entityChanged.unsubscribe @_entityChangedToken
        @_entityChangedToken = undefined
        return

      getDeleted: () =>
        entityType = @_manager.metadataStore.getEntityType(@_tableName)
        @_manager.getEntities(entityType, breeze.EntityState.Deleted)


