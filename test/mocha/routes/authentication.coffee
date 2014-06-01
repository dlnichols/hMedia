###
# test/mocha/routes/authentication.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Integration tests for our Authentication routes
###
'use strict'

# External libs
expect    = require('chai').expect
supertest = require 'supertest'

# Internal libs
app       = require '../../../server'
request   = supertest app
Factory   = require '../../lib/factory'
User      = require '../../../lib/models/user'

###
# User model test cases
###
describe '(Routes - Authentication)', ->
  # Define user here so it can used in all our test cases
  user = null

  before ->
    # Create our user to log in and out
    user = Factory.create 'user'

  describe '[XHR Request]', ->
    describe 'POST /auth', ->
      describe 'when not authenticated', ->
        it 'should log in the user', (done) ->
          agent = supertest.agent app
          agent.post '/auth'
            .set 'X-Requested-With', 'XMLHttpRequest'
            .send email: user.email, password: user.password
            .expect 'Content-Type', /json/
            .expect (res) ->
              expect(res.body._id).to.eql String(user._id)
              return
            .expect 200, done

      describe 'when authenticated', ->
        it 'should log in the new user', (done) ->
          user2 = Factory.create 'user'
          agent = supertest.agent app
          agent.post '/auth'
            .set 'X-Requested-With', 'XMLHttpRequest'
            .send email: user.email, password: user.password
            .expect 'Content-Type', /json/
            .expect 200
            .end (err, res) ->
              agent.post '/auth'
                .set 'X-Requested-With', 'XMLHttpRequest'
                .send email: user2.email, password: user2.password
                .expect 'Content-Type', /json/
                .expect (res) ->
                  expect(res.body._id).to.eql String(user2._id)
                  return
                .expect 200, done

    describe 'GET /auth', ->
      describe 'when not authenticated', ->
        it 'should return an empty JSON object', (done) ->
          request.get '/auth'
            .set 'X-Requested-With', 'XMLHttpRequest'
            .expect 'Content-Type', /json/
            .expect 200, {}, done

      describe 'when authenticated', ->
        it 'should return the user as JSON', (done) ->
          agent = supertest.agent app
          agent.post '/auth'
            .set 'X-Requested-With', 'XMLHttpRequest'
            .send email: user.email, password: user.password
            .expect 'Content-Type', /json/
            .expect 200
            .end (err, res) ->
              agent.get '/auth'
                .set 'X-Requested-With', 'XMLHttpRequest'
                .expect 'Content-Type', /json/
                .expect (res) ->
                  expect(res.body._id).to.eql String(user._id)
                  return
                .expect 200, done

    describe 'DELETE /auth', ->
      describe 'when not authenticated', ->
        it 'should return 200 with a redirect', (done) ->
          request.delete '/auth'
            .set 'X-Requested-With', 'XMLHttpRequest'
            .expect 'Content-Type', /json/
            .expect 200, redirect: '/', done

      describe 'when authenticated', ->
        it 'should log out the user', (done) ->
          agent = supertest.agent app
          agent.post '/auth'
            .set 'X-Requested-With', 'XMLHttpRequest'
            .send email: user.email, password: user.password
            .expect 'Content-Type', /json/
            .expect 200
            .end (err, res) ->
              agent.delete '/auth'
                .set 'X-Requested-With', 'XMLHttpRequest'
                .expect 'Content-Type', /json/
                .expect 200, redirect: '/', done

  # Clean up
  after (done) ->
    User.remove(done)
