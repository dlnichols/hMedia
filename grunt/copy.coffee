###
# grunt/copy.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Define our copy configuration block for grunt
###
'use strict'

module.exports =
  # Copy pre-processed files from app to dist
  lib:
    files: [
      expand: true
      src: [
        'server.coffee'
        'lib/**/*'
      ]
      dest: 'dist/'
    ]

  images:
    files: [
      expand: true
      cwd:  'app/images/'
      src:  '**/*'
      dest: 'dist/public/images/'
    ]
