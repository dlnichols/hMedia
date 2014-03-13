# Generated on 2014-02-18 using generator-angular-fullstack 1.2.7
'use strict'

# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'
module.exports = (grunt) ->
  # Read and interpret CoffeeScript
  require('coffee-script')

  # Load grunt tasks automatically
  require('load-grunt-tasks') grunt

  # Time how long tasks take. Can help when optimizing build times
  require('time-grunt') grunt

  # Define the configuration for all the tasks
  grunt.initConfig

    # Project settings
    yeoman:
      app: require('./bower.json').appPath or 'app'
      dist: 'dist'

    express:
      options:
        port: process.env.PORT or 9000

      dev:
        options:
          script: 'server.coffee'
          debug: true

      prod:
        options:
          script: 'dist/server.coffee'
          node_env: 'production'

    open:
      server:
        url: 'http://localhost:<%= express.options.port %>'

    watch:
      js:
        files: ['<%= yeoman.app %>/scripts/{,*/}*.js']
        tasks: ['newer:jshint:all']
        options:
          livereload: true

      jsTest:
        files: ['test/spec/{,*/}*.js']
        tasks: [
          'newer:jshint:test'
          'karma'
        ]

      compass:
        files: ['<%= yeoman.app %>/styles/{,*/}*.{scss,sass}']
        tasks: ['compass:server']

      less:
        files: ['<%= yeoman.app %>/styles/{,*/}*.less']
        tasks: ['less']

      gruntfile:
        files: ['Gruntfile.js']

      livereload:
        files: [
          '<%= yeoman.app %>/views/{,*//*}*.{html,jade}'
          '{.tmp,<%= yeoman.app %>}/styles/{,*//*}*.css'
          '{.tmp,<%= yeoman.app %>}/scripts/{,*//*}*.js'
          '<%= yeoman.app %>/images/{,*//*}*.{png,jpg,jpeg,gif,webp,svg}'
        ]
        options:
          livereload: true

      express:
        files: [
          'server.coffee'
          'lib/**/*.{js,json}'
        ]
        tasks: [
          'newer:jshint:server'
          'express:dev'
          'wait'
        ]
        options:
          livereload: true
          nospawn: true #Without this option specified express won't be reloaded

    # Make sure code styles are up to par and there are no obvious mistakes
    jshint:
      options:
        jshintrc: '.jshintrc'
        reporter: require('jshint-stylish')

      server:
        options:
          jshintrc: 'lib/.jshintrc'

        src: ['lib/{,*/}*.js']

      all: ['<%= yeoman.app %>/scripts/{,*/}*.js']
      test:
        options:
          jshintrc: 'test/.jshintrc'

        src: ['test/spec/{,*/}*.js']

    # Empties folders to start fresh
    clean:
      dist:
        files: [
          dot: true
          src: [
            '.tmp'
            '<%= yeoman.dist %>'
          ]
        ]

      server: '.tmp'

    # Compiles Sass to CSS and generates necessary files if requested
    compass:
      options:
        sassDir: '<%= yeoman.app %>/styles'
        cssDir: '.tmp/styles'
        generatedImagesDir: '.tmp/images/generated'
        imagesDir: '<%= yeoman.app %>/images'
        javascriptsDir: '<%= yeoman.app %>/scripts'
        fontsDir: '<%= yeoman.app %>/styles/fonts'
        importPath: '<%= yeoman.app %>/bower_components'
        httpImagesPath: '/images'
        httpGeneratedImagesPath: '/images/generated'
        httpFontsPath: '/styles/fonts'
        relativeAssets: false
        assetCacheBuster: false
        raw: 'Sass::Script::Number.precision = 10\n'

      dist:
        options:
          generatedImagesDir: '<%= yeoman.dist %>/public/images/generated'

      server:
        options:
          debugInfo: true

    less:
      dist:
        files:
          '.tmp/styles/bootstrap.amelia.css'   : ['<%= yeoman.app %>/styles/bootstrap.amelia.less']
          '.tmp/styles/bootstrap.cerulean.css' : ['<%= yeoman.app %>/styles/bootstrap.cerulean.less']
          '.tmp/styles/bootstrap.cosmo.css'    : ['<%= yeoman.app %>/styles/bootstrap.cosmo.less']
          '.tmp/styles/bootstrap.cyborg.css'   : ['<%= yeoman.app %>/styles/bootstrap.cyborg.less']
          '.tmp/styles/bootstrap.flatly.css'   : ['<%= yeoman.app %>/styles/bootstrap.flatly.less']
          '.tmp/styles/bootstrap.journal.css'  : ['<%= yeoman.app %>/styles/bootstrap.journal.less']
          '.tmp/styles/bootstrap.lumen.css'    : ['<%= yeoman.app %>/styles/bootstrap.lumen.less']
          '.tmp/styles/bootstrap.readable.css' : ['<%= yeoman.app %>/styles/bootstrap.readable.less']
          '.tmp/styles/bootstrap.simplex.css'  : ['<%= yeoman.app %>/styles/bootstrap.simplex.less']
          '.tmp/styles/bootstrap.slate.css'    : ['<%= yeoman.app %>/styles/bootstrap.slate.less']
          '.tmp/styles/bootstrap.spacelab.css' : ['<%= yeoman.app %>/styles/bootstrap.spacelab.less']
          '.tmp/styles/bootstrap.standard.css' : ['<%= yeoman.app %>/styles/bootstrap.standard.less']
          '.tmp/styles/bootstrap.superhero.css': ['<%= yeoman.app %>/styles/bootstrap.superhero.less']
          '.tmp/styles/bootstrap.united.css'   : ['<%= yeoman.app %>/styles/bootstrap.united.less']
          '.tmp/styles/bootstrap.yeti.css'     : ['<%= yeoman.app %>/styles/bootstrap.yeti.less']

        options:
          sourceMap: true
          sourceMapFilename: ''
          sourceMapBasepath: ''
          sourceMapRootpath: '/'

    # Renames files for browser caching purposes
    rev:
      dist:
        files:
          src: [
            '<%= yeoman.dist %>/public/scripts/{,*/}*.js'
            '<%= yeoman.dist %>/public/styles/{,*/}*.css'
            '<%= yeoman.dist %>/public/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
            '<%= yeoman.dist %>/public/styles/fonts/*'
          ]

    # Reads HTML for usemin blocks to enable smart builds that automatically
    # concat, minify and revision files. Creates configurations in memory so
    # additional tasks can operate on them
    useminPrepare:
      html: [
        '<%= yeoman.app %>/views/index.html'
        '<%= yeoman.app %>/views/index.jade'
      ]
      options:
        dest: '<%= yeoman.dist %>/public'

    # Performs rewrites based on rev and the useminPrepare configuration
    usemin:
      html: [
        '<%= yeoman.dist %>/public/{,*/}*.html'
        '<%= yeoman.dist %>/public/{,*/}*.jade'
      ]
      css: ['<%= yeoman.dist %>/public/styles/{,*/}*.css']
      options:
        assetsDirs: ['<%= yeoman.dist %>/public']

    # The following *-min tasks produce minified files in the dist folder
    imagemin:
      dist:
        files: [
          expand: true
          cwd: '<%= yeoman.app %>/images'
          src: '{,*/}*.{png,jpg,jpeg,gif}'
          dest: '<%= yeoman.dist %>/public/images'
        ]

    svgmin:
      dist:
        files: [
          expand: true
          cwd: '<%= yeoman.app %>/images'
          src: '{,*/}*.svg'
          dest: '<%= yeoman.dist %>/public/images'
        ]

    htmlmin:
      dist:
        options:
          collapseWhitespace: true
          #collapseBooleanAttributes: true,
          removeCommentsFromCDATA: true

        #removeOptionalTags: true
        files: [
          expand: true
          cwd: '<%= yeoman.app %>/views'
          src: [
            '*.html'
            'partials/**/*.html'
          ]
          dest: '<%= yeoman.dist %>/public'
        ]

    # Allow the use of non-minsafe AngularJS files. Automatically makes it
    # minsafe compatible so Uglify does not destroy the ng references
    ngmin:
      dist:
        files: [
          expand: true
          cwd: '.tmp/concat/scripts'
          src: 'application.js'
          dest: '.tmp/concat/scripts'
        ]

    # Replace Google CDN references
    cdnify:
      dist:
        html: ['<%= yeoman.dist %>/public/*.html']

    # Copies remaining files to places other tasks can use
    copy:
      dist:
        files: [
          {
            expand: true
            dot: true
            cwd: '<%= yeoman.app %>'
            dest: '<%= yeoman.dist %>/public'
            src: [
              '*.{ico,png,txt}'
              'fonts/**/*'
            ]
          }
          {
            expand: true
            dot: true
            cwd: '<%= yeoman.app %>/views'
            dest: '<%= yeoman.dist %>/public'
            src: '**/*.jade'
          }
          {
            expand: true
            cwd: '.tmp/images'
            dest: '<%= yeoman.dist %>/public/images'
            src: ['generated/*']
          }
          {
            expand: true
            dest: '<%= yeoman.dist %>'
            src: [
              'package.json'
              'server.coffee'
            ]
          }
          {
            expand: true
            cwd: '.tmp/concat/scripts'
            dest: '<%= yeoman.dist %>/public/scripts'
            src: '**/*.js'
          }
        ]

    # Run some tasks in parallel to speed up the build process
    concurrent:
      server: [
        'compass:server'
        'less'
      ]
      test: [
        'compass'
        'less'
      ]
      dist: [
        'compass:dist'
        'less'
        'imagemin'
        'svgmin'
        'htmlmin'
      ]

    # Test settings
    karma:
      unit:
        configFile: 'karma.conf.js'
        singleRun: true

  # Used for delaying livereload until after server has restarted
  grunt.registerTask 'wait', ->
    grunt.log.ok 'Waiting for server reload...'
    done = @async()
    setTimeout (->
      grunt.log.writeln 'Done waiting!'
      done()
      return
    ), 500
    return

  grunt.registerTask 'express-keepalive', 'Keep grunt running', ->
    @async()
    return

  grunt.registerTask 'serve', (target) ->
    grunt.task.run [
      'clean:server'
      'concurrent:server'
      'express:dev'
      'open'
      'watch'
    ]
    return

  grunt.registerTask 'test', [
    'clean:server'
    'concurrent:test'
    'karma'
  ]
  grunt.registerTask 'build', [
    'clean:dist'
    'useminPrepare'
    'concurrent:dist'
    'concat'
    'ngmin'
    'cssmin'
    'copy:dist'
    'cdnify'
    'rev'
    'usemin'
  ]
  grunt.registerTask 'default', [
    'newer:jshint'
    'test'
    'build'
  ]
  grunt.registerTask 'db:prepare', ->
    done = @async()
    require('./lib/dummydata.js').dbPrepare done
    return

  return
