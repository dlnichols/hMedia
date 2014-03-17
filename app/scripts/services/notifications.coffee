'use strict'

angular.module 'hMediaApp'
.factory 'notifications', ->
  messages = []

  return {
    array: messages,

    send: (message) ->
      if message.type == null || message.type == undefined
        message.type = 'danger'

      if message.title == null || message.title == undefined
        switch message.type
          when 'danger'
            message.title = 'Error:'
          else
            message.title = message.type.replace(/^\w/, (match) ->
              match.toUpperCase()
            ) + ':'

      messages.push message

    remove: (index) ->
      return if index < 0
      return if index > messages.length - 1
      messages.splice(index, 1)
  }
