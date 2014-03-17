'use strict'

angular.module 'hMediaApp'
.controller 'styleCtrl', ($scope, $cookieStore) ->
  # Grab the style from a cookie (consider using local storage)
  currentStyle = $cookieStore.get('style') || 'Slate'

  # These should be pulled from the API or something
  availableStyles = [
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

  if availableStyles.indexOf(currentStyle) < 0
    currentStyle = 'Slate'
    $cookieStore.remove('style')

  $scope.styles = availableStyles

  $scope.currentStylesheet = ->
    '/styles/bootstrap.' + currentStyle.toLowerCase() + '.css'

  $scope.changeStyle = (newStyle) ->
    if availableStyles.indexOf(newStyle) >= 0
      currentStyle = newStyle
      $cookieStore.put 'style', currentStyle
