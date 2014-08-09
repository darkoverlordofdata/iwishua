#+--------------------------------------------------------------------+
#| Cakefile
#+--------------------------------------------------------------------+
#| Copyright FiveTwoFiveTwo, LLC (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of iwishua
#|
#+--------------------------------------------------------------------+
#
# cake utils
#
Q = require('q')
fs = require 'fs'
util = require 'util'
{exec} = require 'child_process'
{nfcall} = Q

require 'coffee-script/register'



#
# Build Source
#
task 'build', 'Build the coffee app', ->

  start = new Date().getTime()

  if not fs.existsSync('tmp/') then fs.mkdirSync('tmp')

  script = ["'use strict'"]
  for file in readVSFiles('iwishua/Scripts/js/app.combine')
    script.push fs.readFileSync(file, 'utf8')

  fs.writeFileSync 'tmp/app.coffee', script.join('\n\n'), 'utf8'
  nfcall exec, 'coffee -o iwishua/Scripts/js -c tmp/app.coffee'

  .then ->
    nfcall exec, 'uglifyjs iwishua/Scripts/js/app.js > iwishua/Scripts/js/app.min.js'

  .fail ($err) ->
    util.error $err

  .done ($args) ->
    util.log $text for $text in $args when not /\s*/.test $text
    util.log "Compiled in #{new Date().getTime() - start} ms"


#
# Read the list of script modules used by
# Visual Studio Nuget: CofeeAndSass.AspNet
#
readVSFiles = (path) ->
  files = fs.readFileSync(path, 'utf8').split('\n')
  file.replace(/^~/, 'iwishua').replace(/\.js$/, '.coffee') for file in files when file isnt '' and file[0...1] isnt '#'


