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
define './controllers/WishController', (require, exports, module) ->

  module.exports = ($scope, logger, entityManager, $routeParams, $location) ->

    
    perPage = 5

    
    $routeParams.skip = 0 unless $routeParams.skip?

    #
    # navLeft - Navigate Left
    #
    # @parm $event
    #
    $scope.navLeft = ($event) ->
      $location.path "/list/#{parseInt($routeParams.skip, 10)+perPage}"

    #
    # navRight - Navigate Right
    #
    # @parm $event
    #
    $scope.navRight = ($event) ->
      $location.path "/list/#{Math.max(parseInt($routeParams.skip, 10)-perPage, 0)}"


    #
    # Start the spinner (s.b. driective)
    #
    spinner = new Spinner({radius:30, width:8, length: 16})
    spinner.spin document.getElementById('wish-spinner')

    #
    # Load the next products list
    #
    entityManager.getProducts($routeParams.skip).then (data) ->

      #
      # Stop the spinner
      #
      $(".wish-splash").hide()
      spinner.stop()

      #
      # Bump the skip count for the next page
      #
      $scope.skip = parseInt($routeParams.skip, 10)+perPage

      #
      # Parse the data for display
      #
      entityManager.parseProducts $scope, data

      #
      # Arrange the products once the images are loaded
      #
      (masonry = $(".js-masonry")).imagesLoaded ->
        masonry.masonry()


