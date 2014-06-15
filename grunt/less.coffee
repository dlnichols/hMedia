###
# grunt/less.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Define our less configuration block for grunt
###
'use strict'

module.exports =
  # Compile LESS to CSS
  build:
    files: [
      expand: true
      cwd:    'app/styles/'
      src:    [ '*.less' ]
      dest:   '.tmp/styles/'
      ext:    '.css'
      extDot: 'last'
    ]
    options:
      sourceMap: false

  serve:
    files: [
      expand: true
      cwd:    'app/styles/'
      src:    [ '*.less' ]
      dest:   '.tmp/styles/'
      ext:    '.css'
      extDot: 'last'
    ]
    options:
      sourceMap: true
      sourceMapFilename: ''
      sourceMapBasepath: ''
      sourceMapRootpath: '/'
