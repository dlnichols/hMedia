'use strict'

# Require coffee-script/register so that require uses the project version of
# coffeescript (~1.7) instead of the grunt version (~1.3)
require 'coffee-script/register'

module.exports = (grunt) ->
  # Load our environment settings
  env = require './lib/config/environment'

  # Time how long tasks take to analyze / optimize
  require('time-grunt') grunt

  # Load NPM tasks
  require('load-grunt-tasks') grunt

  # Load custom tasks
  require('./lib/tasks/database') grunt

  # Define the configuration for all the tasks
  grunt.initConfig

    # Project settings
    yeoman:
      app:     'app/'
      lib:     'lib/'
      tmp:     '.tmp/'
      dist:    'dist/'

    # Express settings
    express:
      # Common options - Start our app with coffee
      options:
        port: env.port
        opts: [ './node_modules/.bin/coffee' ]

      # Dev options - Set dev env and debug vars
      dev:
        options:
          script:   'server.coffee'
          debug:    true
          node_env: 'development'

      # Prod options - Set prod env and no debug
      prod:
        options:
          script:   'dist/server.coffee'
          debug:    false
          node_env: 'production'

    # Command to open the browser
    open:
      serve:
        url: 'http://localhost:' + env.port

    # Watch settings - WIP
    watch:
      js:
        files: [ '<%= yeoman.app %>/scripts/**/*.js' ]
        tasks: [ 'newer:jshint:serve' ]
        options:
          livereload: true

      coffee:
        files: [ '<%= yeoman.app %>/scripts/**/*.coffee' ]
        tasks: [ 'newer:coffee:serve' ]
        options:
          livereload: true

      compass:
        files: [ '<%= yeoman.app %>/styles/**/*.scss' ]
        tasks: [ 'compass:serve' ]
        options:
          livereload: true

      less:
        files: [ '<%= yeoman.app %>/styles/{,*/}*.less' ]
        tasks: [ 'newer:less:serve' ]
        options:
          livereload: true

      gruntfile:
        files: [ 'Gruntfile.js' ]

      express:
        files: [
          'server.coffee'
          'lib/**/*.coffee'
        ]
        tasks: [
          'express:dev'
          'wait'
        ]
        options:
          livereload: true
          nospawn:    true

    # Clean things up
    clean:
      build:  [
        '<%= yeoman.tmp %>'
        '<%= yeoman.dist %>'
      ]

      serve: [
        '<%= yeoman.tmp %>'
      ]

    # Compiles Sass to CSS
    compass:
      options:
        sassDir:                 '<%= yeoman.app %>/styles/'
        imagesDir:               '<%= yeoman.app %>/images/'
        javascriptsDir:          '<%= yeoman.app %>/scripts/'
        fontsDir:                '<%= yeoman.app %>/fonts/'
        importPath:              '<%= yeoman.app %>/bower_components/'
        cssDir:                  '.tmp/styles/'
        generatedImagesDir:      '.tmp/images/generated/'
        httpImagesPath:          '/images/'
        httpGeneratedImagesPath: '/images/generated/'
        httpFontsPath:           '/styles/fonts/'
        relativeAssets:          false
        assetCacheBuster:        false
        raw:                     'Sass::Script::Number.precision = 10\n'

      build:
        options:
          generatedImagesDir: '<%= yeoman.dist %>/public/images/generated/'

      serve:
        options:
          debugInfo: true

    # Compile LESS to CSS
    less:
      build:
        files: [
          expand: true
          cwd:    'app/styles/'
          src:    [ '*.less' ]
          dest:   '.tmp/styles/'
          ext:    '.css'
          extDot: 'last'
        ]
        options:
          sourceMap: false

      serve:
        files: [
          expand: true
          cwd:    'app/styles/'
          src:    [ '*.less' ]
          dest:   '.tmp/styles/'
          ext:    '.css'
          extDot: 'last'
        ]
        options:
          sourceMap: true
          sourceMapFilename: ''
          sourceMapBasepath: ''
          sourceMapRootpath: '/'

    # Compile Coffee to JS
    coffee:
      files: [
        expand: true
        cwd:    '<%= yeoman.app %>/scripts/'
        src:    [ '**/*.coffee' ]
        dest:   '<%= yeoman.tmp %>/scripts/'
        ext:    '.js'
        extDot: 'last'
      ]

      build:
        files: '<%= coffee.files %>'
        options:
          sourceMap: false

      serve:
        files: '<%= coffee.files %>'
        options:
          sourceMap: true
          sourceMapDir: '<%= yeoman.tmp %>/script_maps/'

    # Renames files for browser caching purposes
    rev:
      files:
        src: [ '<%= yeoman.dist %>/public/{scripts,styles,images,fonts}/**/*.*' ]

    # Reads HTML for usemin blocks to enable smart builds that automatically
    # concat, minify and revision files. Creates configurations in memory so
    # additional tasks can operate on them
    useminPrepare:
      html: [ '<%= yeoman.app %>/views/index.html' ]
      options:
        dest: '<%= yeoman.dist %>/public'

    # Performs rewrites based on rev and the useminPrepare configuration
    usemin:
      html: [ '<%= yeoman.dist %>/public/**/*.html' ]
      css:  [ '<%= yeoman.dist %>/public/styles/**/*.css' ]
      options:
        assetsDirs: [ '<%= yeoman.dist %>/public/' ]

    # The following *-min tasks produce minified files in the dist folder
    imagemin: # This should only need to be run on generated images in .tmp
      dynamic:
        files: [
          expand: true
          cwd:  '<%= yeoman.tmp %>/images'
          src:  [ '**/*.{png,jpg,jpeg,gif}' ]
          dest: '<%= yeoman.dist %>/public/images'
        ]
        options:
          cache: false

    svgmin:
      dynamic:
        files: [
          expand: true
          cwd:  '<%= yeoman.app %>/images/'
          src:  '**/*.svg'
          dest: '<%= yeoman.dist %>/public/images/'
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
          cwd:  '<%= yeoman.app %>/views/'
          src:  '**/*.html'
          dest: '<%= yeoman.dist %>/public/'
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

    # Copy pre-processed files from app to dist
    copy:
      lib:
        files: [
          expand: true
          src: [
            'server.coffee'
            'lib/**/*'
          ]
          dest: '<%= yeoman.dist %>'
        ]

      images:
        files: [
          expand: true
          cwd:  '<%= yeoman.app %>/images/'
          src:  '**/*'
          dest: '<%= yeoman.dist %>/public/images/'
        ]

    # Run some tasks in parallel to speed up the build process
    concurrent:
      build: [
        'compass:build'
        'newer:less:build'
        'newer:coffee:build'
        'copy'
        'htmlmin'
      ]
      serve: [
        'compass:serve'
        'newer:less:serve'
        'newer:coffee:serve'
      ]

  # Used for delaying livereload until after server has restarted
  grunt.registerTask 'wait', ->
    grunt.log.ok 'Waiting for server reload...'
    done = @async()
    setTimeout (->
      grunt.log.ok 'Done waiting!'
      done()
      return
    ), 1000
    return

  grunt.registerTask 'serve', (target) ->
    grunt.task.run [
      'concurrent:serve'
      'express:dev'
      'wait'
      'open'
      'watch'
    ]
    null

  grunt.registerTask 'build', [
    'clean:build'
    'useminPrepare'    # prep concat/*min blocks
    'concurrent:build' # compass/less/coffee+image/svg/htmlmin
    'concat'           # based on usemin block in html
    'ngmin'
    'cssmin'
    'uglify'
    'copy'
    'rev'
    'usemin'
  ]

  grunt.registerTask 'default', [
  ]

  return
