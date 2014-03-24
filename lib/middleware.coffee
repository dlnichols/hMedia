###
# middleware.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Just some random useful middleware for our application.
###
'use strict'

# External libs
crypto = require 'crypto'
debug  = require('debug') 'hMedia:middleware'

debug 'Configuring local middleware...'

###
# Custom middleware used by the application
###
module.exports = exports =
  # Protect routes on the api from unauthenticated access
  authenticated: (req, res, next) ->
    if process.env.SKIP_AUTH
      debug 'Skipping authentication...'
      return next()

    if req.isAuthenticated()
      next()
    else
      res.send 401

  # Stop authenticated users from performing actions limited to unauthenticated users
  notAuthenticated: (req, res, next) ->
    if process.env.SKIP_AUTH
      debug 'Skipping authentication...'
      return next()

    unless req.isAuthenticated()
      next()
    else
      res.send 400

  # Protect routes from unauthorized access
  authorized: (req, res, next) ->
    if process.env.SKIP_AUTH
      debug 'Skipping authorization...'
      return next()

    debug 'Authorization is not yet implemented...'
    next()

  # Set a cookie for angular so it knows we have an http session
  setUserCookie: (req, res, next) ->
    res.cookie 'user', JSON.stringify(req.user.userInfo) if req.user
    next()
