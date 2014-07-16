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
# fixCollapse
#
# Fix bootstrap navbar-collapse behavior
#
angular.module('iwishua')
.directive 'fixCollapse', ($document) ->
  restrict: 'A'
  link: ($scope, $element, $attrs) ->
    $element.collapse toggle: false # https://github.com/twbs/bootstrap/issues/5859
    $document.on 'click', ->
      $element.collapse 'hide'

