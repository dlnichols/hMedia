###
# controllers/user.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# This module defines the basic CRUD actions for the user resource, for use in
# our express router.
###
'use strict'

# External libs
mongoose = require 'mongoose'
debug    = require('debug') 'hMedia:controllers:user'

# Retrieve our model from mongoose
User = mongoose.model 'User'

###
# User controller
#
# Define the basic CRUD actions for the user resource
###
debug 'Configuring users controller...'

module.exports = exports =
  ###
  # create
  ###
  create: (req, res, next) ->
    new User()
      .safeAssign req.body
      .save (err, user) ->
        if err
          res.json 400, error: err.message
        else
          req.logIn user, (err) ->
            if err
              res.json 400, error: err.message
            else
              res.json 200, req.user.userInfo

  ###
  # index
  ###
  index: (req, res, next) ->
    res.json 501, error: 'User::Index not implemented.'

  ###
  # show
  ###
  show: (req, res, next) ->
    if req.params.id
      res.json 501, error: 'User::Show(id) not implemented.'
    else
      res.json 200, req.user.userInfo

  ###
  # update
  #
  # Allows for changing user password.
  ###
  update: (req, res, next) ->
    res.json 501, error: 'User::Update not implemented.'

  ###
  # delete
  #
  # Allows a user to delete their account.
  ###
  delete: (req, res, next) ->
    # Check that the user password matches
    unless req.params.password and req.user.authenticate 'local', req.param.password
      return res.json 401, error: 'Incorrect password'

    # Delete the user from the database
    req.user.remove (err, user) ->
      if err
        # Couldn't delete the user
        res.json 400, error: err.message
      else
        # Deleted, log them out
        req.logOut()
        res.json 200
