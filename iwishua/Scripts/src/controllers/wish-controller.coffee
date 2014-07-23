#+--------------------------------------------------------------------+
#| WishController.coffee
#+--------------------------------------------------------------------+
#| Copyright fivetwofivetwo, LLC (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of iwishua
#|
#| This file is subject to the terms and conditions defined in
#| file 'license.md', which is part of this source code package.
#|
#| Yu Mo Gui Gwai Fai Di Zao
#|
#+--------------------------------------------------------------------+
#
# Show ths wish list
#
angular.module('iwishua')
.controller 'WishController',
  ['$scope', '$cookies', '$modal', 'logger', 'datacontext', 'shuffle', 'config', 'entity-cache', 'usSpinnerService',
  ($scope, $cookies, $modal, logger, datacontext, shuffle, config, entityCache, usSpinnerService) ->

    new class WishController

      patterns = [
        ['vert', 'horz', 'horz', 'vert', 'vert']
        ['vert', 'horz', 'vert', 'vert', 'horz']
        ['vert', 'vert', 'horz', 'vert', 'vert']
        ['vert', 'vert', 'vert', 'vert', 'horz']
        ['vert', 'vert', 'vert', 'vert', 'vert']
      ]

      perPage = config.pageSize
      skip = Math.max(0, parseInt($cookies.skip ? 0, 10))
      isBusy              : true

      constructor: ->

        logger.log "WishController initialized"

        data = entityCache.importEntities()
        if data
          datacontext.ready()
          .then () =>
            @display data

        else
          #
          # Load the next products list
          #
          datacontext.ready().then(@onReady).catch(@handleError)

      #
      # navLeft - Navigate Left
      #
      # @parm $event
      #
      navLeft: ($event) ->
        skip += perPage
        $cookies.skip = skip
        @isBusy = true
        usSpinnerService.spin 'spinner-wish'
        datacontext.loadProducts(skip).then(@display, @handleError)

      #
      # navRight - Navigate Right
      #
      # @parm $event
      #
      navRight: ($event) ->
        skip -= perPage
        skip = Math.max(0, skip)
        $cookies.skip = skip
        @isBusy = true
        usSpinnerService.spin 'spinner-wish'
        datacontext.loadProducts(skip).then(@display, @handleError)

      onReady: () =>
        @isBusy = true
        datacontext.loadProducts(skip).then(@display, @handleError)

      handleError: (error) =>
        @isBusy = false
        err = if typeof error is 'string' then error else error.message
        logger.warning err


      filter: (product) =>
        state = product.entityAspect.entityState
        !state.isDetached() and !state.isDeleted()

      #
      # details - Modal popup with product details
      #
      # @parm id
      #
      details: (id) ->

        for product in @products
          if id is product.id
            $modal.open
              size          : 'sm'
              templateUrl   : 'Content/partials/wish-details.html'
              controller    : 'DetailController'
              resolve:
                productData: () ->
                  return product

            return
      #
      # display
      #
      # @parm data
      #
      display: (data) =>
        #entityCache.exportEntities 'home', data

        #
        # Parse the data for display
        #
        @isBusy = false

        if skip+perPage > data.length
          @products = shuffle(data.slice(-perPage))
        else
          @products = shuffle(data.slice(skip, skip+perPage))

        for attrs in @products

          title = attrs.productTitle
          # strip off wrapping quotes
          if title[0...1] is '"' then title = title[1...-1]
          words = title.replace(/[-,.©®™]/g, ' ').replace(/([a-z])([A-Z])/g, "$1 $2").split(/\s+/)
          title = words.join(' ')
          attrs.productTitle = title
          name = ''
          until name.length > 20 or words.length is 0
            name = words.pop() + ' ' + name.substr(0, 1).toUpperCase() + name.substr(1)
          attrs.productName = name


        c = 0
        className = patterns[Math.floor((Math.random() * patterns.length))]
        logger.info 'Pattern: ' + (s[0] for s in className)
        for attrs in @products

          attrs.className = className[c++]
          if attrs.className is 'horz'
            if (Math.floor(Math.random() * new Date().getTime())) & 1
              attrs.aligned = 'alignleft'
            else
              attrs.aligned = 'alignright'

        #
        # Stop the spinner
        #
        usSpinnerService.stop 'spinner-wish'



  ]