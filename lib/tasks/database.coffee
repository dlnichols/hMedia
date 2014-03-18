###
# Seed
###
'use strict'

module.exports = (grunt) ->
  # External libs
#  _        = require('lodash')
#  fs       = require('fs')
#  path     = require('path')
  env      = require('../config/environment')
  mongoose = require('mongoose')

  # Internal libs
  models = require('../models')

  # Connect to database
  mongoose.connect(env.mongo.uri, env.mongo.options)

  # Models
  User = mongoose.model 'User'

  ###
  # taskStart
  #
  # A simple function to start an asynchronous task, used in our db:seed task
  # to DRY things up a little
  ###
  taskStart = (context, model, task) ->
    done = context.async()
    grunt.log.ok 'Loading ' + model + ' data.'
    task (err) ->
      taskFinish(done, model, err)

  ###
  # finishTask
  #
  # Called when 
  ###
  taskFinish = (done, model, err) ->
    if err
      grunt.log.error err
    else
      grunt.log.ok 'Done loading ' + model + ' data.'
    done(err)

  ###
  # Task: db:clear
  #
  # Remove all data from the mongodb specified by the environment
  ###
  grunt.registerTask 'db:clear', 'Empty the database', () ->
    # This task is asynchronous
    done = @async()

    # Wait for the db connection to be open
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
    # Get the data to seed
    users = require('../seed/user.json')

    # Seed the users
    taskStart @, 'user', (done) ->
      User.create users, done
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
