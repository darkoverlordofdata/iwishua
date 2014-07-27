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
facebook_app_id = '1495109164043412'

# ----------------------------
# iwishua dependencies
# ----------------------------
angular.module('iwishua', [
  'ngTouch'
  'ngRoute'
  'ngStorage'
  'ngFacebook'
#  'ngBootbox'
  'angularSpinner'
  'matchmedia-ng'
  'wu.masonry'
  'ui.bootstrap'
  'breeze.angular'
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
    templateUrl:  'Content/partials/wish.html'

  .when '/hidden',        # list hidden items
    templateUrl:  'Content/partials/hidden.html'

  .when '/options',        # list hidden items
    templateUrl:  'Content/partials/options.html'

  .when '/about',         # FB: Terms of Service URL
    templateUrl:  'Content/partials/about.html'

  .when '/privacy',       # FB: Privacy Policy URL
    templateUrl:  'Content/partials/privacy.html'

  .when '/support',       # FB: User Support URL
    templateUrl:  'Content/partials/about.html'

  .otherwise(redirectTo: '/')


# ----------------------------
# Start the app
# ----------------------------
.run ($log) ->

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


  $log.log 'iwishua application boot...'