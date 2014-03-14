###
# Common environment setup
###
'use strict'

# External libs
path = require('path')

rootPath = path.normalize(__dirname + '/../../..')

module.exports = exports =
  root: rootPath
  port: process.env.PORT || 3000
  mongo:
    options:
      db:
        safe: true
