###
# User model
###
'use strict'

mongoose = require 'mongoose'
crypto   = require 'crypto'

console.log 'Loading user model...'

###
# User Schema
###
UserSchema = new mongoose.Schema(
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
    type   : [ String ]
    default: [ 'local' ]
  hashedPassword: String
  salt: String
  createdAt:
    type: Date
    default: Date.now
  updatedAt:
    type: Date
    default: Date.now
)

###
# Virtual fields
###
# Password field (hashes password into hashedPassword)
UserSchema
  .virtual 'password'
  .set (password) ->
    @_password = password
    @salt = @makeSalt()
    @hashedPassword = @encryptPassword(password)
  .get ->
    return "[Hidden]"

# Basic info to identify the current authenticated user in the app
UserSchema
  .virtual 'userInfo'
  .get ->
    display:   @display || @name || @email
    role:      @role

###
# Validations
###
# Validate email
UserSchema
  .path 'email'
  .required true,
    'Email address cannot be blank'
  .validate (value, respond) ->
    self = @
    @constructor.findOne { email: value }, (err, user) ->
      throw err if err
      return respond(self.id == user.id) if user
      respond(true)
  , 'Email address is already in use'

# Validate password
UserSchema
  .path 'hashedPassword'
  # Require a password
  .required true,
    'Password cannot be blank'

# Validate role
UserSchema
  .path 'role'
  .match /(guest|user|admin)/,
    'Role must be one of guest, user, or admin'

# Validate confirmed
UserSchema
  .path 'confirmed'
  # Require confirmation unless the user is new
  .validate (value) ->
    if @isNew
      true
    else
      @confirmed
  , 'Confirmation is required'

###
# Pre-save hook
###
UserSchema
  .pre 'save', (next) ->
    # Change updated timestamp
    @updatedAt = Date.now()

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
    crypto.pbkdf2Sync(password, salt, 20000, 64).toString 'base64'

module.exports = mongoose.model 'User', UserSchema
