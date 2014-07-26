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
  ($scope, $localStorage, $modal, matchmedia, logger, datacontext, shuffle, config, cache, usSpinnerService) ->

    new class WishController

      patterns = [
        ['vert', 'horz', 'horz', 'vert', 'vert']
        ['vert', 'horz', 'vert', 'vert', 'horz']
        ['vert', 'vert', 'horz', 'vert', 'vert']
        ['vert', 'vert', 'vert', 'vert', 'horz']
        ['vert', 'vert', 'vert', 'vert', 'vert']
      ]

      perPage = -> if matchmedia.isPhone() then config.pageSize else Math.floor(config.pageSize * 1.5)
      skip = Math.max(0, parseInt($localStorage.skip ? 0, 10))

      isBusy: true
      spinnerName: 'spinner-wish'

      constructor: ->

        logger.log "WishController initialized"

        #
        # Subscribe to media event
        #
        dispose = matchmedia.onPhone (mediaQueryList) =>
          @isPhone = mediaQueryList.matches
        #
        # Destructor - clean up the media event subscription
        #
        $scope.$on '$destroy', -> dispose()

        #
        # Get the data from cache or server
        #
        if (data = cache.importEntities())
          datacontext.ready().then(() => @display(data)).catch(@handleError)
        else
          datacontext.ready().then(@fetchData).catch(@handleError)

      #
      # navLeft - Navigate Left
      #
      # @parm $event
      #
      navLeft: ($event) ->
        skip += perPage()
        skip = Math.min(datacontext.maxCount-perPage(), skip)
        $localStorage.skip = skip
        @fetchData()

      #
      # navRight - Navigate Right
      #
      # @parm $event
      #
      navRight: ($event) ->
        skip -= perPage()
        skip = Math.max(0, skip)
        $localStorage.skip = skip
        @fetchData()

      #
      # fetchData - Get data from server
      #
      fetchData: () =>
        @spinner true
        datacontext.loadProducts(skip).then(@display, @handleError)

      #
      # handleError - process the error event
      #
      # @parm error
      #
      handleError: (error) =>
        @spinner false
        err = if typeof error is 'string' then error else error.message
        logger.warning err


      #
      # display
      #
      # @parm data
      #
      display: (data) =>

        console.log 'Skip '+skip+'/'+data.length
        #
        # Parse the data for display
        #
        if skip+perPage() > data.length
          @products = shuffle(data.slice(-perPage()))
        else
          @products = shuffle(data.slice(skip, skip+perPage()))

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


        #
        # Generate class and orientation
        #
        c = 0
        className = patterns[Math.floor((Math.random() * patterns.length))]
        logger.info 'Pattern: ' + (s[0] for s in className)
        for attrs in @products

          attrs.className = className[c % 5]
          c += 1
          if attrs.className is 'horz'
            if (Math.floor(Math.random() * new Date().getTime())) & 1
              attrs.aligned = 'alignleft'
            else
              attrs.aligned = 'alignright'

        #
        # Stop the spinner
        #
        @spinner false


      #
      # filter - select this product?
      #
      # @parm product
      #
      filter: (product) =>
        state = product.entityAspect.entityState
        !state.isDetached() and !state.isDeleted()

      #
      # details - Modal popup with product details
      #
      # @parm id
      #
      details: (id) =>

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
      # spinner - Start/Stop the spinner
      #
      # @parm start - true/false
      #
      spinner: (start) =>

        if (@isBusy = start)
          usSpinnerService.spin @spinnerName
        else
          usSpinnerService.stop @spinnerName

