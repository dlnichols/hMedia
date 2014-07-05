###
# scripts/directives/navbar.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
###
'use strict'

angular.module 'hMediaApp'
.controller 'navbarController', ($scope) ->
  # Collapse stuff by default
  $scope.navCollapsed = true

  $scope.toggleMenu = ->
    $scope.navCollapsed = !$scope.navCollapsed
    return

  $scope.collapseMenu = ->
    $scope.navCollapsed = true
    return

  # We are not processing on start up
  $scope.isProcessing = false

  # Populate the menu
  $scope.menu = [
    title: 'Home'
    link : '/'
  ,
    title: 'Settings'
    link : '/settings'
  ]

.directive 'navbar', ->
  restrict:    'E'
  templateUrl: 'partials/navbar'
  controller:  'navbarController'
