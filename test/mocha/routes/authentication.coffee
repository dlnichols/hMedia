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
expect = require('chai').expect

# Internal libs
app       = require '../../../server'
supertest = require 'supertest'
Factory   = require '../../lib/factory'
User      = require '../../../lib/models/user'

debug = require('debug') 'hMedia:test'

###
# User model test cases
###
describe 'Routes - Authentication', ->
  user = undefined
  @timeout 10000

  before ->
    user = Factory.create 'user'

  describe 'POST /auth', ->
    it 'should log in the user', (done) ->
      agent = supertest.agent(app)
      agent.post '/auth'
        .send email: user.email, password: user.password
        .expect 'Content-Type', /json/
        .expect (res) ->
          expect(res.body._id).to.eql String(user._id)
          undefined
        .expect 200, done

  describe 'GET /auth (as XHR)', ->
    it 'should return an empty JSON object when not logged in', (done) ->
      request = supertest(app)
      request.get '/auth'
        .set 'X-Requested-With', 'XMLHttpRequest'
        .expect 'Content-Type', /json/
        .expect 200, {}, done

    it 'should return the user as JSON when logged in', (done) ->
      agent = supertest.agent(app)
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
              undefined
            .expect 200, done

  describe 'DELETE /auth (as XHR)', ->
    it 'should return an error if no user is logged in', (done) ->
      request = supertest(app)
      request.delete '/auth'
        .set 'X-Requested-With', 'XMLHttpRequest'
        .expect 'Content-Type', /json/
        .expect 401, error: 'Not logged in', done

    it 'should log out the user', (done) ->
      agent = supertest.agent(app)
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

  after (done) ->
    User.remove(done)
