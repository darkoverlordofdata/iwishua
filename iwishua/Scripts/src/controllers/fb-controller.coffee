#+--------------------------------------------------------------------+
#| FBController.coffee
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
# Facebook login/logout
#
angular.module('iwishua')
.controller 'FBController',
  ($scope, logger, $facebook, config) ->

    new class FBController

      connected   : false # true when logged in to facebook
      admin       : false # true if facebook admin logged on

      constructor: ->
        logger.log "FB Controller initialized"
        $facebook.getLoginStatus().then @connect
        return



      #
      # login - Logon to Facebook
      #
      #
      login: =>
        return if @connected
        $facebook.login().then @connect
        return


      #
      # connect - Finish up facebook connection
      #
      #
      connect: (response) =>
        if response.status is 'connected'
          $facebook.api("/me").then (response) =>
            @username = response.first_name
            @connected = true
            @checkAuth response
            config.login response.id
        else
          @username = 'Login'
          @connected = false
          @admin = false
          config.login ''
        
      #
      # logout - Logout from Facebook
      #
      #
      logout: =>
        return unless @connected
        $facebook.logout().then (response) =>

          @connected = if response.status is 'connected' then true else false
          if not @connected
            @username = 'Login'
            @admin = false
            config.login ''
        return


      #
      # checkAuth - Check if a facebook admin
      #
      # @param response
      #
      checkAuth: (response) =>
        admins = $("meta[property='fb:admins']")
#        admins = [admins] unless Array.isArray(admins)

        for admin in admins
          if response.id is admin.content
            @admin = true
            logger.warning 'Admin access: '+response.first_name
            return
        return


