module.exports = (config) ->
  config.set
    basePath: '..'
    frameworks: [ 'mocha', 'chai', 'sinon' ]
    files: [
      'lib/**/*.coffee'
      'test/**/*.coffee'
    ]
    exclude: []
    preprocessors: {
      '**/*.coffee': ['coffee']
    }
    reporters: [
      'progress'
    ]
    port: 9876
    colors: true
    # level of logging - possible: DISABLE,ERROR,WARN,INFO,DEBUG
    logLevel: config.LOG_INFO
    autoWatch: true
    browsers: [ 'Chrome' ]
    captureTimeout: 6000
    singleRun: false
