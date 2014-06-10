#+--------------------------------------------------------------------+
#| Logger.coffee
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

class Logger

  # logger wraps the toastr logger and also logs to console using ng $log
  # toastr.js is library by John Papa that shows messages in pop up toast.
  # https://github.com/CodeSeven/toastr

  toastr.options.timeOut = 2000 # 2 second toast timeout
  toastr.options.positionClass = 'toast-bottom-right'

  constructor: (@$log) ->

  error: (message, title) ->
    toastr.error message, title
    @$log.error "Error: " + message

  info: (message, title) ->
    toastr.info message, title
    @$log.info "Info: " + message

  log: (message) ->
    @$log.log message

  success: (message, title) ->
    toastr.info message, title
    @$log.info "Success: " + message

  warning: (message, title) ->
    toastr.info message, title
    @$log.warn "Warning: " + message


module.exports = Logger