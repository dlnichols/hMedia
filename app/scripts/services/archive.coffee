###
# scripts/services/archive.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
###
'use strict'

angular.module 'hMediaApp'
.factory 'archive', ($resource) ->
  $resource '/api/archives/:id',
    id: '@id'
  ,
    update:
      method: 'PUT'
      params: {}
