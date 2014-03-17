'use strict'

angular.module 'hMediaApp'
.factory 'user', ($resource) ->
  $resource '/api/users/:id',
    id: '@id'
  ,
    update:
      method: 'PUT'
      params: {}
