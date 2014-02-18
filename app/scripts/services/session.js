(function() {
  'use strict';

  angular.module('hMediaApp')
  .factory('session', function ($q, $http, $location, $cookieStore, authentication, user, notifications) {
    // Get currentUser from cookie
    var currentUser = $cookieStore.get('user') || null;
    $cookieStore.remove('user');

    function authSuccess(result) {
      currentUser = result;
    }

    function authLogout() {
      currentUser = null;
    }

    function authFailure(rejection) {
      notifications.send(rejection.data);
    }

    return {
      /**
       * Authenticate user
       *
       * @param  {Object} user - login info
       * @return {Promise}
       */
      login: function(provider, data) {
        switch(provider) {
          case 'local':
            return authentication.save(data, authSuccess, authFailure).$promise;
          default:
            notifications.send({ message: 'Strategy not implemented.' });
            break;
        }
      },

      /**
       * Unauthenticate user
       *
       * @param  {Function} callback - optional
       * @return {Promise}
       */
      logout: function() {
        return authentication.delete(authLogout, authFailure).$promise;
      },

      /**
       * Create account
       *
       * @param {Function} callback - optional
       * @return {Promise}
       */
      createAccount: function(provider, data) {
        switch(provider) {
          case 'local':
            return user.save(data, authSuccess, authFailure).$promise;
          default:
            notifications.send({ message: 'Strategy not implemented.' });
            break;
        }
      },

      /**
       * Gets all available info on authenticated user
       *
       * @return {Object} user
       */
      currentUser: function() {
        return typeof currentUser !== 'undefined' && currentUser !== null ? currentUser.display : void 0;
      },

      /**
       * Simple check to see if a user is logged in
       *
       * @return {Boolean}
       */
      isLoggedIn: function() {
        return !!currentUser;
      },
    };
  });
}());
