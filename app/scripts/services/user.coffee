###
# scripts/services/user.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
###
'use strict'

angular.module 'hMediaApp'
.factory 'user', ($resource) ->
  $resource '/api/users/:id',
    id: '@id'
  ,
    update:
      method: 'PUT'
      params: {}
