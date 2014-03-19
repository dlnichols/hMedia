###
# Users controller
###
'use strict'

# External libs
mongoose = require 'mongoose'
debug    = require('debug') 'hMedia:controllers:user'

# Model
User = mongoose.model 'User'

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
          res.json 400, err
        else

        req.logIn user, (err) ->
          if err
            res.json 400, err
          else
            res.json req.user

  ###
  # show
  ###
  show: (req, res, next) ->
    res.json req.user

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
          return res.send(400) if err

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
        res.json 400, err
      else
        req.logOut()
        res.json 200
