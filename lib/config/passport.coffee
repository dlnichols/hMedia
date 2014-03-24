###
# config/passport.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# This module intializes passport and creates our LocalStrategy for logging
# users in with an email and password.
###
'use strict'

# External libs
mongoose      = require 'mongoose'
passport      = require 'passport'
LocalStrategy = require('passport-local').Strategy
debug         = require('debug') 'hMedia:config:passport'

# Internal libs
env = require('./environment')

debug 'Configuring passport...'

###
# serializeUser
###
passport.serializeUser (user, done) ->
  done null, user.id

###
# deserializeUser
###
passport.deserializeUser (id, done) ->
  User.findOne
    _id: id
  , '-salt -hashedPassword', (err, user) ->
    done err, user
  null

###
# LocalStrategy
#
# For authenticating by email and password
###
passport.use new LocalStrategy(
  usernameField: 'email'
  passwordField: 'password'
, (email, password, done) ->
  User.findOne
    email: email
  , (err, user) ->
    return done(err) if err

    unless user
      return done(null, false,
        message: 'You have entered an incorrect email address.'
      )
    unless user.authenticate('local', password)
      return done(null, false,
        message: 'You have entered an incorrect password.'
      )
    done null, user

  null
)

###
# Export passport
###
module.exports = exports = passport
