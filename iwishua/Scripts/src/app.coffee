#+--------------------------------------------------------------------+
#| app.coffee
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
# iwishua app
#
# ----------------------------
# iwishua dependencies
# ----------------------------
angular.module('iwishua', [
  'ngTouch'
  'ngRoute'
  'ngStorage'
  'ngFacebook'
  'angularSpinner'
  'matchmedia-ng'
  'wu.masonry'
  'ui.bootstrap'
  'breeze.angular'
#  'infinite-scroll'
])
# ----------------------------
# Routes
# ----------------------------
.config ($routeProvider, $facebookProvider) ->

  appId = $("meta[property='fb:app_id']").attr('content')

  $facebookProvider.setAppId appId
  $facebookProvider.setPermissions "publish_stream"
  $facebookProvider.setCustomInit
    xfbml      : true
    version    : 'v2.0'
    cookie     : true

  $routeProvider
  #
  # Application Menu
  #

  .when '/',              # home
    templateUrl:  'Content/views/wish/index.html'

  .when '/hidden',        # list hidden items
    templateUrl:  'Content/views/hidden.html'

  .when '/friends',        # List facebook friends
    templateUrl:  'Content/views/friends.html'

  .when '/options',        # list hidden items
    templateUrl:  'Content/views/options.html'

  .when '/about',         # FB: Terms of Service URL
    templateUrl:  'Content/views/about.html'

  .when '/privacy',       # FB: Privacy Policy URL
    templateUrl:  'Content/views/privacy.html'

  .when '/support',       # FB: User Support URL
    templateUrl:  'Content/views/about.html'

  .otherwise(redirectTo: '/')


# ----------------------------
# Start the app
# ----------------------------
.run ($log) ->

  appId = $("meta[property='fb:app_id']").attr('content')
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
    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=#{appId}"
    ref.parentNode.insertBefore js, ref


  $log.log 'iwishua application boot...'