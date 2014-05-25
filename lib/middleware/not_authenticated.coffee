###
# middleware/not_authenticated.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Middleware to check that no user is authenticated
###
'use strict'

# External libs
debug = require('debug') 'hMedia:middleware:notAuthenticated'

###
# notAuthenticated
###
module.exports = exports =
  # Stop authenticated users from performing actions limited to unauthenticated users
  (req, res, next) ->
    if process.env.SKIP_AUTH
      debug 'Skipping authentication...'
      return next()

    unless req.isAuthenticated()
      next()
    else
      res.send 400
