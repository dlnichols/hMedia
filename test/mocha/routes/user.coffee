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
expect    = require('chai').expect
supertest = require 'supertest'

# Internal libs
app     = require '../../../server'
request = supertest app
LoginAs = require '../../lib/login_as'
Factory = require '../../lib/factory'
User    = require '../../../lib/models/user'

###
# User model test cases
###
describe '(Routes - User)', ->
  user = null

  before ->
    user = Factory.create 'user'

  describe '[XHR Request]', ->
    describe 'POST /user', (done) ->
      describe 'when not authenticated', ->
        it 'should create a new user when given valid attributes', (done) ->
          newUser = Factory.attributesFor 'user'
          request.post '/user'
            .send newUser
            .expect (res) ->
              expect(res.body._id).to.exist
              expect(res.body.hashedPassword).to.not.exist
              expect(res.body.salt).to.not.exist
              return
            .expect 200, done

      describe 'when authenticated', ->
        it 'should return an error', (done) ->
          LoginAs user, 'post', '/user', done, status: 400, (res) ->
            expect(res.body.error).to.eql 'Must be logged out'
            return

    describe 'GET /user', (done) ->
      describe 'when not authenticated', ->
        getUser = null
        beforeEach ->
          getUser = request.get '/user'
            .set 'X-Requested-With', 'XMLHttpRequest'

        it 'should return an error', (done) ->
          getUser
            .expect 'Content-Type', /json/
            .expect 401, error: 'Not logged in', done

      describe 'when authenticated', ->
        it 'should return the user', (done) ->
          LoginAs user, 'get', '/user', done, (res) ->
            expect(res.body._id).to.eql String(user._id)
            return

    describe 'PUT /user', (done) ->
      describe 'when not authenticated', ->
        putUser = null

        beforeEach ->
          putUser = request.put '/user'
            .set 'X-Requested-With', 'XMLHttpRequest'

        it 'should return an error', (done) ->
          putUser
            .expect 'Content-Type', /json/
            .expect 401, error: 'Not logged in', done

      describe 'when authenticated', ->
        it 'should update and return the user', (done) ->
          LoginAs user, 'put', '/user', done, data: user, (res) ->
            expect(res.body._id).to.not.eql user._id
            return

  after (done) ->
    User.remove(done)
