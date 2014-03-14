###
# Routes
###
'use strict'

# External libs
passport       = require('passport')

# Internal libs
index          = require('./controllers')
users          = require('./controllers/users')
authentication = require('./controllers/authentication')
middleware     = require('./middleware')

console.log 'Routing...'

###
# Application routes
###
module.exports = exports = (app) ->
  # Multi use function definition
  not_found = (req, res) ->
    res.send(404)

  # Server API Routes
  app.post '/api/users', users.create
  app.put  '/api/users', users.changePassword
  app.get  '/api/users', users.show

  # All undefined api routes should return a 404
  app.get  '/api/*', not_found

  # Authentication routing
  app.post '/auth', authentication.login
  app.del  '/auth', authentication.logout

  # Return 404 when partials or styles requested are not found
  app.get  '/partials/*', index.partials
  app.get  '/styles/*',   not_found
  app.get  '/images/*',   not_found

  # All other routes to use Angular routing in app/scripts/app.js
  app.get  '/*', middleware.setUserCookie, middleware.setStateToken, index.index
