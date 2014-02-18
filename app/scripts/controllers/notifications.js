(function() {
  'use strict';

  angular.module('hMediaApp')
  .controller('notificationsCtrl', function($scope, notifications) {
    $scope.notices = notifications.array;

    $scope.close = function(index) {
      notifications.remove(index);
    };

    $scope.style = function(type) {
      return 'alert-' + type;
    };
  });
})();
