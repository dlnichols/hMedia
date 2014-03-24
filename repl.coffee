#!node_modules/.bin/coffee

###
# repl.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# A quick little script to configure a REPL with some basic environment for
# exploration of our app.  We load mongoose and all of our models (making them
# available in the context via their model name).  We also provide some
# convenient helper methods.
###

loadLib = (libName, context) ->
  context[libName] = require(libName)

loadEnv = (context) ->
  # Load libraries
  loadLib libName, context for libName in [ "mongoose" ]

  # Load env variables
  context.env = require('./lib/config/environment')

  # Load our models and attach them to the context
  require('./lib/models') context

  # Connect to mongo
  context.mongoose.connect context.env.mongo.uri, context.env.mongo.options

  ###
  # perr
  #
  # Helper method to use as a callback for mongo methods.  It simply prints the
  # returned model or error to the console.
  ###
  context.perr = (err, model) ->
    console.log "Error!" if err
    console.log err if err
    console.log model if model

# Load the repl module
myrepl = require('repl')

# Set custom environment on context reset
myrepl.REPLServer.prototype.resetContext = ->
  @context = @createContext()
  loadEnv @context
  @emit('reset', @context)

# Start the REPL
myrepl.start {}
