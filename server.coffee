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

# External libs
fs       = require 'fs'
path     = require 'path'
mongoose = require 'mongoose'
app      = require('express')()

# Load the environment
env = require './lib/config/environment'

# Load models
require('./lib/models') env

# Configure Express
require('./lib/express') app

# Routing
require('./lib/routes') app

# Errors
require('./lib/errors') app

# Setup the mailer
require('./lib/mailer') app

# Open database connection
mongoose.connect env.mongo.uri, env.mongo.options

# Start server
app.listen env.port, ->
  console.log 'Express server listening on port %d in %s mode', env.port, app.get('env')
  return

# Expose app if loaded as a module
module.exports = exports = app
