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

# External libs
_       = require 'lodash'
deasync = require 'deasync'

# Store our factory definitions here
factories = {}

###
# Factory.dummy
#
# TODO: More descriptive
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

  # Create the new model
  model = new factories[name].model

  # Clone the default attributes
  newAttrs = _.clone factories[name].attributes

  # Merge the passed attributes to the defaults
  _.extend newAttrs, attributes

  # Inject all attributes to the model, lazy evaluating as needed
  _.forOwn newAttrs, (fn, key) ->
    if typeof fn is 'function'
      if fn.length
        fn (value) ->
          model[key] = value
      else
        model[key] = fn()
    else
      model[key] = fn

  # Call the callback with the new model
  if callback
    callback model
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
      throw err if err
      callback(model)
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
    create name, (model) ->
      if attr
        callback model[attr]
      else
        callback model


# Build our export object
Factory        = create
Factory.define = define
Factory.build  = build
Factory.create = create
Factory.assoc  = assoc
Factory.dummy  = dummy

module.exports = Factory
