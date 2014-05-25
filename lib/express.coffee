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
path    = require 'path'
express = require 'express'
session = require 'express-session'
logger  = require 'morgan'
parser  = require 'body-parser'
cookies = require 'cookie-parser'
mongo   = require('connect-mongo') session
debug   = require('debug') 'hMedia:express'

# Internal libs
env      = require './config/environment'
errors   = require './errors'
routes   = require './routes'

# Middleware
disableCache = require './middleware/disable_cache'

###
# Express configuration
###
debug 'Configuring express...'

module.exports = exports = (app) ->
  # Inform express that it is behind a reverse proxy
  app.enable 'trust proxy'

  # Development specific config
  #app.configure 'development', ->
  if env.isDevelopment()
    app.use require('connect-livereload')()
    app.use disableCache
    app.use express.static(path.join(env.root, '.tmp'))
    app.use express.static(path.join(env.root, 'app'))
    app.set 'views', env.root + '/app/views'

  # Config for all environments
  app.engine 'html', require('ejs').renderFile
  app.set 'view engine', 'html'
  app.use logger(env.logger or 'default')
  app.use parser.json()
  app.use cookies()

  # Persist sessions with mongo
  app.use session \
    secret: require('./config/secrets/session').secret
    store: new mongo(
      url: env.mongo.uri
      collection: 'sessions'
    , ->
      debug 'Mongo connection for session storage open.'
    )

  return
