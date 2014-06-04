###
# models/user.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# This is our user model.  We define the user's state here, this includes
# identification, authorization, confirmation, creation, and when it was last
# updated.  All the standard user stuff.
###
'use strict'

# External libs
_        = require 'lodash'
mongoose = require 'mongoose'
crypto   = require 'crypto'
debug    = require('debug') 'hMedia:models:user'

# Internal libs
env = require '../config/environment'

###
# User Schema
###
debug 'Loading user model...'

UserSchema = new mongoose.Schema(
  name: String
  email: String
  confirmedEmail: String
  role:
    type   : String
    default: 'guest'
  providers:
    type   : [ String ]
    default: [ 'local' ]
  hashedPassword: String
  salt: String
  createdAt:
    type: Date
    default: Date.now
  confirmedAt:
    type: Date
  updatedAt:
    type: Date
    default: Date.now
)

###
# Whitelisting
###
UserSchema.safeFields = [ 'name', 'email', 'password' ]

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
    if env.isProduction()
      '[Hidden]'
    else
      @_password

# Basic info to identify the current authenticated user in the app
UserSchema
  .virtual 'userInfo'
  .get ->
    __v:       @__v
    _id:       @_id
    email:     @email
    name:      @name
    role:      @role
    providers: @providers
    createdAt: @createdAt
    updatedAt: @updatedAt

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
    @constructor.find $or: [
      { email: value }
      { confirmedEmail: value }
    ], 'email confirmedEmail', (err, users) ->
      throw err if err
      if users.length is 0 # New record, we're good
        respond true
      else # Record found, check if it is the one we are saving
        respond users[0].id is self.id
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
  .path 'confirmedAt'
  # Require confirmation unless the user is new
  .validate (value) ->
    if @isNew
      true
    else
      @isConfirmed()
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
  # safeAssign - only mass assign whitelisted attributes
  #
  # @params {Object} fields
  # @return {User} this
  # @api public
  ###
  safeAssign: (fields) ->
    @[key] = value for key, value of _.pick(fields, UserSchema.safeFields)
    @

  ###
  # authenticate - check if the passwords are the same
  #
  # @param {String} plainText
  # @return {Boolean}
  # @api public
  ###
  authenticate: (plainText) ->
    @encryptPassword(plainText) is @hashedPassword

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
    !!@confirmedAt

  ###
  # confirm
  #
  # @api public
  ###
  confirm: (done) ->
    @confirmedEmail = @email
    @confirmedAt = Date.now()
    @save done

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
