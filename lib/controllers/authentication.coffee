###
# controllers/authentication.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# This module defines the login/logout actions for authentication, for use in
# our express router.
###
'use strict'

# External libs
passport = require 'passport'
debug    = require('debug') 'hMedia:controllers:authentication'

###
# Authentication controller
#
# Define the login/logout actions
###
debug 'Configuring authentication controllers...'

module.exports = exports =
  ###
  # login
  ###
  login: (req, res, next) ->
    passport.authenticate('local', (err, user, info) ->
      error = err or info
      return res.send(401, { error: error }) if error

      req.logIn user, (err) ->
        return res.send(err) if err
        res.send req.user.userInfo
    )(req, res, next)

  ###
  # logout
  ###
  logout: (req, res) ->
    req.logout()
    res.send 200
