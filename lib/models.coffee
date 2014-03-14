###
# Model preloader
###
'use strict'

# External libs
fs   = require('fs')
path = require('path')

# Load our models (can access them via mongoose)
console.log 'Loading models...'

modelsPath = path.join __dirname, 'models'
fs.readdirSync(modelsPath).forEach (file) ->
  require path.join(modelsPath, file) if /(.*)\.(js$|coffee$)/.test(file)
  null
