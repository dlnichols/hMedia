###
# scripts/directives/style.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
###
'use strict'

angular.module 'hMediaApp'
.constant 'styles',
  default: 'Slate'
  available: [
    'Amelia'
    'Cerulean'
    'Cosmo'
    'Cyborg'
    'Flatly'
    'Journal'
    'Lumen'
    'Readable'
    'Simplex'
    'Slate'
    'Spacelab'
    'Standard'
    'Superhero'
    'United'
    'Yeti'
  ]

.controller 'styleController', ($scope, styles) ->
  # Grab the style from localStorage
  currentStyle = localStorage.style || styles.default

  # Check whether the style actually exists
  isAvailableStyle = (style) ->
    styles.available.indexOf(style) >= 0

  # If it doesn't exist, use the default
  unless isAvailableStyle currentStyle
    currentStyle = styles.default
    localStorage.removeItem 'style'

  # Set the available styles
  $scope.styles = styles.available

  # Derive the stylesheet URI from the name
  $scope.currentStylesheet = ->
    '/styles/bootstrap.' + currentStyle.toLowerCase() + '.css'

  # Change the stylesheet when selected from the dropdown
  $scope.changeStyle = (newStyle) ->
    if isAvailableStyle newStyle
      currentStyle = newStyle
      localStorage.style = newStyle

.directive 'styler', ->
  restrict: 'E'
  template: '\
<ul class="nav navbar-nav">
  <li dropdown>
    <a dropdown-toggle>Themes <b class="caret"></b></a>
    <ul>
      <li ng-repeat="style in styles"><a ng-click="changeStyle(style)">{{style}}</a></li>
    </ul>
  </li>
</ul>'
