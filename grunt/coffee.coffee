###
# grunt/coffee.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Define our coffee configuration block for grunt
###
'use strict'

module.exports =
  # Compile Coffee to JS
  files: [
    expand: true
    cwd:    'app/scripts/'
    src:    [ '**/*.coffee' ]
    dest:   '.tmp/scripts/'
    ext:    '.js'
    extDot: 'last'
  ]

  build:
    files: '<%= coffee.files %>'
    options:
      sourceMap: false

  serve:
    files: '<%= coffee.files %>'
    options:
      sourceMap: true
      sourceMapDir: '.tmp/script_maps/'
