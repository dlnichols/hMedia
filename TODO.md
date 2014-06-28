Tasks for v0.0.1
================
First step in the process is to create a skeleton application that will provide
a good starting point.  This will include basic user functionality, and a basic
resource with all necessary support structure.  At that point, I'll actually
start implementing real features...

Client
------
* Fix login/logout/update to work with the updates to the server code
* Make a way to dynamically create a top menu, based on the current user's role
  than ngInclude)
* tabsetController allows animating in... Animating out will require a bit
  more restructuring... (fixed positioned div? use of $animate and callback?)
* Make notifications fade after a short period of time (5s? 15s?)

Server
------
* Fix watch section of Gruntfile
* Already seeing some non-DRY stuff in models
  * Procedural generation of models?
  * Possible abstraction of validations?
* Add some basic user features
  * User confirmation
  * Lock account on sign in failure attempts
  * Password reset
  * Implement mailer for various e-mails (Amazon SES)
    * Sign up confirmation
    * Sign up confirmed / active
    * Password reset
    * Locked account
