###
# lib/seed/users.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Seed the database with archives
###
'use strict'

# External libs
Async = require 'async'

# Internal libs
Factory = require '../../test/lib/factory'

module.exports = (done, results) ->
  Async.parallel [
    Factory.create.bind null, 'user',
      email:    "test1@test.com"
      password: "test1"
    Factory.create.bind null, 'user',
      email:    "test2@test.com"
      password: "test2"
  ], (err, results) ->
    done(err)
  return
