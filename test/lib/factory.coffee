###
# factory.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# A factory generator for node
# Operates similar to factory_girl for rails
#
# TODO: More descriptive
###
'use strict'

# External libs
_       = require 'lodash'
fs      = require 'fs'
path    = require 'path'
deasync = require 'deasync'

# Store our factory definitions here
factories = {}

###
# Factory.dummy
#
# A dummy backing model that stubs important functions
###
dummy = ->
dummy::save = (callback) ->
  @saveCalled = true
  callback() if callback

###
# Factory.define
#
# Use this to generate a factory definition
#
# TODO: More descriptive help here
###
define = (name, model, attributes) ->
  # We can't just have a name
  if arguments.length <= 1
    throw new Error('Invalid arguments')

  # Check if a model is given
  if arguments.length is 2
    attributes = model
    model = dummy

  factories[name] =
    model: model or dummy
    attributes: attributes

###
# lazyLoad
#
# Attempt to lazy load a factory definition
# Throws an error if the definition cannot be found
###
lazyLoad = (name) ->
  factoryName = path.join __dirname, '..', 'factories', name + '.coffee'
  if fs.existsSync factoryName
    require factoryName
  else
    throw new Error('No factory named ' + name  + ' exists')

###
# Factory.attributesFor
###
attributesFor = (name, attributes, callback) ->
  if typeof attributes is 'function'
    callback = attributes
    attributes = {}

  # Lazy load the factory definition, if needed
  lazyLoad name unless factories[name]?

  # Clone the default attributes
  newAttrs = _.clone factories[name].attributes

  # Merge the pass attributes to the defaults
  _.extend newAttrs, attributes

  # Evaluate lazy attributes
  _.forOwn newAttrs, (fn, key) ->
    if typeof fn is 'function'
      if fn.length
        fn (value) ->
          newAttrs[key] = value
      else
        newAttrs[key] = fn()

  if callback
    callback null, newAttrs
  else
    newAttrs

###
# Factory.build
#
# Use this to build a model from a factory definition
#
# TODO: More descriptive
###
build = (name, attributes, callback) ->
  # Check whether we were given attributes or a callback only
  if typeof attributes is 'function'
    callback = attributes
    attributes = {}

  # Lazy load the factory definition, if needed
  lazyLoad name unless factories[name]?

  # Create the new model
  model = new factories[name].model

  # Extend it with the defined attributes
  _.extend model, attributesFor(name, attributes)

  # Call the callback with the new model
  if callback
    callback null, model
  else
    model

###
# Factory.create
#
# Use this to create (build & save) a model from a factory definition
#
# TODO: More descriptive
###
create = (name, attributes, callback) ->
  # Check if we were given attributes or a callback only
  if typeof attributes is 'function'
    callback = attributes
    attributes = {}

  # Call build, then save the model
  model = build name, attributes
  if callback
    model.save (err) ->
      callback err, model
    null
  else
    # Deasync
    done = false
    model.save (err) ->
      throw err if err
      done = true
    while !done
      deasync.runLoopOnce()
    model

###
# Factory.assoc
#
# TODO: More descriptive
###
assoc = (name, attr) ->
  (callback) ->
    create name, (err, model) ->
      throw err if err
      if attr
        callback model[attr]
      else
        callback model


# Build our export object
Factory               = create
Factory.define        = define
Factory.build         = build
Factory.create        = create
Factory.assoc         = assoc
Factory.dummy         = dummy
Factory.attributesFor = attributesFor

module.exports = Factory
