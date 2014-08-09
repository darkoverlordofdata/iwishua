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


#
# Facebook User Management
#
qs = require 'querystring'
request = require 'request'

{app_id, app_secret, users} = require('./test/users.coffee')
app_token = ''
app_users = []


#
# Promise: Facebook logon
#
logon = ->
  Q.Promise (resolve, reject) ->
  
    request.get 
      url: 'https://graph.facebook.com/oauth/access_token'
      qs: 
        redirect_uri    : "http://localhost"
        client_id       : app_id
        client_secret   : app_secret
        grant_type      : "client_credentials"

    , (err, response, body) ->
    
      return reject(err) if err
      return reject(response) unless response.statusCode is 200
      resolve qs.parse(body).access_token


#
# Promise: Get Facebook Test Users
#
getUsers = (token) ->
  Q.Promise (resolve, reject) ->

    request.get 
      url : "https://graph.facebook.com/#{app_id}/accounts/test-users?"
      qs  : access_token: token 
      json: true

    , (err, res, body) ->
      if err then reject(err) else resolve(body)


#
# Promise: Make Facebook Test User Friends
#
makeFriends = (token, user1, user2) ->
  Q.Promise (resolve, reject) ->
  
    request.post 
      url : "https://graph.facebook.com/#{user1.id}/friends/#{user2.id}?"
      json: true
      qs:
        permissions   : "read_stream"
        access_token  : user1.access_token 

    , (err, response, user) ->
    
      if err or response.statusCode isnt 200
        console.log  "pass 3 failed #{response.body.error.message}: #{user1.id}/friend/#{user2.id}"
      return reject(err) if err
      return reject(response) unless response.statusCode is 200
      resolve user1: user1, user2: user2


    
#
# Promise: Create Facebook Test User
#
createUser = (token, name, index) ->
  Q.Promise (resolve, reject) ->
  
    request.post 
      url : "https://graph.facebook.com/#{app_id}/accounts/test-users?"
      json: true
      qs:
        permissions   : "read_stream"
        access_token  : token 

    , (err, response, user) ->
    
      return reject(err) if err
      return reject(response) unless response.statusCode is 200
      
      console.log "#{index}) #{user.id}"
      app_users.push user
      
      request.post 
        url : "https://graph.facebook.com/#{user.id}?"
        json: true
        qs  : 
          name          : name
          installed     : true
          access_token  : token 

      , (err, response) ->

        if err or response.statusCode isnt 200
          console.log  "pass 1 failed #{response.body.error.message}: #{name}"
        return reject(err) if err
        return reject(user: user, name: name) unless response.statusCode is 200
        resolve user

  
  

#
# List Facebook Test Users
#
task 'user:list', 'list test users', ->
  logon().then (token) ->
    
    getUsers(token)

    .then (body) ->
      console.log body.data

    .catch (e) ->
      console.log 'rejected '+e

  
#
# Create the Facebook Test Uses
#
task 'user:create', 'create all test users', (options) ->

  logon().then (token) ->
      
    funcs = (createUser(token, name, index) for name, index in users)
    Q.allSettled(funcs)
    .then (results) -> # now friend everyone
    
      funcs = []
      for mark in app_users
        for test in app_users
          if test.id isnt mark.id
            funcs.push makeFriends(token, mark, test)
            funcs.push makeFriends(token, test, mark)
            
      Q.allSettled(funcs).then ->
        console.log "That's All Folks!"
        
      
      
      


