###
# Seed
###
'use strict'

# Open database
openMongo = (mongoose) ->
  env = require('../config/environment')
  mongoose.connect env.mongo.uri, env.mongo.options unless mongoose.connection.readyState

module.exports = (grunt) ->
  ###
  # Task: db:clear
  #
  # Remove all data from the mongodb specified by the environment
  ###
  grunt.registerTask 'db:clear', 'Empty the database', () ->
    mongoose = require('mongoose')

    openMongo(mongoose)

    # This task is asynchronous
    done = @async()

    # Wait for the db connection to be open (or we'll hang)
    mongoose.connection.on 'open', () ->
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
  grunt.registerTask 'db:seed', 'Seed the database', () ->
    async    = require('async')
    mongoose = require('mongoose')

    openMongo(mongoose)

    models = require('../models')()
    users = require('../seed/users.json')
    archives = require('../seed/archives.json')

    allTasksComplete = @async()
    async.parallel [
      # Seed the users
      (done) ->
        grunt.log.ok 'Loading users...'
        models.User.create users, done

      # Seed the archives
      (done) ->
        grunt.log.ok 'Loading archives...'
        models.Archive.create archives, done
    ], (err) ->
      if err
        grunt.log.error err
      else
        grunt.log.ok 'Done.'
      allTasksComplete(err)
    return

  ###
  # Task: db:reset
  #
  # Clear and then seed the mongodb specified by the environment
  ###
  grunt.registerTask 'db:reset', 'Reset the database', () ->
    grunt.task.run 'db:clear'
    grunt.task.run 'db:seed'
    return
