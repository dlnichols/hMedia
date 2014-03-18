###
# User model
###
'use strict'

mongoose = require 'mongoose'
Schema   = mongoose.Schema
crypto   = require 'crypto'

authTypes = [ 'local' ]

console.log 'Loading user model...'

###
# User Schema
###
UserSchema = new Schema(
  display: String
  name: String
  email: String
  role:
    type   : String
    default: 'guest'
  confirmed:
    type   : Boolean
    default: false
  providers:
    type   : []
    default: [ 'local' ]
  hashedPassword: String
  salt: String
  facebook: {}
  google: {}
)

###
# Virtual fields
###
# Password
UserSchema
  .virtual('password')
  .set (password) ->
    @_password = password
    @salt = @makeSalt()
    @hashedPassword = @encryptPassword(password)
  .get ->
    return @_password

###
# Retrieval
###
# Basic info to identify the current authenticated user in the app
UserSchema
  .virtual('userInfo')
  .get ->
    display:   @display || @name || @email
    name:      @name
    email:     @email
    role:      @role
    confirmed: @confirmed

# Public profile information
UserSchema
  .virtual('profile')
 .get ->
   name: @name
   role: @role

###
# Validations
###
# Validate empty email
UserSchema
  .path('email')
  .validate (email) ->
    email.length
  , 'Email cannot be blank'

# Validate empty password
UserSchema
  .path('hashedPassword')
  .validate (hashedPassword) ->
    hashedPassword.length
  , 'Password cannot be blank'

# Validate email is not taken
UserSchema
 .path('email')
 .validate (value, respond) ->
   self = @
   @constructor.findOne { email: value }, (err, user) ->
      throw err if err
      return respond(self.id == user.id) if user
      respond(true)
  , 'The specified email address is already in use.'

###
# Presence validator
###
validatePresenceOf = (value) ->
  value && value.length

###
# Pre-save hook
###
UserSchema
  .pre 'save', (next) ->
    return next() if !@isNew

    if @isNew && !@isConfirmed
      console.log 'Need to confirm this account.'
      return next()

    if !validatePresenceOf(@hashedPassword)
      next new Error('Invalid password')
    else
      next()

###
# Methods
###
UserSchema.methods =
  ###
  # Authenticate - check if the passwords are the same
  #
  # @param {String} plainText
  # @return {Boolean}
  # @api public
  ###
  authenticate: (provider, plainText) ->
    return false if !@hasProvider(provider)
    switch provider
      when 'local'
        @encryptPassword(plainText) == @hashedPassword
      else
        false

  ###
  # hasProvider - check if the user has credentials for the passed provider
  #
  # @param {String} provider
  # @return {Boolean}
  # @api public
  ###
  hasProvider: (provider) ->
    @providers.indexOf(provider) >= 0

  ###
  # Make salt
  #
  # @return {String}
  # @api public
  ###
  makeSalt: ->
    crypto.randomBytes(16).toString 'base64'

  ###
  # isConfirmed
  #
  # @return {Boolean}
  # @api public
  ###
  isConfirmed: ->
    @confirmed

  ###
  # Encrypt password
  #
  # @param {String} password
  # @return {String}
  # @api public
  ###
  encryptPassword: (password) ->
    return '' if !password || !@salt
    salt = new Buffer(@salt, 'base64')
    crypto.pbkdf2Sync(password, salt, 10000, 64).toString 'base64'

module.exports = mongoose.model 'User', UserSchema
