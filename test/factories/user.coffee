###
# test/factories/user.coffee
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
User    = require '../../lib/models/user'

emailCounter = 1

Factory.define 'user', User,
  name: 'Full name'
  email: ->
    'test' + emailCounter++ + '@test.com'
  password: ->
    Faker.lorem.words().join ''
  providers: [ 'local' ]
  role: 'guest'

module.exports = Factory
