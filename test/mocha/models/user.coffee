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
should = require('chai').should()

# Internal libs
require '../../../lib/bootstrap'
Factory = require '../../factories/user'
User    = require '../../../lib/models/user'

###
# User model test cases
###
describe 'Model - User', ->
  # Ensure we are in a clean state by removing all users at start
  before (done) ->
    User.remove done

  describe 'Assignment', ->
    it 'should provide a whitelist of attributes', ->
      user = Factory.create('user')
      user.safeAssign invalid: 'attribute'
      should.not.exist user.invalid
      user.isModified().should.be.false

  describe 'Saving/Validation', ->
    it 'should save valid users', (done) ->
      user = Factory.build('user')
      user.save (err) ->
        should.not.exist err
        done()

    it 'should not allow duplicate emails', (done) ->
      user = Factory.build('user', email: 'dupeme@dupe.com')
      dupe = Factory.build('user', email: 'dupeme@dupe.com')
      user.save (err) ->
        should.not.exist err
        dupe.save (err) ->
          should.exist err
          done()

    it 'should not allow blank emails', (done) ->
      user = Factory.build('user', email: '')
      user.save (err) ->
        should.exist err
        done()

  describe 'Confirmation', ->
    it 'should be confirmable', (done) ->
      user = Factory.build('user')
      user.isConfirmed().should.be.false
      user.confirm ->
        user.isConfirmed().should.be.true
        user.isModified().should.be.false
        done()

  # Clean up by removing all users after each test case
  afterEach (done) ->
    User.remove done
