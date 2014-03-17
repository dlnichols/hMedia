'use strict'

angular.module 'hMediaApp'
.factory 'authentication', ($resource) ->
  $resource '/auth/'
