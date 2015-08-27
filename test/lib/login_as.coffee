###
# test/lib/login_as.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Test helper to run tests as an authenticated user
###
'use strict'

# External libs
supertest = require 'supertest'

# Internal libs
app = require '../../server'

module.exports = (user, action, url, done, options, test) ->
  if typeof options is 'function'
    test = options
    options = {}

  agent = supertest.agent app
  if user is null
    user = {}
  else
    user = email: user.email, password: user.password
  agent.post '/auth'
    .set 'X-Requested-With', 'XMLHttpRequest'
    .send user
    .expect 200
    .end (err, res) ->
      req = agent[action] url
        .set 'X-Requested-With', 'XMLHttpRequest'
      req.send options.data if options.data
      req
        .expect 'Content-Type', /json/
        .expect test
        .expect options.status or 200, done
