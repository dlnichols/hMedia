###
# grunt/mochaTest.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Define our mochaTest configuration block for grunt
###

module.exports =
  # Run mocha tests
  options:
    reporter: 'spec'
    require: 'coffee-script/register'
  src: [
    'test/mocha/**/*.coffee'
  ]
