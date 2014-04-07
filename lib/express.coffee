###
# express.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# This module does all of our express configuration, except routing (that's in
# a separate module).
###
'use strict'

# External libs
path       = require 'path'
express    = require 'express'
mongoStore = require('connect-mongo') express
debug      = require('debug') 'hMedia:express'

# Internal libs
env        = require './config/environment'
passport   = require './config/passport'
errors     = require './errors'

###
# disableCache
#
# Function to disable caching
# TODO: Consider exporting this to middleware module
###
disableCache = (req, res, next) ->
  if req.url.indexOf('/scripts/') == 0
    res.header 'Cache-Control', 'no-cache, no-store, must-revalidate'
    res.header 'Pragma', 'no-cache'
    res.header 'Expires', 0
  next()

debug 'Configuring express...'

###
# Express configuration
###
module.exports = exports = (app) ->
  # Inform express that it is behind a reverse proxy
  app.enable 'trust proxy'

  # Development specific config
  app.configure 'development', ->
    app.use require('connect-livereload')()
    app.use disableCache
    app.use express.static(path.join(env.root, '.tmp'))
    app.use express.static(path.join(env.root, 'app'))
    app.set 'views', env.root + '/app/views'
    return

  # Config for all environments
  app.configure ->
    app.engine 'html', require('ejs').renderFile
    app.set 'view engine', 'html'
    app.use express.logger('dev')
    app.use express.json()
    app.use express.urlencoded()
    app.use express.methodOverride()
    app.use express.cookieParser()

    # Persist sessions with mongoStore
    app.use express.session \
      secret: require('./config/secrets/session').secret
      store: new mongoStore(
        url: env.mongo.uri
        collection: 'sessions'
      , ->
        debug 'Mongo connection for session storage open.'
      )

    # Use passport (and passport session)
    app.use passport.initialize()
    app.use passport.session()

    # Router
    app.use app.router
    return

  return
