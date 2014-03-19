#!node_modules/.bin/coffee

loadLib = (libName, context) ->
  context[libName] = require(libName)

loadEnv = (context) ->
  # Load libraries
  loadLib libName, context for libName in [ "mongoose" ]

  # Load env variables
  context.env = require('./lib/config/environment')

  # Load our models
  require('./lib/models')(context)

  context.perr = (err, model) ->
    console.log "Error!" if err
    console.log err if err
    console.log model if model

  # Connect to mongo
  context.mongoose.connect context.env.mongo.uri, context.env.mongo.options

# Load the repl module
myrepl = require('repl')

# Set custom environment
myrepl.REPLServer.prototype.resetContext = ->
  @context = @createContext()
  loadEnv @context
  @emit('reset', @context)

# Start the REPL
myrepl.start {}
