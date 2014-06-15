###
# grunt/database.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Define our database configuration block for grunt
###
'use strict'

# External libs
mongoose = require 'mongoose'
debug    = require('debug') 'hMedia:grunt:database'

###
# openMongo
#
# Open database (if it isn't already)
###
openMongo = () ->
  env = require '../lib/config/environment'
  mongoose.connect env.mongo.uri, env.mongo.options unless mongoose.connection.readyState

###
# Grunt database tasks
###
debug 'Configuring grunt database tasks...'

module.exports = (grunt) ->
  ###
  # Task: db:clear
  #
  # Remove all data from the mongodb specified by the environment
  ###
  grunt.registerTask 'db:clear', 'Empty the database', () ->
    openMongo()

    # This task is asynchronous
    done = @async()

    # Wait for the db connection to be open (or we'll hang)
    mongoose.connection.on 'open', ->
      # Drop the database
      mongoose.connection.db.dropDatabase (err) ->
        if err
          grunt.log.error 'Unable to clear database.'
        else
          grunt.log.ok 'Database cleared.'
        done(err)
    return

  ###
  # Task: db:seed
  #
  # Seed the mongodb specified by the environment
  ###
  grunt.registerTask 'db:seed', 'Seed the database', ->
    _     = require 'lodash'
    fs    = require 'fs'
    path  = require 'path'
    Async = require 'async'

    openMongo()

    done = @async()

    # Read seed filenames
    seedPath = path.join __dirname, '..', 'lib', 'seed'
    seedFiles = fs.readdirSync(seedPath).map (seedFile) ->
      seedFile.replace /.(js|coffee|json)$/, ""

    # Require seeds
    seedReqs = seedFiles.map (seedFile) ->
      require path.join(__dirname, '..', 'lib', 'seed', seedFile)
    seeds = _.zipObject seedFiles, seedReqs

    # Seed the database
    Async.auto seeds, (err, result) ->
      grunt.log.error err if err
      done(err)
      return

    return

  ###
  # Task: db:reset
  #
  # Clear and then seed the mongodb specified by the environment
  ###
  grunt.registerTask 'db:reset', 'Reset the database', [
    'db:clear'
    'db:seed'
  ]

  grunt.registerTask 'db', [ 'db:reset' ]
