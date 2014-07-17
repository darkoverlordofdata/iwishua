#+--------------------------------------------------------------------+
#| products/datacontext.coffee
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
# datacontext service encapsulates data access and model definition
#
angular.module('iwishua.models')
.factory 'datacontext',
  ['$log','$q', 'breeze', 'entityManagerFactory', 'unit-of-work', 'logger', 'config',
  ($log, $q, breeze, entityManagerFactory, unitOfWork, logger, config) ->

    new class ProductsDataContext

      _manager            : null
      _productsType       : null

      counts              : null

      constructor: ->
        logger.log "ProductsDataContext initialized"

        @counts = {}

      updateCounts: () =>
        @counts.all = 0
        @counts.Added = 0
        @counts.Deleted = 0
        @counts.Modified = 0
        @counts.Unchanged = 0
        @_manager.getEntities().forEach (entity) =>
          state = entity.entityAspect.entityState.name
          @counts[state] += 1
          @counts.all += 1
          return
        return

      entityCountsChanged: (changeArgs) =>
        action = changeArgs.entityAction
        if action isnt breeze.EntityAction.PropertyChange
          @updateCounts()
        return


      ready: () =>
        entityManagerFactory.getEntityManager()
        .then (em) =>
          @_manager = em
          @_manager.entityChanged.subscribe @entityCountsChanged
          @_productsType = @_manager.metadataStore.getEntityType('iwishuaproducts')
          @updateCounts()
          return


      addProduct: (initialValues) =>
        @_manager.createEntity(@_productsType, initialValues)

      deleteProduct: (product) =>
        aspect = product.entityAspect
        console.log aspect
        if aspect.entityState isnt breeze.EntityState.Detached
          console.log 'DEL'
          aspect.setDeleted()
        return

      # Get next Products from the server and cache combined
      getNextProducts: (skip) =>
        # Create the query
        query = breeze.EntityQuery
        .from('iwishuaproducts')
        .skip(parseInt(skip, 10))
        .take(parseInt(config.pageSize, 10))
        .where('isPublished', 'eq', true)
#        .inlineCount(true)

        # Execute the query
        @_manager.executeQuery(query)
        .then (data) =>
          # Interested in what server has then we are done.
          fetched = data.results
          logger.log "breeze query succeeded. skiped/fetched: #{skip}/#{fetched.length}"

          # Blended results.
          # This gets me all local changes and what the server game me.
          return @_manager.getEntities(@_productsType)

        # Normally would re-query the cache to combine cached and fetched
        # but need the deleted entities too for this UI.
        # For demo, we returned every cached Todo
        # Warning: the cache will accumulate entities that
        # have been deleted by other users until it is entirely rebuilt via 'refresh'
        .catch (error) =>
          error.message = prettifyErrorMessage(error.message)
          status = if error.status then error.status + ' - ' else ''
          err = status + (if error.message then error.message else 'Unknown error check console.log.')
          err += '\nIs the server running?'
          return $q.reject(err) # so downstream listener gets it.

      hasChanges: () =>
        @_manager.hasChanges()

      loadProducts: (skip = 0) =>
        unitOfWork.restore()
        @getNextProducts(skip)

      # Clear everything local and reload from server.
      reset: () =>
        unitOfWork.stop()
        unitOfWork.clear()
        @_manager.clear()
        @getNextProducts().finally ->
          unitOfWork.resume()


      sync: () =>
        @_manager.saveChanges()
        .then () =>
          $log.log "breeze save succeeded"
          unitOfWork.clear()
          return @getNextProducts()

        .catch (error) =>
          msg = "Save failed: " +
            breeze.saveErrorMessageService.getErrorMessage(error)
          error.message = msg
          throw error # for downstream callers to see

      prettifyErrorMessage = (message) ->
        # When message returns the Product guid id,
        # try to replace with the Product title which displays better
        re=/with id '([1234567890abcdef\-]*)'/i
        match = message and message.match(re)
        if match
          id = match[1]
          product = id and manager.getEntityByKey('iwishuaproducts',id)
          if product
            message = message.replace(re,'named "'+product.productTitle+'"')+" [key: "+id+"]"
        return message


  ]