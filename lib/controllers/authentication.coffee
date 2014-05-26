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
    debug 'Login not implemented.'
    res.send 200

  ###
  # logout
  ###
  logout: (req, res) ->
    debug 'Logout not implemented.'
    res.send 200
