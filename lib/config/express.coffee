###
# Express configuration
###
'use strict'

# External libs
path       = require('path')
express    = require('express')
passport   = require('passport')
mongoStore = require('connect-mongo')(express)

# Internal libs
env        = require('./environment')

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
    null

  # Production specific config
  app.configure 'production', ->
    app.use express.favicon(path.join(env.root, 'public', 'favicon.png'))
    app.use express.static(path.join(env.root, 'public'))
    app.set 'views', env.root + '/views'
    null

  # Config for all environments
  app.configure ->
    app.engine 'html', require('ejs').renderFile
    app.set 'view engine', 'html'
    app.use express.logger('dev')
    app.use express.json()
    app.use express.urlencoded()
    app.use express.methodOverride()
    app.use express.cookieParser()
    null

    # Persist sessions with mongoStore
    app.use express.session(
      secret: require('./secrets/session').secret
      store: new mongoStore(
        url: env.mongo.uri
        collection: 'sessions'
      , ->
        console.log 'db connection open'
      )
    )

    # Use passport session
    app.use passport.initialize()
    app.use passport.session()

    # Router needs to be last
    app.use app.router
    null

  null
