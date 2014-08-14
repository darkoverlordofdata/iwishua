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
angular.module('iwishua').controller 'WishController',
  ($scope, $route, $location, $localStorage, $modal, matchmedia, logger, datacontext, shuffle, config, cache, usSpinnerService, iwishua) ->


    new class WishController

      Config   = Object.getClass(config)
      skip     = Math.max(0, parseInt($localStorage['skip'+config.id] ? 0, 10))
      perPage  = -> if matchmedia.isPhone() then config.pageSize else Math.floor(config.pageSize * 1.5)


      isBusy        : true
      spinnerName   : 'spinner-wish'


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
      # layout - get's the layout template
      #
      # @return template file name
      #
      layout: -> 
        config.layoutNames[config.layout].replace('_', '-').toLowerCase()

      #
      # navLeft - Navigate Left
      #
      # @param $event
      #
      navLeft: ($event) ->
        skip += perPage()
        skip = Math.min(datacontext.maxCount-perPage(), skip)
        $localStorage['skip'+config.id] = skip
        @fetchData()

      #
      # navRight - Navigate Right
      #
      # @param $event
      #
      navRight: ($event) ->
        skip -= perPage()
        skip = Math.max(0, skip)
        $localStorage['skip'+config.id] = skip
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
      # @param error
      #
      handleError: (error) =>
        @spinner false
        err = if typeof error is 'string' then error else error.message
        logger.warning err


      #
      # display
      #
      # @param data
      #
      display: (data) =>

        #
        # Parse the data for display
        #
        data = if skip+perPage() > data.length
          shuffle(data.slice(-perPage()))
        else
          shuffle(data.slice(skip, skip+perPage()))

        @products = []
        for product in data
          if @filter(product)
            @products.push product

        for attrs in @products

          if config.scrub
            title = attrs.productTitle
            # strip off wrapping quotes
            if title[0...1] is '"' then title = title[1...-1]
            
            words = title.replace(/[-,.©®™]/g, ' ')   # remove special chars
            .replace(/([a-z])([A-Z])/g, "$1 $2")      # change 'camelCase' to 'camel Case'
            .split(/\s+/)                             # split on whitespace
            attrs.productTitle = words.join(' ')      # reduce whitespaces to single space
            
            name = ''
            until name.length > 20 or words.length is 0
              name = words.pop() + ' ' + name.substr(0, 1).toUpperCase() + name.substr(1)
            attrs.productName = name
            
          else attrs.productName = attrs.productTitle


        #
        # Layout the images
        #
        if config.layout is Config.LAYOUT_TILED
          c = 0
          className = config.tiles[Math.floor((Math.random() * config.tiles.length))]
          logger.info 'Pattern: ' + (s[0] for s in className)
          for attrs in @products

            attrs.className = className[c % 5]
            c += 1
            if attrs.className is 'horz'
              if (Math.floor(Math.random() * new Date().getTime())) & 1
                attrs.aligned = 'alignleft'
              else
                attrs.aligned = 'alignright'

        else
          attrs.className = 'layout_list'
          attrs.aligned = 'alignleft'
        
          
        #
        # Stop the spinner
        #
        @spinner false


      #
      # filter - select this product?
      #
      # @param product
      #
      filter: (product) =>
        state = product.entityAspect.entityState
        !state.isDetached() and !state.isDeleted()

      #
      # details - Modal popup with product details
      #
      # @param id
      #
      details: (id) =>

        for product in @products
          if id is product.id
            modal = $modal.open
              size          : 'sm'
              templateUrl   : 'Content/views/wish/details.html'
              controller    : 'DetailController'
              resolve:
                productData: () ->
                  return product
            
            modal.result.then (result) ->
              switch result
              
                when 'DELETE'
                  datacontext.deleteProduct product
                  $route.reload()
                
                when 'WISH'
                  iwishua.product = product
                  $location.path('/friends')                  
                
              
            return
        return

      #
      # spinner - Start/Stop the spinner
      #
      # @param start - true/false
      #
      spinner: (start) =>

        if (@isBusy = start)
          usSpinnerService.spin @spinnerName
        else
          usSpinnerService.stop @spinnerName

