###
# middleware/is_authorized.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Middleware to determine if a user is authorized
###
'use strict'

# External libs
debug = require('debug') 'hMedia:middleware:isAuthorized'

###
# isAuthenticated
###
module.exports = exports =
  # Return 401 unless a user is authenticated
  (req, res, next) ->
    if process.env.SKIP_AUTH
      debug 'Skipping authorization...'
      return next()

    debug 'Authorization not yet implemented.'
    next()
