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
mongoose         = require 'mongoose'
passport         = require 'passport'
LocalStrategy    = require('passport-local').Strategy
TwitterStrategy  = require('passport-twitter').Strategy
FacebookStrategy = require('passport-facebook').Strategy
GoogleStrategy   = require('passport-google-oauth').OAuth2Strategy
debug            = require('debug') 'hMedia:config:passport'

# Internal libs
env = require('./config/environment')

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
        message: 'Unknown user'
      )
    unless user.authenticate(password)
      return done(null, false,
        message: 'Invalid password'
      )
    done null, user

  null
)

###
# Twitter Strategy
#
# For authenticating by Twitter credentials
###
passport.use new TwitterStrategy(
  consumerKey:    env.secrets.twitter.id
  consumerSecret: env.secrets.twitter.secret
  callbackURL:    env.secrets.twitter.callback
, (token, tokenSecret, profile, done) ->
  User.findOne
    'twitter.id_str': profile.id
  , (err, user) ->
    return done(err) if err

    unless user
      # No user, create one
      user = new User(
        name: profile.displayName
        username: profile.username
        provider: 'twitter'
        twitter: profile._json
        roles: ['authenticated']
      )
      user.save (err) ->
        debug 'Error: ' + err.message
        return done(err, user)
    else
      return done(err, user)
    null

  null
)

###
# Facebook Strategy
#
# For authenticating by Facebook credentials
###
passport.use new FacebookStrategy(
  clientID:     env.secrets.facebook.id
  clientSecret: env.secrets.facebook.secret
  callbackURL:  env.secrets.facebook.callback
, (accessToken, refreshToken, profile, done) ->
  User.findOne
    'facebook.id': profile.id
  , (err, user) ->
    return done(err) if err

    unless user
      # No user, create one
      user = new User(
        name: profile.displayName
        email: profile.emails[0].value
        username: profile.username || profiles.emails[0].value.split('@')[0]
        provider: 'facebook'
        facebook: profile._json
        roles: ['authenticated']
      )
      user.save (err) ->
        debug 'Error: ' + err.message
        return done(err, user)
    else
      return done(err, user)
    null

  null
)

###
# Google Strategy
#
# For authenticating by Google credentials
###
passport.use new GoogleStrategy(
  clientID:     env.secrets.google.id
  clientSecret: env.secrets.google.secret
  callbackURL:  env.secrets.google.callback
, (accessToken, refreshToken, profile, done) ->
  User.findOne
    'google.id': profile.id
  , (err, user) ->
    return done(err) if err

    unless user
      # No user, create one
      user = new User(
        name: profile.displayName
        email: profile.emails[0].value
        username: profile.emails[0].value
        provider: 'google'
        google: profile._json
        roles: ['authenticated']
      )
      user.save (err) ->
        debug 'Error: ' + err.message
        return done(err, user)
    else
      return done(err, user)
    null

  null
)

###
# Export passport
###
module.exports = exports = passport
