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
  # If app.mailer is defined, then we are reloading and can skip this...
  return if app.mailer

  # Create an empty object
  mailer = {}

  # Function to send e-mail
  sendMail = (sendOptions, locals, transport, render, callback) ->
    # If we don't have a template, invalid call
    return unless sendOptions.hasProperty 'template'

    # Render the e-mail
    render sendOptions.template, locals, (err, html) ->
      # Throw the error if we have one
      callback err if err

      # Set up options
      sendOptions.from    = sendOptions.from    or locals.from
      sendOptions.to      = sendOptions.to      or locals.to
      sendOptions.subject = sendOptions.subject or locals.subject
      sendOptions.html    = html

      sendOptions.generateTextFromHTML = true

      # Send the email
      transport.sendMail sendOptions, (err, res) ->
        if err
          callback err
        else
          callback null, res.message
      return
    return

  createRender = (render) ->
    (sendOptions, locals, callback) ->
      stubTransport = nodemailer.createTransport 'Stub', options unless stubTransport

  return
