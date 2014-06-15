###
# lib/seed/archives.coffee
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

module.exports = [
  'users'
  (done, results) ->
    Async.parallel [
      Factory.create.bind null, 'archive'
#     Factory.create.bind null, 'archive'
    ], (err, results) ->
      done(err)
    return
]
