'use strict';

/**
 * Custom middleware used by the application
 */
module.exports = {

  /**
   *  Protect routes on your api from unauthenticated access
   */
  auth: function auth(req, res, next) {
    if (req.isAuthenticated()) return next();
    res.send(401);
  },

  /**
   * Set a cookie for angular so it knows we have an http session
   */
  setUserCookie: function(req, res, next) {
    if(req.user) {
      res.cookie('user', JSON.stringify(req.user.userInfo));
    }
    next();
  },

  /**
   * Set a state token
   */
  setStateToken: function(req, res, next) {
    var stateToken = "";
    for (var i = 0;i < 6; i++) {
      stateToken += Math.floor(Math.random()*16777215).toString(16);
    }
    req.session.state = stateToken;
    res.cookie('state', JSON.stringify(stateToken));
    next();
  }
};
