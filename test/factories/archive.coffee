###
# test/factories/archive.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Factory for our User model
###
'use strict'

# Internal libs
Faker   = require 'faker'
Factory = require '../lib/factory'
Archive = require '../../lib/models/archive'

Factory.define 'archive', Archive,
  glacierId: ->
    "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  glacierDescription: ->
    Faker.lorem.paragraph()

module.exports = Factory
