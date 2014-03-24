###
# config/env/production.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Production environment setup
###
'use strict'

###
# Production environment
###
module.exports = exports =
  env: 'production'
  mongo:
    uri: 'mongodb://localhost/h_media'
  mailer:
    transport: "SES"
    transportOptions:
      AWSAccessKeyID:   "AWS Access Key (required)"
      AWSSecretKey:     "AWS secret (required)"
      ServiceUrl:       "API end point URL (defaults to https://email.us-east-1.amazonaws.com)"
      AWSSecurityToken: "AWS Security Token (optional)"
