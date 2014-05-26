###
# test/mocha/models/user.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Tests for our User model
###
'use strict'

# External libs
should   = require 'should'
User     = require '../../../lib/models/user'

# Internal libs
env      = require '../../../lib/bootstrap'

###
# User model test cases
###
describe '<Unit Test>', ->
  user = null
  user2 = null

  describe 'Model User:', ->
    before (done) ->
      user = new User(
      )
      user2 = new User(user)
      done()

    describe 'Method Save', ->
      it 'should not have a user to start', (done) ->
        User.find email: 'test@test.com', (err, users) ->
          users.should.have.length 0
          done()

    after (done) ->
      user.remove()
      done()

    null
