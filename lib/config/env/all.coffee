###
# config/env/all.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Common environment setup
###
'use strict'

# External libs
path = require 'path'

# Determine our root path from a normalized relative path
rootPath = path.normalize(__dirname + '/../../..')

###
# Common environment
###
module.exports = exports =
  root: rootPath
  port: process.env.PORT or 9000
  mongo:
    options:
      db:
        safe: true
  isDevelopment: ->
    @env == 'development'
  isProduction: ->
    @env == 'production'
  isTest: ->
    @env == 'test'
