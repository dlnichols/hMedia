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
  port: process.env.PORT or 3001
  mongo:
    uri: 'mongodb://localhost/h_media-test'
