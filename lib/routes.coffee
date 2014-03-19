###
# Routes
###
'use strict'

# External libs
passport       = require('passport')

# Internal libs
basic          = require('./controllers/basic')
users          = require('./controllers/users')
archives       = require('./controllers/archives')
authentication = require('./controllers/authentication')
middleware     = require('./middleware')

# Vars
authenticated = passport.authenticate [ 'local' ]
authorized = (req, res, next) ->
  authenticated req, res, next
  #Check user authorization here
  console.log 'Checking authorization'
  next()

console.log 'Routing...'

###
# Application routes
###
module.exports = exports = (app) ->
  # Multi use function definition
  not_found = (req, res) ->
    res.send(404)

  ###
  # Server API Routes
  ###
  # User is a singleton route
  app.post   '/api/user', users.create
  app.get    '/api/user', authenticated, users.show
  app.put    '/api/user', authenticated, users.update
  app.delete '/api/user', authenticated, users.delete

  # Archives
  app.get    '/api/archives',     archives.index
  app.post   '/api/archives',     archives.create
  app.get    '/api/archives/:id', archives.show
  app.put    '/api/archives/:id', archives.update
  app.delete '/api/archives/:id', archives.delete

  # All undefined api routes should return a 404
  app.get  '/api/*', not_found

  # Authentication routing
  app.post '/auth', authentication.login
  app.del  '/auth', authentication.logout

  # Return 404 when partials or styles requested are not found
  app.get  '/partials/*', basic.partials
  app.get  '/styles/*',   not_found
  app.get  '/images/*',   not_found

  # All not found routes return the user cookie and our Angular app
  app.get  '/*', middleware.setUserCookie, basic.index
