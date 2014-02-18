exports.dbPrepare = function(done) {
  'use strict';

  var tasks = 0;

  function finishTask() {
    tasks -= 1;
    if (tasks <= 0) { done(); }
  }

  var path     = require('path'),
      fs       = require('fs'),
      mongoose = require('mongoose');

  // Set default node environment to development
  process.env.NODE_ENV = process.env.NODE_ENV || 'development';

  // Application Config
  var config = require('./config/main');

  // Connect to database
  var db = mongoose.connect(config.mongo.uri, config.mongo.options);

  // Bootstrap models
  var modelsPath = path.join(__dirname, 'models');
  fs.readdirSync(modelsPath).forEach(function (file) {
    if (/(.*)\.(js$|coffee$)/.test(file)) {
      require(modelsPath + '/' + file);
    }
  });

  var User = mongoose.model('User');

  /**
   * Populate database with sample application data
   */

  // Clear old users, then add a default user
  tasks += 1;
  User.find({}).remove(function() {
    User.create({
      providers: [ 'local' ],
      name: 'Test User',
      email: 'test@test.com',
      password: 'test'
    }, function() {
        console.log('Finished populating users.');
        finishTask();
      }
    );
  });
};
