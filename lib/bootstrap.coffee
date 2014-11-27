###
# lib/bootstrap.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# This module bootstraps our mongo connection
###
'use strict'

# External libs
mongoose = require 'mongoose'
debug    = require('debug') 'hMedia:bootstrap'

module.exports = exports = (env) ->
  # Print connected message
  mongoose.connection.on 'open', ->
    debug 'Connected to mongo.'

  # Handle errors
  mongoose.connection.on 'error', (err) ->
    debug 'Unable to connect to mongo: ' + err

  unless mongoose.connection.readyState > 0
    debug 'Connecting to mongo: ' + env.mongo.uri
    mongoose.connect env.mongo.uri, env.mongo.options
  else
    debug 'Mongoose already connected.'
