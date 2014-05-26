###
# grunt/compass.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Define our compass configuration block for grunt
###

module.exports =
  # Compiles Sass to CSS
  options:
    sassDir:                 'app/styles/'
    imagesDir:               'app/images/'
    javascriptsDir:          'app/scripts/'
    fontsDir:                'app/fonts/'
    importPath:              'app/bower_components/'
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
      generatedImagesDir: 'dist/public/images/generated/'

  serve:
    options:
      debugInfo: true
