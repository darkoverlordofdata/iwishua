#+--------------------------------------------------------------------+
#| directives.coffee
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
# iwishua directives
#
# Spinner
#
angular.module('iwishua')
.directive 'spinner', () ->
  restrict: 'C'
  link: ($scope, $element, $attrs) ->
    #
    # Start the spinner
    #
    spinner = new Spinner(radius: 30, width: 8, length: 16)
    spinner.spin $element[0]

    $scope.$on 'stop-spinner', () ->
      #
      # Stops the spinner
      #
      spinner.stop()

    $scope.$on 'start-spinner', () ->
      #
      # Stops the spinner
      #
      spinner.start()