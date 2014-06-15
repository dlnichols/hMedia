###
# test/coverage/blanket.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Wrapper for blanket.js
###
'use strict'

require('blanket')(
  #pattern: /\/h_media\/(test\/lib|lib)\//
  pattern: 'lib'
  loader: './node-loaders/coffee-script'
  'data-cover-never': 'node_modules'
  'data-cover-reporter-options':
    shortnames: true
)
