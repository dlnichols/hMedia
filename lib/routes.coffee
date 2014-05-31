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
debug = require('debug') 'hMedia:routes'

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

###
# Application routes
###
debug 'Configuring routes...'

module.exports = exports = (app) ->
  ###
  # Server API Routes
  ###
  # All api route requests must be authenticated and authorized
  app.route '/api/*'
    .all isAuthenticated
    .all isAuthorized

  # Archives
  app.route '/api/archives'
    .get    archives.index
    .post   archives.create
  app.route '/api/archives/:id'
    .get    archives.show
    .put    archives.update
    .delete archives.delete

  # All undefined api routes should return a 404
  app.route '/api/*'
    .all basic.notFound

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
  # Render the index
  # If the request is XHR, then basic.index will call next, passing the
  # request on to the rest of the handlers
  ###
  app.get '/*', basic.index

  ###
  # User account routing (singleton)
  ###
  app.route '/user'
    .post   notAuthenticated, users.create
    .get    isAuthenticated,  users.show
    .put    isAuthenticated,  users.update
    .delete isAuthenticated,  users.delete

  ###
  # Authentication routing
  ###
  app.route '/auth'
    .post   authentication.logIn, authentication.status
    .get    authentication.status
    .delete authentication.logOut
  #app.get    '/auth/facebook',          authentication.facebook
  #app.get    '/auth/facebook/callback', authentication.facebookCallback
  #app.get    '/auth/github',            authentication.github
  #app.get    '/auth/github/callback',   authentication.githubCallback
  #app.get    '/auth/twitter',           authentication.twitter
  #app.get    '/auth/twitter/callback',  authentication.twitterCallback
  #app.get    '/auth/google',            authentication.google
  #app.get    '/auth/google/callback',   authentication.googleCallback
  #app.get    '/auth/linkedin',          authentication.linkedin
  #app.get    '/auth/linkedin/callback', authentication.linkedinCallback

  return
