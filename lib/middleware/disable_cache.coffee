###
# middleware/disable_cache.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Middleware to disable the cache for scripts (mostly for dev)
###
'use strict'

###
# disableCache
###
module.exports = exports =
  # Disable caching of javascript (so they are reloaded every refresh)
  (req, res, next) ->
    if req.url.indexOf('/scripts/') is 0
      res.header 'Cache-Control', 'no-cache, no-store, must-revalidate'
      res.header 'Pragma', 'no-cache'
      res.header 'Expires', 0
    next()
