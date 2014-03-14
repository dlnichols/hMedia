###
# Production environment setup
###
'use strict'

module.exports = exports =
  env: 'production'
  mongo:
    uri: process.env.MONGOLAB_URI ||
         process.env.MONGOHQ_URL ||
         'mongodb://localhost/h_media'
