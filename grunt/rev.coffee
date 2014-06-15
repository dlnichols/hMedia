###
# grunt/rev.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Define our rev configuration block for grunt
###
'use strict'

module.exports =
  # Renames files for browser caching purposes
  files:
    src: [ 'dist/public/{scripts,styles,images,fonts}/**/*.*' ]
