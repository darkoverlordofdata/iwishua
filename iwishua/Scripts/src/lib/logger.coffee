#+--------------------------------------------------------------------+
#| logger.coffee
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
# Application logging
#
# logger wraps the toastr logger & also logs to console using ng $log
# toastr.js is library by John Papa that shows messages in pop up toast.
# https://github.com/CodeSeven/toastr
#
angular.module('iwishua')
.factory 'logger',
  ($log, config) ->

    new class Logger

      toastr.options.timeOut = config.toastr.timeOut
      toastr.options.positionClass = config.toastr.positionClass

      @ERROR        : 1                   #   log only errors
      @INFO         : 2                   #   log info messages
      @WARNING      : 4                   #   log warnings
      @SUCCESS      : 8                   #   log success
      @LOG          : 16                  #   generic log

      constructor: ->
        $log.log "Logger initialized"


      #
      # Write Error Log
      #
      # @param  [String]  message to log
      # @param  [String]  popup window title
      # @return	Nothing
      #
      error: (message, title) =>
        if (config.logThreshold & Logger.ERROR) is Logger.ERROR
          toastr.error message, title
          $log.error "Error: " + message

      #
      # Write Info Log
      #
      # @param  [String]  message to log
      # @param  [String]  popup window title
      # @return	Nothing
      #
      info: (message, title) =>
        if (config.logThreshold & Logger.INFO) is Logger.INFO
          toastr.info message, title
          $log.info "Info: " + message

      #
      # Write Console only Log
      #
      # @param  [String]  message to log
      # @return	Nothing
      #
      log: (message) =>
        if (config.logThreshold & Logger.LOG) is Logger.LOG
          $log.log message

      #
      # Write Success Log
      #
      # @param  [String]  message to log
      # @param  [String]  popup window title
      # @return	Nothing
      #
      success: (message, title) =>
        if (config.logThreshold & Logger.SUCCESS) is Logger.SUCCESS
          toastr.info message, title
          $log.info "Success: " + message

      #
      # Write Warning Log
      #
      # @param  [String]  message to log
      # @param  [String]  popup window title
      # @return	Nothing
      #
      warning: (message, title) =>
        if (config.logThreshold & Logger.WARNING) is Logger.WARNING
          toastr.info message, title
          $log.warn "Warning: " + message


