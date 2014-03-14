###
# Our server application
# #
# Nothing too special here, a quick ExpressJS app that serves a single page
# AngularJS app.  In production all it will handle is the single page app, 
###
'use strict'

# Register the coffee interpreter
require 'coffee-script/register'

# External libs
fs       = require('fs')
path     = require('path')
express  = require('express')
mongoose = require('mongoose')

###
# Main application file
###

# Load the environment
env = require('./lib/config/environment')

# Connect to database
db = mongoose.connect(env.mongo.uri, env.mongo.options)

# Bootstrap models
models = require('./lib/models')

# Passport Configuration
passport = require('./lib/config/passport')
app = express()

# Express settings
require('./lib/config/express')(app)

# Routing
require('./lib/routes')(app)

# Start server
app.listen env.port, ->
  console.log 'Express server listening on port %d in %s mode', env.port, app.get('env')
  return

# Expose app
exports = module.exports = app
