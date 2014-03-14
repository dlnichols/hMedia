###
# Seed
###
'use strict'

# External libs
_        = require('lodash')
fs       = require('fs')
path     = require('path')
mongoose = require('mongoose')

# Internal libs
models = require('./models')

# Models
User = mongoose.model 'User'

# Remove all data
exports.clear = (callback) ->
  console.log 'Clearing database...'
  User.find({}).remove callback
  null

# Reset all data (remove, then populate)
exports.reset = (callback) ->
  console.log 'Resetting database...'
#  exports.clear exports.add_users
  null

# Seed the database
exports.seed = (callback) ->
  console.log 'Populate data...'
  users =
    providers: [ 'local' ]
    name:      'Test User'
    email:     'test@test.com'
    password:  'test'
  User.create users, callback
  null

###
# Prepare the environment
###
prepareEnv = (done) ->
  # Connect to database
  db = mongoose.connect config.mongo.uri, config.mongo.options

  # Task watcher
  tasks = 0

  # Start task
  startTask = (task) ->
    tasks += 1
    task()

  # Finish task
  finishTask = ->
    tasks -= 1
    done() if tasks <= 0

#  startTask () ->
#    data.reset(finishTask)
