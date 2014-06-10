#+--------------------------------------------------------------------+
#| directives.coffee
#+--------------------------------------------------------------------+
#| Copyright FiftyTwoFiftyTwo, LLC (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of iwishua
#|
#| This file is subject to the terms and conditions defined in
#| file 'license.md', which is part of this source code package.
#|
#+--------------------------------------------------------------------+
'use strict'
#
# iwishua directives
#
#
angular.module('iwishua.directives', [])

.directive 'appVersion', (version) ->
  restrict: 'A'
  link: ($scope, $element, $attrs) ->
    $element.text(version)

#
# Fix bootstrap navbar-collapse behavior
#
.directive 'fixCollapse', ($document) ->
  restrict: 'A'
  link: ($scope, $element, $attrs) ->
    $element.collapse toggle: false # https://github.com/twbs/bootstrap/issues/5859
    $document.on 'click', ->
      $element.collapse 'hide'


