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
_         = require 'lodash'
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
          user = Factory.create 'user'
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
          user = Factory.create 'user'
          LoginAs user, 'get', '/user', done, (res) ->
            expect(res.body._id).to.eql String(user._id)
            return

    describe 'PUT /user', ->
      describe 'when not authenticated', ->
        it 'should return an error', (done) ->
          request.put '/user'
            .set 'X-Requested-With', 'XMLHttpRequest'
            .expect 'Content-Type', /json/
            .expect 401, error: 'Not logged in', done

      describe 'when authenticated', ->
        it 'should update and return the user', (done) ->
          user = Factory.create 'user'
          updates = _.extend(user.toObject(),
            _id: 'an_invalid_id'
            password: 'monkeyPass'
            name: 'Monkey Man'
          )
          LoginAs user, 'put', '/user', done, data: updates, (res) ->
            expect(res.body._id).to.not.eql updates._id
            expect(res.body.name).to.eql updates.name
            return

        it 'should return an error if given bad parameters', (done) ->
          user = Factory.create 'user'
          user2 = Factory.create 'user'
          updates = _.extend(user.toObject(),
            _id: 'an_invalid_id'
            password: 'monkeyPass'
            name: 'Monkey Man'
            email: user2.email
          )
          LoginAs user, 'put', '/user', done, status: 400, data: updates, (res) ->
            expect(res.body.error).to.eql 'User validation failed'
            expect(res.body.error_messages).to.exist
            expect(res.body.error_messages).to.have.property 'email'
            expect(res.body.error_messages.email).to.have.property 'message'
            expect(res.body.error_messages.email.message).to.eql 'Email address is already in use'
            expect(res.body.error_messages.email).to.have.property 'path'
            expect(res.body.error_messages.email.path).to.eql 'email'
            return

    describe 'DELETE /user', ->
      describe 'when not authenticated', ->
        it 'should return an error', (done) ->
          request.delete '/user'
            .set 'X-Requested-With', 'XMLHttpRequest'
            .expect 'Content-Type', /json/
            .expect 401, error: 'Not logged in', done

      describe 'when authenticated', ->
        it 'should return an error when not given the correct password', (done) ->
          user = Factory.create 'user'
          LoginAs user, 'delete', '/user', done, status: 401, (res) ->
            expect(res.body.error).to.eql 'Incorrect password'
            return

        it 'should delete the user when given the correct password', (done) ->
          user = Factory.create 'user', password: 'password'
          LoginAs user, 'delete', '/user', done, data: password: user.password, (res) ->
            return

  after (done) ->
    User.remove(done)
