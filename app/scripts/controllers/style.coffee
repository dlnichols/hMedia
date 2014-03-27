###
# scripts/controllers/style.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
###
'use strict'

angular.module 'hMediaApp'
.constant 'styles',
  isAvailable: (style) ->
    @available.indexOf(style) >= 0
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

.controller 'styleController', ($scope, $cookieStore, styles) ->
  # Grab the style from a cookie (consider using local storage)
  currentStyle = $cookieStore.get('style') || styles.default

  # Check whether the style from the cookie actually exists...
  unless styles.isAvailable currentStyle
    currentStyle = styles.default
    $cookieStore.remove 'style'

  # Set the available styles from our constant
  $scope.styles = styles.available

  # Derive the stylesheet URI from the name
  $scope.currentStylesheet = ->
    '/styles/bootstrap.' + currentStyle.toLowerCase() + '.css'

  # Change the stylesheet when selected from the dropdown
  $scope.changeStyle = (newStyle) ->
    if styles.isAvailable newStyle
      currentStyle = newStyle
      $cookieStore.put 'style', currentStyle
