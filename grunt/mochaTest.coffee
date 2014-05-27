###
# grunt/mochaTest.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Define our mochaTest configuration block for grunt
###

module.exports =
  test:
    # Run mocha tests
    options:
      reporter: 'spec'
      require: [
        'coffee-script/register'
        'test/coverage/blanket'
      ]
    src: [
      'test/mocha/**/*.coffee'
    ]
  coverage:
    options:
      reporter:    'html-cov'
      quiet:       true
      captureFile: 'test/coverage/results.html'
    src: [
      'test/mocha/**/*.coffee'
    ]
