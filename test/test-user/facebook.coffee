#+--------------------------------------------------------------------+
#| test-user/facebook.coffee
#+--------------------------------------------------------------------+
#| Copyright FiveTwoFiveTwo, LLC (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of iwishua
#|
#+--------------------------------------------------------------------+
#
# Facebook Test User Management
#
Q = require('q')
qs = require('querystring')
request = require('request')

module.exports = class FacebookTestUser


  api = "https://graph.facebook.com"

  app_id        : ''
  app_secret    : ''
  app_token     : ''
  app_users     : null
  
  constructor: (@app_id, @app_secret) ->
    @app_users = []


  #
  # Promise: Facebook logon
  #
  logon: =>
    Q.Promise (resolve, reject) =>

      request.get 
        url: "#{api}/oauth/access_token"
        qs: 
          redirect_uri    : "http://localhost"
          client_id       : @app_id
          client_secret   : @app_secret
          grant_type      : "client_credentials"

      , (err, response, body) =>
      
        return reject(err) if err
        return reject(response) unless response.statusCode is 200
        resolve qs.parse(body).access_token


  #
  # Promise: Get Facebook Test Users
  #
  getUsers: (token) =>
    Q.Promise (resolve, reject) =>

      request.get 
        url : "#{api}/#{@app_id}/accounts/test-users?"
        qs  : access_token: token 
        json: true

      , (err, res, body) =>
      
        if err then reject(err) else resolve(body)


  #
  # Promise: Make Facebook Test User Friends
  #
  makeFriends: (token, user1, user2) =>
    Q.Promise (resolve, reject) =>

      request.post 
        url : "#{api}/#{user1.id}/friends/#{user2.id}?"
        json: true
        qs:
          permissions   : "read_stream"
          access_token  : user1.access_token 

      , (err, response, user) =>

        if err or response.statusCode isnt 200
          console.log  "pass 3 failed #{response.body.error.message}: #{user1.id}/friend/#{user2.id}"
        return reject(err) if err
        return reject(response) unless response.statusCode is 200
        resolve user1: user1, user2: user2



  #
  # Promise: Create Facebook Test User
  #
  createUser: (token, name, index) =>
    Q.Promise (resolve, reject) =>
      
      request.post 
        url : "#{api}/#{@app_id}/accounts/test-users?"
        json: true
        qs:
          permissions   : "read_stream,publish_stream"
          access_token  : token 

      , (err, response, user) =>

        if err or response.statusCode isnt 200
          console.log  "pass 1.a failed #{response.body.error.message}: #{name}"
        return reject(err) if err
        return reject(response) unless response.statusCode is 200

        console.log "#{index}) #{user.id}"
        @app_users.push user

        request.post 
          url : "https://graph.facebook.com/#{user.id}?"
          json: true
          qs  : 
            name          : name
            installed     : true
            access_token  : token 

        , (err, response) =>

          if err or response.statusCode isnt 200
            console.log  "pass 1.b failed #{response.body.error.message}: #{name}"
          return reject(err) if err
          return reject(user: user, name: name) unless response.statusCode is 200
          resolve user

