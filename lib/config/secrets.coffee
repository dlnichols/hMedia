###
# config/secrets.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# This module loads and merges all JSON in the secrets folder and places them
# in the env for the application to use
###
'use strict'

# External libs
_ = require 'lodash'
fs = require 'fs'
path = require 'path'
debug = require('debug') 'hMedia:secrets'

secretsPath = path.join __dirname, 'secrets'

###
# requireSecret
###
requireSecret = (secretName, secrets, environment) ->
  return unless secretName?
  return unless /^(.*)\.(json)$/.test secretName
  return unless fs.existsSync(secretName)
  secret = require secretName
  secrets = _.extend secrets, secret[environment]

###
# Load our secrets
###
module.exports = (environment) ->
  return unless environment?
  secrets = {}
  debug 'Loading secrets...'
  files = fs.readdirSync(secretsPath)
  requireSecret path.join(secretsPath, file), secrets, environment for file in files
  secrets
