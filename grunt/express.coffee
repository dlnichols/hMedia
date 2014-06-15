###
# grunt/express.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Define our express configuration block for grunt
###
'use strict'

# Internal libs
env = require '../lib/config/environment'

module.exports =
  # Common options - Start our app with coffee
  options:
    port: env.port
    opts: [ './node_modules/.bin/coffee' ]

  # Dev options - Set dev env and debug vars
  dev:
    options:
      script:   'server.coffee'
      debug:    true
      node_env: 'development'

  # Prod options - Set prod env and no debug
  prod:
    options:
      script:   'dist/server.coffee'
      debug:    false
      node_env: 'production'
