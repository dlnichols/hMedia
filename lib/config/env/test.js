'use strict';

module.exports = {
  env: 'test',
  mongo: {
    uri: 'mongodb://localhost/h_media-test'
  },
  googlePaths: {
    returnURL: 'http://localhost:3000/auth/google/callback',
    realm: 'http://localhost:3000/'
  }
};
