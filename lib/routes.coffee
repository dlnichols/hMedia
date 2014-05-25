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

# Middleware
isAuthenticated  = require './middleware/is_authenticated'
notAuthenticated = require './middleware/not_authenticated'
isAuthorized     = require './middleware/is_authorized'
setUserCookie    = require './middleware/set_user_cookie'

###
# Application routes
###
debug 'Configuring routes...'

module.exports = exports = (app) ->
  ###
  # Server API Routes
  ###
  # User is a singleton route
  app.post   '/api/user', notAuthenticated, users.create
  app.get    '/api/user', isAuthenticated,  users.show
  app.put    '/api/user', isAuthenticated,  users.update
  app.delete '/api/user', isAuthenticated,  users.delete

  # Archives
  app.get    '/api/archives',     isAuthenticated, isAuthorized, archives.index
  app.post   '/api/archives',     isAuthenticated, isAuthorized, archives.create
  app.get    '/api/archives/:id', isAuthenticated, isAuthorized, archives.show
  app.put    '/api/archives/:id', isAuthenticated, isAuthorized, archives.update
  app.delete '/api/archives/:id', isAuthenticated, isAuthorized, archives.delete

  # All undefined api routes should return a 404
  app.get '/api/*', basic.notFound

  ###
  # Authentication routing
  ###
  app.post   '/auth', authentication.login
  app.delete '/auth', authentication.logout

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
  app.get '/*', setUserCookie, basic.index

  return
