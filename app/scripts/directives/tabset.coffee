###
# scripts/directives/tabset.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
###
'use strict'

angular.module 'hMediaApp'
.controller 'tabsetController', ($scope) ->
  self = @
  tabs = self.tabs = $scope.tabs = []

  # select(tab) - Changes the selectedTab
  self.select = (selectedTab) ->
    # Iterate tabs to find the active tab and deactivate it
    angular.forEach tabs, (tab) ->
      if tab.active and tab isnt selectedTab
        tab.active = false
        console.log tab
      return
    # Set the selected tab as active
    selectedTab.active = true
    return

  self.addTab = (newTab) ->
    tabs.push newTab
    if tabs.length is 1
      newTab.active = true
    else if newTab.active
      self.select newTab
    return

  self.removeTab = (tab) ->
    index = tabs.indexOf tab
    if tab.active and tabs.length > 1
      newActiveIndex = if index is tabs.length - 1
        index - 1
      else
        index + 1
      self.select tabs[newActiveIndex]
    tabs.splice index, 1
    return

  return

.directive 'tabset', ->
  restrict:   'EA'
  transclude: true
  replace:    true
  controller: 'tabsetController'
  scope:
    type:     '@'
    vertical: '@'
    src:      '@'
  link: (scope, element, attributes) ->
    scope.vertical = if angular.isDefined attributes.vertical
      scope.$eval attributes.vertical
    else
      false
  template: '\
<div class="row">\
  <div class="col-md-3">\
    <ul class="nav nav-{{type || \'tabs\'}} nav-stacked" ng-class="{ \'nav-stacked\': vertical }" ng-transclude>\
    </ul>\
  </div>\
  <div class="col-md-9 tab-content">\
    <div class="tab-pane"
         ng-repeat="tab in tabs"
         ng-class="{active: tab.active}">\
      <ng-include src="tab.src"></ng-include>\
    </div>\
  </div>\
</div>'

.directive 'tab', ($parse) ->
  restrict:   'EA'
  require:    '^tabset'
  transclude: true
  replace:    true
  scope:
    active:   '=?'
    src:      '@'
  compile: (element, attributes, transclude) ->
    postlink = (scope, element, attributes, controller) ->
      scope.$watch 'active', (active) ->
        controller.select scope if active
        return

      scope.select = ->
        scope.active = true
        return

      controller.addTab scope
      scope.$on '$destroy', ->
        controller.removeTab scope
        return

      scope.$transcludeFn = transclude

      return
  template: '<li ng-class="{ active: active }"><a ng-click="select()" ng-transclude></a></li>'
