###
# test/mocha/routes/user.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Integration tests for our User routes
###
'use strict'

# External libs
expect = require('chai').expect

# Internal libs
app     = require '../../../server'
request = require('supertest') app

###
# User model test cases
###
describe 'Routes - User', ->
  describe 'GET /user', (done) ->
    getUser = null
    beforeEach ->
      getUser = request.get '/user'
        .set 'X-Requested-With', 'XMLHttpRequest'

    it 'should return an error when not authenticated', (done) ->
      getUser
        .expect 'Content-Type', /json/
        .expect 401, error: 'Not signed in', done
