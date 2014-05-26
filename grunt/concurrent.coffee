###
# grunt/concurrent.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Define our concurrent configuration block for grunt
###

module.exports =
  # Run some tasks in parallel to speed up the build process
  build: [
    'compass:build'
    'newer:less:build'
    'newer:coffee:build'
    'copy'
    'htmlmin'
  ]
  serve: [
    'compass:serve'
    'newer:less:serve'
    'newer:coffee:serve'
  ]
