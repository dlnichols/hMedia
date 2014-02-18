(function() {
  'use strict';

  angular.module('hMediaApp')
  .factory('notifications', function() {
    var messages = [];

    return {
      array: messages,

      send: function(message) {
        if (message.type === null || message.type === undefined) {
          message.type = 'danger';
        }

        if (message.title === null || message.title === undefined) {
          switch(message.type) {
            case 'danger':
              message.title = 'Error:';
              break;
            default:
              message.title = message.type.replace(/^\w/, function(match) {
                return match.toUpperCase();
              }) + ':';
              break;
          }
        }

        messages.push(message);
      },

      remove: function(index) {
        if (index < 0) { return; }
        if (index > messages.length - 1) { return; }
        messages.splice(index, 1);
      }
    };
  });
}());
