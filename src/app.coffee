#+--------------------------------------------------------------------+
#| app.coffee
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
# iwishua app
#
facebook_app_id = '1495109164043412'

# ----------------------------
# Load the core components
# ----------------------------
require "./services"
require "./filters"
require "./directives"
require "./controllers"

# ----------------------------
# iwishua dependencies
# ----------------------------
angular.module('iwishua', [
  'ngTouch'
  'ngRoute'
  'ngFacebook'
  'breeze.angular'
  'iwishua.services'
  'iwishua.filters'
  'iwishua.directives'
  'iwishua.controllers'
])
# ----------------------------
# Routes
# ----------------------------
.config ($routeProvider, $facebookProvider) ->

  $facebookProvider.setAppId "#{facebook_app_id}"
  $facebookProvider.setPermissions "publish_stream"
  $facebookProvider.setCustomInit
    xfbml      : true
    version    : 'v2.0'

  $routeProvider
  #
  # Application Menu
  #

  .when '/',              # home
    templateUrl:  'partials/wish.html'
    controller:   'WishController'

  .when '/list/:skip',    # next group
    templateUrl:  'partials/wish.html'
    controller:   'WishController'

  .when '/hidden',        # list hidden items
    templateUrl:  'partials/hidden.html'
    controller:   'HiddenController'

  .when '/hidden/:skip',  # list hidden items
    templateUrl:  'partials/hidden.html'
    controller:   'HiddenController'

  .when '/about',         # FB: Terms of Service URL
    templateUrl:  'partials/about.html'
    controller:   'AboutController'

  .when '/privacy',       # FB: Privacy Policy URL
    templateUrl:  'partials/privacy.html'
    controller:   'AboutController'

  .when '/support',       # FB: User Support URL
    templateUrl:  'partials/about.html'
    controller:   'AboutController'

  .otherwise(redirectTo: '/')


# ----------------------------
# Start the app
# ----------------------------
.run () ->


  # ----------------------------
  # Start loading the Facebook JS SDK (Asynchronous)
  # ----------------------------
  do (d = document) ->
    id = "facebook-jssdk"
    ref = d.getElementsByTagName("script")[0]
    return  if d.getElementById(id)
    js = d.createElement("script")
    js.id = id
    js.async = true
    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=#{facebook_app_id}"
    ref.parentNode.insertBefore js, ref

  # ----------------------------
  # supposed to help swipe gestures... (y/n)?
  # ----------------------------
  if document.addEventListener
    document.addEventListener 'touchmove', (e) ->
      e.preventDefault()
