'use strict';

module.exports = {
  env: 'development',
  mongo: {
    uri: 'mongodb://localhost/h_media-dev'
  },
  googlePaths: {
    returnURL: 'http://localhost:9000/auth/google/callback',
    realm: 'http://localhost:9000/'
  }
};
