###
# mailer.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# This module configures express-mailer/nodemailer for general use
###
'use strict'

# External libs
_      = require 'lodash'
mailer = require 'nodemailer'
debug  = require('debug') 'hMedia:mailer'

debug 'Configuring mailer...'

# Internal libs
env = require './config/environment'

###
# Mailer extension
###
module.exports = exports = (app) ->
  return if app.mailer

  mailer = {}

  sendMail = (sendOptions, locals, transport, render, callback) ->
    # TODO: Implement stuff

  return
