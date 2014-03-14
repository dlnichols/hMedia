###
# Users controller
###
'use strict'

# External libs
passport = require('passport')
mongoose = require('mongoose')
User     = mongoose.model('User')

console.log 'Configuring users controller...'

module.exports = exports =
  ###
  # Create user
  ###
  create: (req, res, next) ->
    newUser = new User(req.body)
    newUser.save (err) ->
      return res.json(400, err) if err

      req.logIn newUser, (err) ->
        return next(err) if err
        res.json(req.user.userInfo)

  ###
  # Show user
  ###
  show: (req, res, next) ->
    userId = req.params.id

    User.findById userId, (err, user) ->
      return next(err) if err
      return res.send(404) if !user

      res.send \
        profile: user.profile
      null

  ###
  # Change password
  ###
  changePassword: (req, res, next) ->
    userId = req.user._id
    oldPass = String(req.body.oldPassword)
    newPass = String(req.body.newPassword)

    User.findById userId, (err, user) ->
      if user.authenticate(oldPass)
        user.password = newPass
        user.save (err) ->
          return res.send(400) if err

          res.send(200)
      else
        res.send(403)
