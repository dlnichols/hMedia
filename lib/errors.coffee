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
debug = require('debug') 'hMedia:errors'

# Internal libs
env = require './config/environment'

###
# Handlers for various errors
###
module.exports = exports = (app) ->
  # Some errors should respond with 400 Bad Request
  badRequest = (err, req, res, next) ->
    # ObjectId errors are generally malformed URIs, and we return 404 to
    # indicate nothing exists at that URI
    if err.type == "ObjectId" and err.path == "_id"
      debug err.message
      res.send 404
    else
      next err

  # Generic error handler - our last line of defense
  genericError = (err, req, res, next) ->
    if env.isDevelopment()
      debug 'Uncaught error:\n' + err.stack
    res.send 500, { error: err.message }

  app.use badRequest
  app.use genericError
