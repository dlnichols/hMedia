###
# Basic controllers
###
'use strict'

# External libs
path = require('path')

console.log 'Configuring basic controllers...'

module.exports = exports =
  ###
  # Partials
  # #
  # This controller handles the /partials
  ###
  partials: (req, res) ->
    stripped = req.url.split('.')[0]
    requestedView = path.join('./', stripped)
    res.render requestedView, (err, html) ->
      if err
        console.log "Error rendering partial '" + requestedView + "'\n", err
        res.status 404
        res.send 404
      else
        res.send html

  ###
  # Index
  # #
  # This controller handles the single page app
  ###
  index: (req, res) ->
    res.render 'index'
