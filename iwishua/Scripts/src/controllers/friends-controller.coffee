#+--------------------------------------------------------------------+
#| FriendsController.coffee
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
# Show friends
#
angular.module('iwishua').controller 'FriendsController',
  ($scope, $route, $location, logger, $facebook, $modal, iwishua, config) ->


    new class FriendsController


      friends: null
      product: null

      constructor: ->

        logger.log "FriendsController initialized"
        $facebook.api("/me/friends", fields: "name,first_name,picture").then (response) =>
          logger.log response
          @friends = response.data
          @product = iwishua.product
          
          
        
      
      #
      # post - Modal popup Post to Facebook
      #
      # @param id
      #
      post: (friend) => # post to facebook

        modal = $modal.open
          size          : 'sm'
          templateUrl   : 'Content/views/friends/post.html'
          controller    : 'PostController'
          resolve:
            productData: () =>
              return @product
            friendData: () =>
              return friend

        modal.result.then (result) =>
          
          if result.state is 'POST'

            params =
             message       : result.wish
             description   : @product.productTitle
             picture       : @product.productImageUrl
             
            console.log params

            $facebook.api("/me/feed", "post", params).then( 
              (response) =>

                if response.error
                  logger.warning response.error, "Iwishua"
                else
                  logger.success "Posted to facebook", "Iwishua"
                  
              ,(response) =>
              
                logger.warning response.message, response.type
              )


          return
        return
