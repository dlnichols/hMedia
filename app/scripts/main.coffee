###
# scripts/main.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Here we setup (and execute) our main application.
###
'use strict'

angular.module 'hMediaApp', [
  'ngCookies'
  'ngResource'
  'ngSanitize'
  'ngRoute'
  'ngAnimate'
  'ui.router'
]

.controller 'menuController', ($scope, $state) ->
  $scope.isActive = (state) ->
    state is $state.current.name

.config ($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider) ->
  # Send unmatched URLs to root
  $urlRouterProvider.otherwise '/'

  # Basic application routes
  $stateProvider
    .state 'index',
      abstract:    true
      templateUrl: 'partials/menu'
      controller:  'menuController'
    .state 'index.welcome',
      url:         '/'
      templateUrl: 'partials/menu/welcome'
    .state 'index.dashboard',
      url:         '/dashboard'
      templateUrl: 'partials/menu/dashboard'
    .state 'index.debug',
      url:         '/debug'
      templateUrl: 'partials/menu/debug'
    .state 'auth',
      abstract:    true
      url:         '/auth'
      template:    '<ui-view></ui-view>'
    .state 'auth.sign_in',
      url:         '/sign_in'
      templateUrl: 'partials/auth/sign_in'
    .state 'auth.register',
      url:         '/register'
      templateUrl: 'partials/auth/register'

  # Use the HTML5 history API
  $locationProvider.html5Mode true

  # Intercept 401 and redirect to login
  $httpProvider.interceptors.push ($q, $location) ->
    return responseError: (response) ->
      if response.status == 401
        $location.path '/login'
      $q.reject response
