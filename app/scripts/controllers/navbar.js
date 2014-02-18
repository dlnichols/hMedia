(function() {
  'use strict';

  angular.module('hMediaApp')
  .controller('navbarCtrl', function ($scope, $location, session) {
    // Not isProcessing logins to start
    $scope.isProcessing = false;

    // This holds our login form data
    $scope.user = {};

    // Function to clear the login form
    function clearUserInfo(clearEmail) {
      if (clearEmail) { delete $scope.user.email; }
      delete $scope.user.password;
    }

    // Grab form data, if valid
    function checkFormValidity(provider, form) {
      // Preprocess form data to login data
      switch(provider) {
        case 'local':
          if (form !== null && form !== undefined && form.$valid) {
            return $scope.user;
          } else {
            $scope.isProcessing = false;
            return;
          }
          break;
        default:
          console.log('checkFormValidity() - No provider given.');
          return;
      }
    }

    // Not currently used - Will eventually come from user data
    // and populate the menu
    $scope.menu = [{
      title: 'Home',
      link : '/'
    }, {
      title: 'Settings',
      link : '/settings'
    }];

    // Check with the session service whether we are logged in
    $scope.isSignedIn = function() {
      return session.isLoggedIn();
    };

    // Log in via the session service
    $scope.login = function(provider, form) {
      // Disable login / logout buttons
      $scope.isProcessing = true;

      // Grab the form data, if valid
      var data = checkFormValidity(provider, form);
      if (!data) { return; }

      session
        // Attempt to login via session service
        .login(provider, data)
        // Login successful
        .then(function() { clearUserInfo(true); })
        // Login unsuccessful
        .catch(function() { clearUserInfo(); })
        // Whether pass or fail, finish processing so buttons are reenabled
        .finally(function() { $scope.isProcessing = false; });
    };

    // Log out (all methods) and go to root
    $scope.logout = function() {
      // Disable login / logout inputs / buttons
      $scope.isProcessing = true;

      session
        // Attempt to logout
        .logout()
        // Redirect to root on successful logout
        .then(function() { $location.path('/'); })
        // We're done isProcessing, so reenable buttons
        .finally(function() { $scope.isProcessing = false; });
    };

    // Create an account on the server
    $scope.createAccount = function(provider, form) {
      // Disable login / logout buttons
      $scope.isProcessing = true;

      // Grab the form data, if valid
      var data = checkFormValidity(provider, form);
      if (!data) { return; }

      session
        // Attempt to create the account
        .createAccount(provider, data)
        // Account creation successful
        .then(function() { clearUserInfo(true); })
        // Account creation failed
        .catch(function() { clearUserInfo(); })
        // Whether pass or fail, finish processing so buttons are reenabled
        .finally(function() { $scope.isProcessing = false; });
    };

    // Ping the session service for the currentUser
    $scope.currentUser = function() {
      return session.currentUser();
    };

    $scope.testDisabled = function() {
      $scope.isProcessing = !$scope.isProcessing;
    };
  });
}());
