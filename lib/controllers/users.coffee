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

debug 'Configuring users controller...'

# Retrieve our model from mongoose
User = mongoose.model 'User'

###
# User controller
#
# Define the basic CRUD actions for the user resource
###
module.exports = exports =
  ###
  # create
  ###
  create: (req, res, next) ->
    new User()
      .safeAssign req.body
      .save (err, user) ->
        if err
          res.send 400, { error: err.message }
        else

        req.logIn user, (err) ->
          if err
            res.send 400, { error: err.message }
          else
            res.send req.user

  ###
  # show
  ###
  show: (req, res, next) ->
    res.send req.user

  ###
  # update
  #
  # Allows for changing user password.
  ###
  update: (req, res, next) ->
    # TODO: Rewrite this whole thing
    userId = req.user._id
    oldPass = String(req.body.oldPassword)
    newPass = String(req.body.newPassword)

    User.findById userId, (err, user) ->
      if user.authenticate('local', oldPass)
        user.password = newPass
        user.save (err) ->
          return res.send(400, { error: err.message }) if err

          res.send(200)
      else
        res.send(401)

  ###
  # delete
  #
  # Allows a user to delete their account.
  ###
  delete: (req, res, next) ->
    # TODO: Check if password from req matches user
    req.user.remove (err, user) ->
      if err
        res.send 400, { error: err.message }
      else
        req.logOut()
        res.send 200
