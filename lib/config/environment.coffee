###
# Environment setup
###
'use strict'

# Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV or 'development'
process.env.DEBUG = process.env.DEBUG or 'hMedia:*' if process.env.NODE_ENV == 'development'

# External libs
_     = require('lodash')
debug = require('debug') 'hMedia:environment'

###
# Load the environment configuration
###
debug 'Loading environment...'

module.exports = exports = _.extend \
  require('./env/all'),
  require('./env/' + process.env.NODE_ENV) || {}
