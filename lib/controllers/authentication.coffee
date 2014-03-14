###
# Authentication
###
'use strict'

# External libs
mongoose = require('mongoose')
passport = require('passport')

console.log 'Setting up authentication controllers...'

module.exports = exports =
  ###
  # Login
  ###
  login: (req, res, next) ->
    passport.authenticate('local', (err, user, info) ->
      error = err or info
      return res.json(401, error) if error

      req.logIn user, (err) ->
        return res.send(err) if err
        res.json req.user.userInfo
    )(req, res, next)

  ###
  # Login
  ###
  logout: (req, res) ->
    req.logout()
    res.send 200
