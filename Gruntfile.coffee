###
# Gruntfile.js
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Do our grunt work!
###
'use strict'

# Require coffee-script/register so that require uses the project version of
# coffeescript (~1.7) instead of the grunt version (~1.3)
require 'coffee-script/register'

module.exports = (grunt) ->
  _ = require 'lodash'

  # Time how long tasks take to analyze / optimize
  require('time-grunt') grunt

  # Load NPM tasks
  require('jit-grunt') grunt,
    express: 'grunt-express-server'
    useminPrepare: 'grunt-usemin'
    db: 'grunt/database.coffee'

  # Load Grunt config
  # TODO: Fork load-grunt-config and make it JIT for configs?
  gruntConfig = _.extend(
    require('load-grunt-config') grunt,
      loadGruntTasks: false
    require './grunt/custom/min'
  )

  # Define the configuration for all the tasks
  grunt.initConfig gruntConfig

  # Used for delaying livereload until after server has restarted
  grunt.registerTask 'wait', ->
    grunt.log.ok 'Waiting for server reload...'
    done = @async()
    setTimeout (->
      grunt.log.ok 'Done waiting!'
      done()
      return
    ), 1000
    return

  grunt.registerTask 'serve', (target) ->
    grunt.task.run [
      #'concurrent:serve'
      'express:dev'
      'wait'
      'open:serve'
      'watch'
    ]
    null

  grunt.registerTask 'assets', [
    'concurrent:serve'
  ]

  grunt.registerTask 'build', [
    'clean:build'
    'useminPrepare'    # prep concat/*min blocks
    'concurrent:build' # compass/less/coffee+image/svg/htmlmin
    'concat'           # based on usemin block in html
    'ngmin'
    'cssmin'
    'uglify'
    'copy'
    'rev'
    'usemin'
  ]

  grunt.registerTask 'test', [
    'mochaTest'
  ]

  grunt.registerTask 'default', [
  ]

  return
