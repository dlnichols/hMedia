###
# grunt/watch.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Define our watch configuration block for grunt
###
'use strict'

module.exports =
  # Watch settings
  # TODO: These need to be updated, they kinda work, but not entirely
  js:
    files: [ 'app/scripts/**/*.js' ]
    tasks: [ 'newer:jshint:serve' ]
    options:
      livereload: true

  coffee:
    files: [ 'app/scripts/**/*.coffee' ]
    tasks: [ 'newer:coffee:serve' ]
    options:
      livereload: true

  compass:
    files: [ 'app/styles/**/*.scss' ]
    tasks: [ 'compass:serve' ]
    options:
      livereload: true

  less:
    files: [ 'app/styles/{,*/}*.less' ]
    tasks: [ 'newer:less:serve' ]
    options:
      livereload: true

  gruntfile:
    files: [ 'Gruntfile.js' ]

  express:
    files: [
      'server.coffee'
      'lib/**/*.coffee'
    ]
    tasks: [
      'express:dev'
      'wait'
    ]
    options:
      livereload: true
      nospawn:    true
