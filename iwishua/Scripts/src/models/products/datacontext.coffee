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
angular.module('iwishua')
.factory 'datacontext',
  ($q, $http, breeze, entityManagerFactory, cache, logger, config) ->

    new class ProductsDataContext

      _tableName          : 'iwishuaproducts'
      _manager            : null
      _productsType       : null

      counts              : null
      maxCount            : 0

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
        .then (entityManager) =>
          @_manager = entityManager
          @_manager.entityChanged.subscribe @entityCountsChanged
          @_productsType = @_manager.metadataStore.getEntityType(@_tableName)
          @updateCounts()
          #
          # breezejs inlineCount is an undefined value
          # as a workaround, use OData api
          #
          $http(method: 'GET', url: "#{config.serviceName}/#{@_tableName}?$top=0&$inlinecount=allpages&")
          .success (data) =>
            @maxCount = data.count
          return


      addProduct: (initialValues) =>
        @_manager.createEntity(@_productsType, initialValues)

      deleteProduct: (product) =>
        aspect = product.entityAspect
        if aspect.entityState isnt breeze.EntityState.Detached
          aspect.setDeleted()
        return

      unDeleteProduct: (product) =>
        aspect = product.entityAspect
        if aspect.entityState isnt breeze.EntityState.Detached
          aspect.rejectChanges()
        return

      # Get next Products from the server and cache combined
      getNextProducts: (skip) =>

      # Create the query
        query = breeze.EntityQuery
        .from(@_tableName)
        .skip(parseInt(skip, 10))
        .take(parseInt(config.pageSize, 10))
        .where('isPublished', 'eq', true)
        #.inlineCount() - sets an undefined value

        # if the query is satisfied from cache, then query from cache
        if @_manager.executeQueryLocally(query).length is config.pageSize
          query = query.using(breeze.FetchStrategy.FromLocalCache)

        # Execute the query
        @_manager.executeQuery(query)
        .then (data) =>
          # Interested in what server has then we are done.
          fetched = data.results
          logger.log "breeze query succeeded. skiped/fetched: #{skip}/#{fetched.length}"

          # Blended results.
          # This returns all local changes merged with server results
          return @_manager.getEntities(@_productsType)

        # Normally would re-query the cache to combine cached and fetched
        # but need the deleted entities too for this UI.
        # For demo, we returned every cached Todo
        # Warning: the cache will accumulate entities that
        # have been deleted by other users until it is entirely rebuilt via 'refresh'
        .catch (error) =>
          error.message = @prettifyErrorMessage(error.message)
          status = if error.status then error.status + ' - ' else ''
          err = status + (if error.message then error.message else 'Unknown error check console.log.')
          err += '\nIs the server running?'
          return $q.reject(err) # so downstream listener gets it.

      hasChanges: () =>
        @_manager.hasChanges()

      loadProducts: (skip = 0) =>
        cache.restore()
        @getNextProducts(skip)

      # Clear everything local and reload from server.
      reset: () =>
        cache.stop()
        cache.clear()
        @_manager.clear()
        @getNextProducts().finally ->
          cache.resume()


      sync: () =>
        @_manager.saveChanges()
        .then () =>
          logger.log "breeze save succeeded"
          cache.clear()
          return @getNextProducts()

        .catch (error) =>
          msg = "Save failed: " +
            breeze.saveErrorMessageService.getErrorMessage(error)
          error.message = msg
          throw error # for downstream callers to see

      prettifyErrorMessage: (message) =>
        # When message returns the Product guid id,
        # try to replace with the Product title which displays better
        re=/with id '([1234567890abcdef\-]*)'/i
        match = message and message.match(re)
        if match
          id = match[1]
          product = id and manager.getEntityByKey(@_tableName,id)
          if product
            message = message.replace(re,'named "'+product.productTitle+'"')+" [key: "+id+"]"
        return message


