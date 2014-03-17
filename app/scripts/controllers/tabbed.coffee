'use strict'

angular.module 'hMediaApp'
.controller 'tabbedCtrl', ($scope, $location, $routeParams, notifications) ->
  # Define our tabs, this may eventually come from another source
  activeTab = null
  tabs =
    home:
      key:      'home'
      sort:     1
      title:    'Home'
      template: 'partials/welcome'
    readme:
      key:      'readme'
      sort:     2
      title:    'Readme'
      template: 'partials/readme'
    todo:
      key:      'todo'
      sort:     3
      title:    'To Do'
      template: 'partials/todo'

  # Check if the requested section template is available
  if tabs.hasOwnProperty($routeParams.section)
    # and use it, if it is
    activeTab = tabs[$routeParams.section]
  else
    # and use the default, if it is not
    activeTab = tabs.home

  # Provide the current template for ng-include
  $scope.currentTemplate = activeTab.template

  # Provide the list of tabs for use by ng-repeat
  $scope.tabs = _.sortBy tabs, 'sort'

  # Change the subsection template
  # Currently we do this by performing a search, forcing a controller reload
  # which changes the templat that ng-include uses.  This is kind of a hack,
  # causes stuttering, and prevents using animations.  I'll find a better
  # way to do this in the future.
  $scope.changeTab = (newTabKey) ->
    $location.search 'section', newTabKey

  # Tell us whether the tab is the active tab or not
  $scope.isActive = (tab) ->
    if tab == activeTab
      'active'

  # Pop some messages to test the notification system
  $scope.debugAlert = ->
    notifications.send message: 'This is a message.'
    notifications.send message: 'This is also a message.', type: 'warning'
    notifications.send message: 'This might not be a message.', type: 'info'
