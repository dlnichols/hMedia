###
# scripts/controllers/navbar.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
###
'use strict'

angular.module 'hMediaApp'
.controller 'navbarController', ($scope, $location, session) ->
  # Not isProcessing logins to start
  $scope.isProcessing = false

  # This holds our login form data
  $scope.user = {}

  # Function to clear the login form
  clearUserInfo = (clearEmail) ->
    delete $scope.user.email if clearEmail
    delete $scope.user.password
    null

  # Grab form data, if valid
  checkFormValidity = (provider, form) ->
    # Preprocess form data to login data
    switch provider
      when 'local'
        if form != null && form != undefined && form.$valid
          $scope.user
        else
          $scope.isProcessing = false
          null
      else
        console.log('checkFormValidity() - No provider given.')

  # Not currently used - Will eventually come from user data
  # and populate the menu
  $scope.menu = [
    title: 'Home'
    link : '/'
  ,
    title: 'Settings'
    link : '/settings'
  ]

  # Check with the session service whether we are logged in
  $scope.isSignedIn = ->
    session.isLoggedIn()

  # Log in via the session service
  $scope.login = (provider, form) ->
    # Disable login / logout buttons
    $scope.isProcessing = true

    # Grab the form data, if valid
    data = checkFormValidity provider, form
    return unless data

    session
      # Attempt to login via session service
      .login provider, data
      # Login successful
      .then ->
        clearUserInfo true
      # Login unsuccessful
      .catch ->
        clearUserInfo()
      # Whether pass or fail, finish processing so buttons are reenabled
      .finally ->
        $scope.isProcessing = false

  # Log out (all methods) and go to root
  $scope.logout = ->
    # Disable login / logout inputs / buttons
    $scope.isProcessing = true

    session
      # Attempt to logout
      .logout()
      # Redirect to root on successful logout
      .then ->
        $location.path '/'
      # We're done isProcessing, so reenable buttons
      .finally ->
        $scope.isProcessing = false

  # Create an account on the server
  $scope.createAccount = (provider, form) ->
    # Disable login / logout buttons
    $scope.isProcessing = true

    # Grab the form data, if valid
    data = checkFormValidity provider, form
    return unless data

    session
      # Attempt to create the account
      .createAccount provider, data
      # Account creation successful
      .then ->
        clearUserInfo true
      # Account creation failed
      .catch ->
        clearUserInfo()
      # Whether pass or fail, finish processing so buttons are reenabled
      .finally ->
        $scope.isProcessing = false

  # Ping the session service for the currentUser
  $scope.currentUser = ->
    session.currentUser()
