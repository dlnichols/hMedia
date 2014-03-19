###
# Model preloader
###
'use strict'

# External libs
_s   = require('underscore.string')
fs   = require('fs')
path = require('path')

modelsPath = path.join __dirname, 'models'

requireWithContext = (moduleName, context) ->
  return unless moduleName?
  return unless /^(.*)\.(js|coffee)$/.test moduleName
  return unless fs.existsSync(moduleName)
  module = require moduleName
  exportName = _s.capitalize(path.basename(moduleName).split('.')[0])
  context[exportName] = module if context?
  exports[exportName] = module

exports = {}

# Load our models
module.exports = (context) ->
  console.log 'Loading models...'
  files = fs.readdirSync(modelsPath)
  requireWithContext path.join(modelsPath, file), context for file in files
  exports
