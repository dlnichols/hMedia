###
# Archive controller
###
'use strict'

# External libs
passport = require 'passport'
mongoose = require 'mongoose'

# Model
Archive = mongoose.model 'Archive'

console.log 'Configuring archives controller...'

module.exports = exports =
  ###
  # index
  ###
  index: (req, res, next) ->
    Archive
      .find()
      .sort {glacierId: 1}
      .limit 20
      .exec (err, archives) ->
        console.log archives
        if err
          next(err)
        else
          res.json(archives)

  ###
  # create
  ###
  create: (req, res, next) ->
    res.send(401) unless req.user.role is admin

    newArchive = new Archive(req.body)
    newArchive.save (err, archive) ->
      return next(err) if err

      res.json(archive[req.user.role])

  ###
  # show
  ###
  show: (req, res, next) ->
    console.log "Params:" + req.params.id
    console.log "Obj:" + req.archive._id
    archiveId = req.params.id

    Archive.findById archiveId, (err, archive) ->
      return next(err) if err

      res.send archive

  ###
  # update
  ###
  update: (req, res, next) ->
    res.send(403)

  ###
  # delete
  ###
  delete: (req, res, next) ->
    res.send(403)
