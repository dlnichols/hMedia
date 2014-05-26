###
# bootstrap.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Load mongo, the env, and connect to mongo
# Also, returns the env
###

# External libs
mongoose = require 'mongoose'

# Internal libs
env = require './config/environment'

# Connect to mongoDB
mongoose.connect env.mongo.uri, env.mongo.options unless mongoose.connection.readyState > 0

module.exports = env
