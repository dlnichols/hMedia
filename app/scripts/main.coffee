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
]

.config ($routeProvider, $locationProvider, $httpProvider) ->
  # Use the HTML5 history API
  $locationProvider.html5Mode true

  # Intercept 401s and redirect you to login
  $httpProvider.interceptors.push ($q, $location) ->
    return responseError: (response) ->
      if response.status == 401
        $location.path '/login'
      $q.reject response
