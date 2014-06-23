#+--------------------------------------------------------------------+
#| Cakefile
#+--------------------------------------------------------------------+
#| Copyright FiftyTwoFiftyTwo, LLC (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of iwishua
#|
#+--------------------------------------------------------------------+
#
# cake utils
#
fs = require 'fs'
util = require 'util'
{exec} = require 'child_process'
{nfcall} = require 'q'


appFiles = [
  "iwishua/Scripts/src/modular.coffee"
  "iwishua/Scripts/src/controllers/AboutController.coffee"
  "iwishua/Scripts/src/controllers/FBController.coffee"
  "iwishua/Scripts/src/controllers/HiddenController.coffee"
  "iwishua/Scripts/src/controllers/WishController.coffee"
  "iwishua/Scripts/src/services/Logger.coffee"
  "iwishua/Scripts/src/services/Products.coffee"
  "iwishua/Scripts/src/controllers.coffee"
  "iwishua/Scripts/src/directives.coffee"
  "iwishua/Scripts/src/filters.coffee"
  "iwishua/Scripts/src/services.coffee"
  "iwishua/Scripts/src/app.coffee"
]
#
# Build Source
#
#
task 'build:src', 'Build the coffee app', ->

  start = new Date().getTime()

  if not fs.existsSync('tmp/') then fs.mkdirSync('tmp')
  if not fs.existsSync('iwishua/') then fs.mkdirSync('iwishua')
  if not fs.existsSync('iwishua/Scripts/') then fs.mkdirSync('iwishua/Scripts')
  if not fs.existsSync('iwishua/Scripts/js/') then fs.mkdirSync('iwishua/Scripts/js')
  if not fs.existsSync('iwishua/Scripts/js/app/') then fs.mkdirSync('iwishua/Scripts/js/app')

  appContents = ["'use strict'"]
  for file in appFiles
    appContents.push fs.readFileSync(file, 'utf8')

  fs.writeFileSync 'tmp/app.coffee', appContents.join('\n\n'), 'utf8'
  nfcall exec, 'coffee -o iwishua/Scripts/js -c tmp/app.coffee'

  .then ->
    nfcall exec, 'uglifyjs iwishua/Scripts/js/app.js > iwishua/Scripts/js/app.min.js'

  .fail ($err) ->
    util.error $err

  .done ($args) ->
    util.log $text for $text in $args when not /\s*/.test $text
    util.log "Compiled in #{new Date().getTime() - start} ms"
