(function() {
  'use strict';

  angular.module('hMediaApp')
  .factory('authentication', function ($resource) {
    return $resource('/auth/');
  });
}());
