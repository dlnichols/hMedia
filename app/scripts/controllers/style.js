(function() {
  'use strict';

  angular.module('hMediaApp')
  .controller('styleCtrl', function($scope, $cookieStore) {
    var currentStyle    = $cookieStore.get('style') || 'Slate',
        // These should be pulled from the API
        availableStyles = [ 'Amelia',
                            'Cerulean',
                            'Cosmo',
                            'Cyborg',
                            'Flatly',
                            'Journal',
                            'Lumen',
                            'Readable',
                            'Simplex',
                            'Slate',
                            'Spacelab',
                            'Standard',
                            'Superhero',
                            'United',
                            'Yeti' ];

    if (availableStyles.indexOf(currentStyle) < 0) {
      currentStyle = 'Slate';
      $cookieStore.remove('style');
    }

    $scope.styles = availableStyles;

    $scope.currentStylesheet = function() {
      return '/styles/bootstrap.' + currentStyle.toLowerCase() + '.css';
    };

    $scope.changeStyle = function(newStyle) {
      if (availableStyles.indexOf(newStyle) >= 0) {
        currentStyle = newStyle;
        $cookieStore.put('style', currentStyle);
      }
    };
  });
})();
