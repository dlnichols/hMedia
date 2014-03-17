'use strict'

angular.module 'hMediaApp'
.controller 'notificationsCtrl', ($scope, notifications) ->
  $scope.notices = notifications.array

  $scope.close = (index) ->
    notifications.remove(index)

  $scope.style = (type) ->
    'alert-' + type
