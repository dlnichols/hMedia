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

debug 'Configuring authentication controllers...'

###
# Authentication controller
#
# Define the login/logout actions
###
module.exports = exports =
  ###
  # login
  ###
  login: (req, res, next) ->
    passport.authenticate('local', (err, user, info) ->
      error = err or info
      return res.json(401, error) if error

      req.logIn user, (err) ->
        return res.send(err) if err
        res.json req.user.userInfo
    )(req, res, next)

  ###
  # logout
  ###
  logout: (req, res) ->
    req.logout()
    res.send 200
