###
# controllers/archive.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# This module defines the CRUD actions on the archive resource, for use in our
# express router.
###
'use strict'

# External libs
_        = require 'lodash'
mongoose = require 'mongoose'
debug    = require('debug') 'hMedia:controllers:archive'

# Retrieve our model from mongoose
Archive = mongoose.model 'Archive'

###
# Archive controller
#
# Define the basic CRUD actions for the archive resource
###
debug 'Configuring archives controller...'

module.exports = exports =
  ###
  # index
  ###
  index: (req, res, next) ->
    Archive
      .find {}
      .sort {glacierId: 1}
      .limit 20
      .exec (err, archives) ->
        return next(err) if err
        res.send archives || []

  ###
  # create
  ###
  create: (req, res, next) ->
    new Archive()
      .safeAssign req.body
      .save (err, archive) ->
        return next(err) if err
        res.send archive

  ###
  # show
  ###
  show: (req, res, next) ->
    Archive.findById req.params.id, (err, archive) ->
      return next(err) if err
      res.send archive

  ###
  # update
  ###
  update: (req, res, next) ->
    Archive.findById req.params.id, (err, archive) ->
      return next(err) if err
      archive
        .safeAssign req.body
        .save (err, archive) ->
          return next(err) if err
          res.send archive

  ###
  # delete
  ###
  delete: (req, res, next) ->
    Archive.findByIdAndRemove req.params.id, (err, archive) ->
      return next(err) if err
      res.send archive
