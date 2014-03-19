###
# Passport configuration
###
'use strict'

# External libs
mongoose      = require('mongoose')
passport      = require('passport')
LocalStrategy = require('passport-local').Strategy

# Internal libs
env = require('./environment')

console.log 'Configuring passport...'

###
# Passport configuration
###
passport.serializeUser (user, done) ->
  done null, user.id
  null

passport.deserializeUser (id, done) ->
  User.findOne
    _id: id
  , '-salt -hashedPassword', (err, user) ->
    done err, user
    null
  null

###
# LocalStrategy
# #
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

module.exports = exports = passport
