###
# errors.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# These are our error handling middlewares, and are appended to end of the
# express middleware stack.
###
'use strict'

# External libs
_        = require 'lodash'
debug    = require('debug') 'hMedia:errors'
mongoose = require 'mongoose'

# Internal libs
env = require './config/environment'

###
# Handlers for various errors
###
module.exports = exports = (app) ->
  # Validation errors
  validationError = (err, req, res, next) ->
    if err.name is 'ValidationError'
      res.status 400
         .json
           error: err.message
           error_messages: err.errors
    else
      next err

  # When using the api, a missing object should return a 404
  notFound = (err, req, res, next) ->
    # ObjectId errors are generally malformed URIs, and we return 404 to
    # indicate nothing exists at that URI
    if err.type == "ObjectId" and err.path == "_id"
      debug 'Not found:\n' + err.stack
      res.send 404, error: err.stack
    else
      next err

  # Generic error handler - our last line of defense
  genericError = (err, req, res, next) ->
    unless env.isProduction()
      debug 'Err: ' + err
      debug 'Constructor: ' + err.constructor.toString()
      _.forOwn err, (value, key, object) ->
        debug key + ': ' + value
      debug 'Uncaught error:\n' + err.stack
    res.status 500
       .json error: err.stack

  app.use validationError
  app.use notFound
  app.use genericError
