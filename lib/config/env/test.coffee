###
# config/env/test.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Test environment setup
###
'use strict'

###
# Test environment
###
module.exports = exports =
  env: 'test'
  mongo:
    uri: 'mongodb://localhost/h_media-test'
