###
# controllers/basic.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# This module defines the controllers that handle partials (in development) and
# the main application.
###
'use strict'

# External libs
path  = require 'path'
debug = require('debug') 'hMedia:controllers:basic'

# Internal libs
env = require '../config/environment'

###
# Basic controllers
#
# These are basic GET actions on /partials/* or /*
###
debug 'Configuring basic controllers...'

module.exports = exports =
  ###
  # Partials
  #
  # This controller handles the /partials
  ###
  partials: (req, res, next) ->
    throw { message: "Static content should not be handled by Node in production" } if env.isProduction()
    stripped = req.url.split('.')[0]
    requestedView = path.join('./', stripped)
    res.render requestedView, (err, html) ->
      if err
        debug "Error rendering partial '" + requestedView + "'\n", err
        res.send 404
      else
        res.send html

  ###
  # Index
  #
  # This controller handles the single page app
  ###
  index: (req, res, next) ->
    res.render 'index'

  ###
  # Not Found
  #
  # This controller handles routes that are not found
  ###
  notFound: (req, res, next) ->
    res.send 404
