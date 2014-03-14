###
# Environment setup
###
'use strict'

# Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV or 'development'

# External libs
_ = require('lodash')

###
# Load the environment configuration
###
console.log 'Loading environment...'

module.exports = exports = _.extend \
  require('./env/all'),
  require('./env/' + process.env.NODE_ENV) || {}
