'use strict';

var config         = require('./main');

var mongoose       = require('mongoose'),
    User           = mongoose.model('User');

var passport              = require('passport'),
    LocalStrategy         = require('passport-local').Strategy;

/**
 * Passport configuration
 */
passport.serializeUser(function(user, done) {
  done(null, user.id);
});
passport.deserializeUser(function(id, done) {
  User.findOne({
    _id: id
  }, '-salt -hashedPassword', function(err, user) {
    done(err, user);
  });
});

/**
 * LocalStrategy
 *
 * For authenticating by email and password
 */
passport.use(new LocalStrategy({
    usernameField: 'email',
    passwordField: 'password'
  },
  function(email, password, done) {
    User.findOne({
      email: email
    }, function(err, user) {
      if (err) return done(err);

      if (!user) {
        return done(null, false, {
          message: 'You have entered an incorrect email address.'
        });
      }

      if (!user.authenticate('local', password)) {
        return done(null, false, {
          message: 'You have entered an incorrect password.'
        });
      }
      return done(null, user);
    });
  }
));

module.exports = passport;
