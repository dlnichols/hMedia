'use strict'

angular.module('hMediaApp')
.factory 'session', ($q, $http, $location, $cookieStore, authentication, user, notifications) ->
  # Get currentUser from cookie
  currentUser = $cookieStore.get('user') || null
  $cookieStore.remove 'user'

  authSuccess = (result) ->
    currentUser = result

  authLogout = ->
    currentUser = null

  authFailure = (rejection) ->
    notifications.send rejection.data

  return {
    ###
    # Authenticate user
    #
    # @param  {Object} user - login info
    # @return {Promise}
    ###
    login: (provider, data) ->
      switch provider
        when 'local'
          authentication.save(data, authSuccess, authFailure).$promise
        else
          notifications.send({ message: 'Strategy not implemented.' })

    ###
    # Unauthenticate user
    #
    # @param  {Function} callback - optional
    # @return {Promise}
    ###
    logout: ->
      return authentication.delete(authLogout, authFailure).$promise

    ###
    # Create account
    #
    # @param {Function} callback - optional
    # @return {Promise}
    ###
    createAccount: (provider, data) ->
      switch provider
        when 'local'
          user.save(data, authSuccess, authFailure).$promise
        else
          notifications.send({ message: 'Strategy not implemented.' })

    ###
    # Gets all available info on authenticated user
    #
    # @return {Object} user
    ###
    currentUser: ->
      currentUser?.display

    ###
    # Simple check to see if a user is logged in
    #
    # @return {Boolean}
    ###
    isLoggedIn: ->
      !!currentUser
  }
