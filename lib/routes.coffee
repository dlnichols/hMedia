###
# routes.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# This module defines our routes (used by the express router in our middleware
# stack).
###
'use strict'

# External libs
passport       = require 'passport'
debug          = require('debug') 'hMedia:routes'

# Internal libs
env            = require './config/environment'
basic          = require './controllers/basic'
users          = require './controllers/users'
archives       = require './controllers/archives'
authentication = require './controllers/authentication'
mw             = require './middleware'

debug 'Configuring routes...'

###
# Application routes
###
module.exports = exports = (app) ->
  ###
  # notFound
  #
  # Return 404 error
  ###
  notFound = (req, res) ->
    res.send 404

  ###
  # Server API Routes
  ###
  # User is a singleton route
#  app.post   '/api/user', mw.notAuthenticated, users.create
#  app.get    '/api/user', mw.authenticated,    users.show
#  app.put    '/api/user', mw.authenticated,    users.update
#  app.delete '/api/user', mw.authenticated,    users.delete

  # Archives
#  app.get    '/api/archives',     mw.authenticated, mw.authorized, archives.index
#  app.post   '/api/archives',     mw.authenticated, mw.authorized, archives.create
#  app.get    '/api/archives/:id', mw.authenticated, mw.authorized, archives.show
#  app.put    '/api/archives/:id', mw.authenticated, mw.authorized, archives.update
#  app.delete '/api/archives/:id', mw.authenticated, mw.authorized, archives.delete

  # All undefined api routes should return a 404
#  app.get '/api/*', notFound

  ###
  # Authentication routing
  ###
#  app.post   '/auth', authentication.login
#  app.delete '/auth', authentication.logout

  ###
  # Partials
  #
  # This route should only be handled in dev/test, but if the config for the
  # web server is incorrect, it may get called in prod.
  ###
  app.get '/partials/*', basic.partials

  ###
  # Base routing
  #
  # Anything not handled by any other route should serve the application page.
  ###
  app.get '/*', mw.setUserCookie, basic.index

  return
