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
  ['$scope', '$localStorage', '$modal', 'matchmedia', 'logger', 'datacontext', 'shuffle', 'config', 'cache', 'usSpinnerService',
  ($scope, $localStorage, $modal, matchmedia, logger, datacontext, shuffle, config, cache, usSpinnerService) ->

    new class WishController

      patterns = [
        ['vert', 'horz', 'horz', 'vert', 'vert']
        ['vert', 'horz', 'vert', 'vert', 'horz']
        ['vert', 'vert', 'horz', 'vert', 'vert']
        ['vert', 'vert', 'vert', 'vert', 'horz']
        ['vert', 'vert', 'vert', 'vert', 'vert']
      ]

      perPage = config.pageSize
      skip = Math.max(0, parseInt($localStorage.skip ? 0, 10))

      isBusy: true

      constructor: ->

        logger.log "WishController initialized"

        unphone = matchmedia.onPhone (mediaQueryList) =>
          @isPhone = mediaQueryList.matches


        if (data = cache.importEntities())
          datacontext.ready().then(() => @display(data)).catch(@handleError)
        else
          datacontext.ready().then(@onReady).catch(@handleError)


        #
        # Destructor - clean up the media event sub
        #
        $scope.$on '$destroy', -> unphone()



      #
      # navLeft - Navigate Left
      #
      # @parm $event
      #
      navLeft: ($event) ->
        skip += perPage
        $localStorage.skip = skip
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
        $localStorage.skip = skip
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