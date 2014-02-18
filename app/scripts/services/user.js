(function() {
  'use strict';

  angular.module('hMediaApp')
  .factory('user', function ($resource) {
    return $resource('/api/users/:id', {
      id: '@id'
    }, { //parameters default
      update: {
        method: 'PUT',
        params: {}
      }
    });
  });
}());
