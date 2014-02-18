'use strict';

var mongoose = require('mongoose'),
    Schema   = mongoose.Schema,
    crypto   = require('crypto');

var authTypes = [ 'local' ];

/**
 * User Schema
 */
var UserSchema = new Schema({
  display: String,
  name: String,
  email: String,
  role: {
    type   : String,
    default: 'guest'
  },
  confirmed: {
    type   : Boolean,
    default: false
  },
  providers: {
    type   : [],
    default: [ 'local' ]
  },
  hashedPassword: String,
  salt: String,
  facebook: {},
  google: {}
});

/**
 * Virtuals
 */
UserSchema
  .virtual('password')
  .set(function(password) {
    this._password = password;
    this.salt = this.makeSalt();
    this.hashedPassword = this.encryptPassword(password);
  })
  .get(function() {
    return this._password;
  });

// Basic info to identify the current authenticated user in the app
UserSchema
  .virtual('userInfo')
  .get(function() {
    return {
      display:   this.display || this.name || this.email,
      name:      this.name,
      email:     this.email,
      role:      this.role,
      confirmed: this.confirmed
    };
  });

// Public profile information
UserSchema
  .virtual('profile')
  .get(function() {
    return {
      'name': this.name,
      'role': this.role
    };
  });

/**
 * Validations
 */

// Validate empty email
UserSchema
  .path('email')
  .validate(function(email) {
    return email.length;
  }, 'Email cannot be blank');

// Validate empty password
UserSchema
  .path('hashedPassword')
  .validate(function(hashedPassword) {
    return hashedPassword.length;
  }, 'Password cannot be blank');

// Validate email is not taken
UserSchema
  .path('email')
  .validate(function(value, respond) {
    var self = this;
    this.constructor.findOne({email: value}, function(err, user) {
      if(err) throw err;
      if(user) {
        if(self.id === user.id) return respond(true);
        return respond(false);
      }
      respond(true);
    });
  }, 'The specified email address is already in use.');

var validatePresenceOf = function(value) {
  return value && value.length;
};

/**
 * Pre-save hook
 */
UserSchema
  .pre('save', function(next) {
    if (!this.isNew) {
      return next();
    }

    if (this.isNew && !this.isConfirmed) {
      console.log('Need to confirm this account.');
      return next();
    }

    if (!validatePresenceOf(this.hashedPassword)) {
      next(new Error('Invalid password'));
    } else {
      next();
    }
  });

/**
 * Methods
 */
UserSchema.methods = {
  /**
   * Authenticate - check if the passwords are the same
   *
   * @param {String} plainText
   * @return {Boolean}
   * @api public
   */
  authenticate: function(provider, plainText) {
    if (!this.hasProvider(provider)) return false;
    switch(provider) {
      case 'local':
        return this.encryptPassword(plainText) === this.hashedPassword;
      default:
        return false;
    }
  },

  /**
   * hasProvider - check if the user has credentials for the passed provider
   *
   * @param {String} provider
   * @return {Boolean}
   * @api public
   */
  hasProvider: function(provider) {
    return this.providers.indexOf(provider) >= 0;
  },

  /**
   * Make salt
   *
   * @return {String}
   * @api public
   */
  makeSalt: function() {
    return crypto.randomBytes(16).toString('base64');
  },

  /**
   * isConfirmed
   *
   * @return {Boolean}
   * @api public
   */
  isConfirmed: function() {
    return this.confirmed;
  },

  /**
   * Encrypt password
   *
   * @param {String} password
   * @return {String}
   * @api public
   */
  encryptPassword: function(password) {
    if (!password || !this.salt) return '';
    var salt = new Buffer(this.salt, 'base64');
    return crypto.pbkdf2Sync(password, salt, 10000, 64).toString('base64');
  }
};

module.exports = mongoose.model('User', UserSchema);
