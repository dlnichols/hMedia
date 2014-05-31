###
# controllers/authentication.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# This module defines the logIn/logOut actions for authentication, for use in
# our express router.
###
'use strict'

# External libs
passport = require 'passport'
debug    = require('debug') 'hMedia:controllers:authentication'

###
# Authentication controller
#
# Define the logIn/logOut actions
###
debug 'Configuring authentication controllers...'

module.exports = exports =
  ###
  # logIn
  ###
  logIn: passport.authenticate 'local'

  ###
  # status
  ###
  status: (req, res) ->
    debug 'status isAuthenticated(' + req.isAuthenticated() + ')'
    res.json 200, req.user

  ###
  # logOut
  ###
  logOut: (req, res) ->
    debug 'logOut isAuthenticated(' + req.isAuthenticated() + ')'
    if req.isAuthenticated()
      req.logOut()
      debug 'logOut isAuthenticated(' + req.isAuthenticated() + ')'
      res.json 200, redirect: '/'
    else
      res.json 401, error: 'Not logged in'
