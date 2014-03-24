###
# config/env/development.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Development environment configuration details
###
'use strict'

###
# Development environment
###
module.exports = exports =
  env: 'development'
  mongo:
    uri: 'mongodb://localhost/h_media-dev'
