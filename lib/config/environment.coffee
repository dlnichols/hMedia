###
# config/environment.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# This module configures the environment, and is suitable to be loaded
# independently of any other modules.
###
'use strict'

# Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV or 'development'

# Turn on trace debug by default, if in the development environment
process.env.DEBUG = process.env.DEBUG or 'hMedia:*' if process.env.NODE_ENV == 'development'

# External libs
_     = require('lodash')
debug = require('debug') 'hMedia:environment'

###
# Load the environment configuration
###
debug 'Loading environment...'

exports = _.extend \
  require('./env/all'),
  require('./env/' + process.env.NODE_ENV) || {}

exports.secrets = require('./secrets') exports.env

module.exports = exports
