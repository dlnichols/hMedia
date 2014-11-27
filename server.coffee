#!node_modules/.bin/coffee

###
# server.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Our NodeJS server application.  Nothing too special here, a quick ExpressJS
# app that serves a single page AngularJS app.  In production all it will
# handle is the single page app, as all static content will be handled by a
# reverse proxy.
###
'use strict'

# Register the coffee interpreter
require 'coffee-script/register'

# Load the environment
env = require './lib/config/environment'

# External libs
app      = require('express')()

# Bootstrap mongoose
require('./lib/bootstrap') env

# Load models
require('./lib/models') env

# Configure Express
require('./lib/express') app

# Application Routes
require('./lib/routes') app

# Errors
require('./lib/errors') app

# Setup the mailer
require('./lib/mailer') app

# Start server
app.listen env.port, ->
  console.log 'Express server listening on port %d in %s mode', env.port, app.get('env')
  return

# Expose app
module.exports = exports = app
