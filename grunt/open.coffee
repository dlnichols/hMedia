###
# grunt/open.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Define our open configuration block for grunt
###

# External libs
path = require 'path'

module.exports =
  serve:
    url: 'http://localhost:' + process.env.PORT

  coverage:
    url: path.join __dirname, '..', 'test', 'coverage', 'results.html'
