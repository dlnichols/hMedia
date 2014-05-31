###
# middleware/is_authenticated.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Middleware to determine if a user is authenticated
###
'use strict'

# External libs
debug = require('debug') 'hMedia:middleware:isAuthenticated'

###
# isAuthenticated
###
module.exports = exports =
  # Return 401 unless a user is authenticated
  (req, res, next) ->
    if process.env.SKIP_AUTH
      debug 'Skipping authentication...'
      return next()

    if req.isAuthenticated()
      next()
    else
      res.json 401, error: 'Not signed in'
