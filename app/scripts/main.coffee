'use strict'

angular.module 'hMediaApp', [
  'ngCookies'
  'ngResource'
  'ngSanitize'
  'ngRoute'
  'ngAnimate'
  'ui.bootstrap'
]

.config ($routeProvider, $locationProvider, $httpProvider) ->
  $routeProvider
    .when '/',
      templateUrl: 'partials/main'
      controller: 'tabbedCtrl'
    #.when('/settings', {
    #  templateUrl: 'partials/settings',
    #  controller: 'settingsCtrl',
    #  authenticate: true
    #})
    .otherwise redirectTo: '/'

  # Use the HTML5 history API
  $locationProvider.html5Mode true

  # Intercept 401s and redirect you to login
  $httpProvider.interceptors.push ($q, $location) ->
    return responseError: (response) ->
      if response.status == 401
        $location.path '/login'
        return $q.reject(response)
      else
        return $q.reject(response)

.run ($rootScope, $location, session) ->
  # Redirect to login if route requires auth and you're not logged in
  $rootScope.$on '$routeChangeStart', (event, next) ->
    if next.authenticate && !session.isLoggedIn()
      $location.path '/login'
