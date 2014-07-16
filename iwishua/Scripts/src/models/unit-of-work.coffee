#+--------------------------------------------------------------------+
#| unit-of-work.coffee
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
# Unit of Work service stores changed entities in browser local storage.
# This simple version works for one EntityManager only and automatically captures changes
# to that manager in a throttled way.
#
angular.module('iwishua.models')
.factory 'unit-of-work',
  ['$log','$rootScope','$timeout','$window', 'breeze', 'logger', 'config',
  ($log, $rootScope, $timeout, $window, breeze, logger, config) ->

    new class UnitOfWorkService

      _db                 : null
      _delay              : 3000 # debounce for 3 seconds
      _disabled           : undefined
      _entityChangedToken : undefined
      _eventName          : "UOW"
      _isRestoring        : false
      _manager            : undefined
      _propChangeAction   : null
      _priorTimeout       : undefined
      _storeTypes         : null
      _stopped            : false
      _storeCount         : undefined

      eventName: => @_eventName
      isEnabled: => not @_disabled
      isStopped: => not not @_stopped
      storeCount: => @_storeCount

      constructor: ->
        logger.log "Unit Of Work Service initialized"

        @_db = $window.localStorage
        @_propChangeAction = breeze.PropertyChange
        @_storeTypes = []

      clear: () =>
        if @_disabled then return
        try
          @_db.removeItem config.storeName
          @_storeCount = 0
          @sendMessage "Cleared Unit Of Work store"
          return
        catch e
          @_storeCount = undefined #/* err doesn't matter */
          return

      entityChanged: (changeArgs) =>
        if @_isRestoring or @_stopped then return # ignore Unit Of Work service's own changes.
        action = changeArgs.action

        if action is @_propChangeAction
          $timeout.cancel @_priorTimeout
          @_priorTimeout = $timeout(@store, @_delay, true)
        return


      initialize: (entityManager) =>
        if typeof @_disabled is 'boolean'
          throw new Error("Unit Of Work already enabled, can't enable twice.")

        if !@_db
          @_disabled = true
          @_storeCount = 0
          $log.error "Browser does not support local storage Unit Of Work disabled."
        else
          @_manager = entityManager
          @listenForChanges()
          @_disabled = false
          @sendMessage "Unit Of Work enabled"
        return

          
      listenForChanges: () =>
        if @_entityChangedToken then return # already listening
        @_entityChangedToken = @_manager.entityChanged.subscribe(@entityChanged)
        @_disabled = false
        return

      restore: () =>
        @imports = []
        @_storeCount = 0
        if @_disabled then return @imports
        # imports changes from store
        @_isRestoring = true
        try
          @changes = @_db.getItem(config.storeName)
          if @changes
            # should confirm that metadata and app version
            # are still valid but this is a demo
            @imports = @_manager.importEntities(@changes).entities
            @_storeCount = @imports.length
            @sendMessage "Restored #{@_storeCount} change(s) from store"
          else
            @sendMessage "Restore found no stored changes"

        catch error #/* log but don't crash */
          $log.error "Unit Of Work restore failed"
          $log.error error
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
          @sendMessage "Unit Of Work re-enabled"
        return

          
      sendMessage: (message) =>
        $log.log "Unit Of Work event: #{message}"
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
          @_db.setItem config.storeName, @exported
        else if @_storeCount isnt 0
          @sendMessage "No changes clearing store"
          @_db.removeItem config.storeName
          @_storeCount = 0
        return

      stop: () =>
        if not @_disabled and not @_stopped
          @_stopped = true
          @stopListeningForChanges()
          @sendMessage "Unit Of Work has been stopped"
        return

      stopListeningForChanges: () =>
        @_manager.entityChanged.unsubscribe @_entityChangedToken
        @_entityChangedToken = undefined
        return

  ]
