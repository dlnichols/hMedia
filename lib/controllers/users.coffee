###
# Users controller
###
'use strict'

# External libs
passport = require 'passport'
mongoose = require 'mongoose'

# Model
User = mongoose.model 'User'

console.log 'Configuring users controller...'

module.exports = exports =
  ###
  # create
  ###
  create: (req, res, next) ->
    newUser = new User(req.body)
    newUser.save (err) ->
      return res.json(400, err) if err

      req.logIn newUser, (err) ->
        return next(err) if err
        res.json(req.user.userInfo)

  ###
  # show
  ###
  show: (req, res, next) ->
    res.json(404)

  ###
  # update
  #
  # Allows for changing user password.
  ###
  update: (req, res, next) ->
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
  #  console.log req.user
  #  userId = req.user._id
  #  password = String(req.body.password)

  #  User.findById userId, (err, user) ->
  #    if user.authenticate(password)

    res.send(403)
