hMedia
======
A personal project to explore the intricacies of a MEAN stack.  This project
aims to implement a small media server with the usual browse/play features, and
additional features such as long term archival, and on-the-fly transcoding.

Stack
======
MEAN stack: MongoDB, ExpressJS, AngularJS, NodeJS

Test
====
To run tests:
    npm test
which is an alias (in package.json) to
    NODE_ENV=test grunt test

Running tests without the env var will cause it to mess with the dev database.
While this isn't the end of the world, it can cause data loss and the tests
may act funny with existing data.

License
=======
MIT License
Copyright © 2014 Dan Nichols

See LICENSE for further details.
