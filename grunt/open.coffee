###
# grunt/open.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Define our open configuration block for grunt
###

module.exports =
  serve:
    url: 'http://localhost:' + process.env.PORT
