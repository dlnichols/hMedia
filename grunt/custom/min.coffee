###
# grunt/custom/min.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Define our min configuration block for grunt
###

module.exports =
  # Reads HTML for usemin blocks to enable smart builds that automatically
  # concat, minify and revision files. Creates configurations in memory so
  # additional tasks can operate on them
  useminPrepare:
    html: [ 'app/views/index.html' ]
    options:
      dest: 'dist/public'

  # Performs rewrites based on rev and the useminPrepare configuration
  usemin:
    html: [ 'dist/public/**/*.html' ]
    css:  [ 'dist/public/styles/**/*.css' ]
    options:
      assetsDirs: [ 'dist/public/' ]

  # The following *-min tasks produce minified files in the dist folder
  imagemin: # This should only need to be run on generated images in .tmp
    dynamic:
      files: [
        expand: true
        cwd:  '.tmp/images'
        src:  [ '**/*.{png,jpg,jpeg,gif}' ]
        dest: 'dist/public/images'
      ]
      options:
        cache: false

  svgmin:
    dynamic:
      files: [
        expand: true
        cwd:  'app/images/'
        src:  '**/*.svg'
        dest: 'dist/public/images/'
      ]

  htmlmin:
    build:
      options:
        collapseWhitespace: true
        #collapseBooleanAttributes: true,
        removeCommentsFromCDATA: true
        #removeOptionalTags: true

      files: [
        expand: true
        cwd:  'app/views/'
        src:  '**/*.html'
        dest: 'dist/public/'
      ]

  # Allow the use of non-minsafe AngularJS files. Automatically makes it
  # minsafe compatible so Uglify does not destroy the ng references
  ngmin:
    build:
      files: [
        expand: true
        cwd:  '.tmp/concat/scripts/'
        src:  'application.js'
        dest: '.tmp/concat/scripts/'
      ]
