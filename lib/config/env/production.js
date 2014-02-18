'use strict';

module.exports = {
  env: 'production',
  mongo: {
    uri: process.env.MONGOLAB_URI ||
         process.env.MONGOHQ_URL ||
         'mongodb://localhost/h_media'
  },
  googlePaths: {
    returnURL: 'https://hm.thenicholsrealm.com/auth/google/callback',
    realm: 'https://hm.thenicholsrealm.com/'
  }
};
