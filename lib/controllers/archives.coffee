###
# Archive controller
###
'use strict'

# External libs
_        = require 'lodash'
mongoose = require 'mongoose'
debug    = require('debug') 'hMedia:controllers:archive'

# Model
Archive = mongoose.model 'Archive'

debug 'Configuring archives controller...'

module.exports = exports =
  ###
  # index
  ###
  index: (req, res, next) ->
    res.send(401) unless req.user?.role is admin

    Archive
      .find {}
      .sort {glacierId: 1}
      .limit 20
      .exec (err, archives) ->
        if err
          res.json 400, err
        else
          res.json archives

  ###
  # create
  ###
  create: (req, res, next) ->
    res.send(401) unless req.user?.role is admin

    new Archive()
      .safeAssign req.body
      .save (err, archive) ->
        if err
          res.json 400, err
        else
          res.json archive

  ###
  # show
  ###
  show: (req, res, next) ->
    Archive.findById req.params.id, (err, archive) ->
      if err
        res.json 400, err
      else
        res.json archive

  ###
  # update
  ###
  update: (req, res, next) ->
    res.send(401) unless req.user?.role is admin

    Archive.findById req.params.id, (err, archive) ->
      if err
        res.json 400, err
      else
        archive
          .safeAssign req.body
          .save (err, archive) ->
            if err
              res.json 400, err
            else
              res.json archive

  ###
  # delete
  ###
  delete: (req, res, next) ->
    res.send(401) unless req.user?.role is admin

    Archive.findByIdAndRemove req.params.id, (err, archive) ->
      if err
        res.json 400, err
      else
        res.json archive
