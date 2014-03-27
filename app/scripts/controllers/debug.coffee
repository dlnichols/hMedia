###
# scripts/controllers/debug.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
###
'use strict'

angular.module 'hMediaApp'
.controller 'debugController', ($scope, notifications) ->
  # Define our tabs, this may eventually come from another source
  # Pop some messages to test the notification system
  $scope.debugAlert = ->
    notifications.send message: 'This is a message.'
    notifications.send message: 'This is also a message.', type: 'warning'
    notifications.send message: 'This might not be a message.', type: 'info'
