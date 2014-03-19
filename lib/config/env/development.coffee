###
# Development environment setup
###
'use strict'

module.exports = exports =
  env: 'development'
  port: process.env.PORT or 9000
  mongo:
    uri: 'mongodb://localhost/h_media-dev'
