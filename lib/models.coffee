###
# models.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# This module preloads our Mongoose models, and allows exporting them to an
# object.  This saves us having to require every model individually.
###
'use strict'

# External libs
_s    = require 'underscore.string'
fs    = require 'fs'
path  = require 'path'
debug = require('debug') 'hMedia:models'

modelsPath = path.join __dirname, 'models'

###
# requireWithContext
#
# Take a filename, convert it to a string useable by require, and require the
# module.  If given a context, export each model to a property on the context
# object.  Also add the model to the module exports.
###
requireWithContext = (moduleName, context) ->
  return unless moduleName?
  return unless /^(.*)\.(js|coffee)$/.test moduleName
  return unless fs.existsSync(moduleName)
  module = require moduleName
  exportName = _s.capitalize(path.basename(moduleName).split('.')[0])
  debug 'Loading ' + exportName + ' from ' + moduleName + '...'
  context[exportName] = module if context?
  exports[exportName] = module

exports = {}

###
# Load our models
###
module.exports = (context) ->
  debug 'Loading models...'
  files = fs.readdirSync(modelsPath)
  requireWithContext path.join(modelsPath, file), context for file in files
  exports
