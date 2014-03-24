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
      res.json 404
    else
      next err

  # Generic error handler - our last line of defense
  genericError = (err, req, res, next) ->
    debug 'Uncaught error: ' + err.message
    res.send 500, err

  app.use badRequest
  app.use genericError
