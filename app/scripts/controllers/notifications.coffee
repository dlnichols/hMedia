###
# scripts/controllers/notifications.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
###
'use strict'

angular.module 'hMediaApp'
.controller 'notificationsController', ($scope, notifications) ->
  $scope.notices = notifications.array

  $scope.close = (index) ->
    notifications.remove(index)

  $scope.style = (type) ->
    'alert-' + type

  return
