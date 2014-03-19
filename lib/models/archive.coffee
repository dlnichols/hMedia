###
# Archive model
###
'use strict'

# External libs
_        = require 'lodash'
mongoose = require 'mongoose'
debug    = require('debug') 'hMedia:models:archive'

debug 'Loading archive model...'

###
# ArchiveSchema
###
ArchiveSchema = new mongoose.Schema(
  glacierId: String
  glacierDescription: String
)

###
# Whitelist mass assignment fields
###
ArchiveSchema.safeFields = [ "glacierId", "glacierDescription" ]

###
# Virtual Fields
###
# Filter for users
ArchiveSchema
  .virtual 'user'
  .get ->
    @

# Filter for admin
ArchiveSchema
  .virtual 'admin'
  .get ->
    @

###
# Validations
###
# Validate glacierId
ArchiveSchema
  .path('glacierId')
  .required true,
    'Glacier ID is required'
  .validate (value) ->
    value?.length == 42
  , 'Glacier ID must be 42?? bytes'
  .validate (value, respond) ->
    self = @
    @constructor.findOne { glacierId: value }, (err, archive) ->
      throw err if err
      return respond(self.id == archive.id) if archive
      respond(true)
  , 'The specified Glacier ID is already in use.'

# Validate glacierDescription
ArchiveSchema
  .path('glacierDescription')
  .required true,
    'Glacier Description cannot be blank'

###
# Methods
###
ArchiveSchema.methods =
  ###
  # safeAssign - only mass assign whitelisted attributes
  #
  # @params {Object} fields
  # @return {Archive} this
  # @api public
  ###
  safeAssign: (fields) ->
    @[key] = value for key, value of _.pick(fields, ArchiveSchema.safeFields)
    @

module.exports = mongoose.model 'Archive', ArchiveSchema
