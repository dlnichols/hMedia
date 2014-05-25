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

debug 'Configuring archives controller...'

# Retrieve our model from mongoose
Archive = mongoose.model 'Archive'

###
# Archive controller
#
# Define the basic CRUD actions for the archive resource
###
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
        if err
          next err
        else
          res.send archives || []

  ###
  # create
  ###
  create: (req, res, next) ->
    new Archive()
      .safeAssign req.body
      .save (err, archive) ->
        if err
          next err
        else
          res.send archive

  ###
  # show
  ###
  show: (req, res, next) ->
    Archive.findById req.params.id, (err, archive) ->
      if err
        next err
      else
        if archive
          res.send archive
        else
          res.send 404

  ###
  # update
  ###
  update: (req, res, next) ->
    Archive.findById req.params.id, (err, archive) ->
      if err
        next err
      else
        archive
          .safeAssign req.body
          .save (err, archive) ->
            if err
              next err
            else
              res.send archive

  ###
  # delete
  ###
  delete: (req, res, next) ->
    Archive.findByIdAndRemove req.params.id, (err, archive) ->
      if err
        next err
      else
        if archive
          res.send archive
        else
          res.send 404
