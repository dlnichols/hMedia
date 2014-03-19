'use strict'

angular.module 'hMediaApp'
.factory 'archive', ($resource) ->
  $resource '/api/archives/:id',
    id: '@id'
  ,
    update:
      method: 'PUT'
      params: {}
