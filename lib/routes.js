'use strict';

var index          = require('./controllers'),
    users          = require('./controllers/users'),
    passport       = require('passport'),
    authentication = require('./controllers/authentication');

var middleware = require('./middleware');

/**
 * Application routes
 */
module.exports = function(app) {
  // Server API Routes
  app.post('/api/users', users.create        );
  app.put ('/api/users', users.changePassword);
  app.get ('/api/users', users.show          );

  // All undefined api routes should return a 404
  app.get ('/api/*', function(req, res) { res.send(404); });

  // Authentication routing
  app.post('/auth',          authentication.login   );
  app.del ('/auth',          authentication.logout  );

  // Return 404 when partials or styles requested are not found
  app.get ('/partials/*',    index.partials);
  app.get ('/styles/*', function(req, res) { res.send(404); });
  app.get ('/images/*', function(req, res) { res.send(404); });

  // All other routes to use Angular routing in app/scripts/app.js
  app.get ('/*',          middleware.setUserCookie, middleware.setStateToken, index.index);
};
