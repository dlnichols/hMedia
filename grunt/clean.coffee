###
# grunt/clean.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Define our clean configuration block for grunt
###
'use strict'

module.exports =
  build: [
    '.tmp/'
    'dist/'
  ]
  serve: [
    '.tmp/'
  ]
