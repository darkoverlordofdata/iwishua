#+--------------------------------------------------------------------+
#| FBController.coffee
#+--------------------------------------------------------------------+
#| Copyright FiftyTwoFiftyTwo, LLC (c) 2014
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
'use strict'
#
# Facebook login/logout
#
module.exports =  ($scope, logger, $facebook) ->

    $facebook.api("/me").then (response)->

      #logger.info "Hello, "+response.first_name
      $scope.username = response.first_name

