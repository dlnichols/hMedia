###
# Express configuration
###
'use strict'

# External libs
path       = require 'path'
express    = require 'express'
mongoStore = require('connect-mongo') express

# Internal libs
env        = require './environment'
passport   = require './passport'

# Function to disable caching
disableCache = (req, res, next) ->
  if req.url.indexOf('/scripts/') == 0
    res.header 'Cache-Control', 'no-cache, no-store, must-revalidate'
    res.header 'Pragma', 'no-cache'
    res.header 'Expires', 0
  next()

###
# Express configuration
###
console.log 'Configuring express...'

module.exports = exports = (app) ->
  # Development specific config
  app.configure 'development', ->
    app.use require('connect-livereload')()
    app.use disableCache
    app.use express.static(path.join(env.root, '.tmp'))
    app.use express.static(path.join(env.root, 'app'))
    app.use express.errorHandler()
    app.set 'views', env.root + '/app/views'
    return

  # Production specific config
  # Static files should be served by static web server on prod...
  #app.configure 'production', ->
    #app.use express.favicon(path.join(env.root, 'public', 'favicon.png'))
    #app.use express.static(path.join(env.root, 'public'))
    #app.set 'views', env.root + '/views'
    #return

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
    app.use express.session(
      secret: require('./secrets/session').secret
      store: new mongoStore(
        url: env.mongo.uri
        collection: 'sessions'
      , ->
        console.log 'Mongo connection for session storage open.'
      )
    )

    # Use passport (and passport session)
    app.use passport.initialize()
    app.use passport.session()

    # Router (should be last)
    app.use app.router
    return

  return
