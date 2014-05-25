###
# middleware/set_user_cookie.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Middleware to determine if a user is authenticated
###
'use strict'

###
# setUserCookie
###
module.exports = exports =
  # Set a cookie with the user info (for use in the sign in/title bar)
  (req, res, next) ->
    res.cookie 'user', JSON.stringify(req.user.userInfo) if req.user
    next()
