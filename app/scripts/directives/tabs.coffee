###
# scripts/directives/style.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
###
'use strict'

angular.module 'hMediaApp'
.controller 'tabsetController', ($scope, $state) ->
  ctrl = @
  tabs = ctrl.tabs = $scope.tabs = []
  ctrl.state = $state

  ctrl.addTab = (tab) ->
    tabs.push tab
    return

  ctrl.removeTab = (tab) ->
    index = tabs.indexOf tab
    tabs.splice index, 1
    return

  return

.directive 'tabset', ->
  restrict: 'EA'
  transclude: true
  replace: true
  scope:
    type: '@'
  controller: 'tabsetController'
  template: '<ul class="nav nav-{{type || \'tabs\'}}" ng-class="{\'nav-stacked\': vertical}" ng-transclude></ul>'
  link: (scope, element, attrs) ->
    scope.vertical = if angular.isDefined(attrs.vertical) then scope.$parent.$eval(attrs.vertical) else false
    return

.directive 'tab', ($parse) ->
  require: '^tabset'
  restrict: 'EA'
  transclude: true
  replace: true
  scope:
    active: '=?'
  controller: ->
  template: '<li ng-class="{active: active(), disabled: disabled}"><a ng-transclude></a></li>'
  compile: (elm, attrs) ->
    (scope, elm, attrs, ctrl) ->
      ctrl.addTab scope
      scope.$on '$destroy', ->
        ctrl.removeTab scope

      scope.active = ->
        attrs.uiSref is ctrl.state.current.name
