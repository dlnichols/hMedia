###
# test/mocha/factory.coffee
#
# © 2014 Dan Nichols
# See LICENSE for more details
#
# Tests for our Factory factory
###
'use strict'

# External libs
should = require('chai').should()

# Internal libs
Factory = require '../lib/factory.coffee'

describe 'Helper - Factory', ->
  Model = ->
  Model::save = (callback) ->
    @saveCalled = true
    callback()
  Static = ->
  Static:: = new Model()
  Sync = ->
  Sync:: = new Model()
  Async = ->
  Async:: = new Model()
  Assoc = ->
  Assoc:: = new Model()

  before ->
    Factory.define 'dummy',
      name: 'Dummy'

    Factory.define 'static', Static,
      name: 'Monkey'
      age: 12

    syncCounter = 1
    Factory.define 'sync', Sync,
      name: ->
        'Synchronous monkey ' + syncCounter++

    asyncCounter = 1
    Factory.define 'async', Async,
      name: (callback) ->
        'Asynchronous monkey ' + asyncCounter++

    Factory.define 'assoc', Assoc,
      monkey: Factory.assoc 'static'

  describe 'Method define', ->
    it 'should throw an exception if no attributes are given', ->
      Factory.define.should.throw 'Invalid arguments'
      Factory.define.bind(null, 'name').should.throw 'Invalid arguments'
      Factory.define.bind(null, 'name', dummy: true).should.not.throw

  describe 'Method build', ->
    it 'should return the model when called synchronously', ->
      model = Factory.build 'static'
      should.exist model
      (model instanceof Static).should.be.true

    it 'should pass the model when call asynchronously', (done) ->
      Factory.build 'static', (model) ->
        should.exist model
        (model instanceof Static).should.be.true
        done()

    it 'should provide a dummy/stub factory class', ->
      model = Factory.build 'dummy', dummy: true
      (model instanceof Factory.dummy).should.be.true
      model.name.should.eql 'Dummy'
      model.dummy.should.eql true

    it 'should build, but not save the model', ->
      model = Factory.build 'static'
      (model instanceof Static).should.be.true
      model.name.should.eql 'Monkey'
      model.age.should.eql 12
      model.should.not.have.property 'saveCalled'

    it 'should allow overriding and/or adding attributes', ->
      model = Factory.build 'static',
        name: 'Not a monkey'
        foo: 'bar'
      (model instanceof Static).should.be.true
      model.name.should.eql 'Not a monkey'
      model.age.should.eql 12
      should.exist model.foo
      model.foo.should.eql 'bar'
      model.should.not.have.property 'saveCalled'

    it 'should allow synchronous dynamic attributes', ->
      model = Factory.build 'sync'
      (model instanceof Sync).should.be.true
      model.name.should.eql 'Synchronous monkey 1'
      model2 = Factory.build 'sync'
      (model2 instanceof Sync).should.be.true
      model2.name.should.eql 'Synchronous monkey 2'

    it 'should allow associative attributes', ->
      model = Factory.build 'assoc'
      (model instanceof Assoc).should.be.true
      (model.monkey instanceof Static).should.be.true
      model.monkey.name.should.eql 'Monkey'

  describe 'Method create', ->
    it 'should return the model when called synchronously', ->
      model = Factory.create 'static'
      should.exist model
      (model instanceof Static).should.be.true

    it 'should pass the model when call asynchronously', (done) ->
      Factory.create 'static', (model) ->
        should.exist model
        (model instanceof Static).should.be.true
        done()

    it 'should build and save the model', ->
      model = Factory.create 'static'
      (model instanceof Static).should.be.true
      model.should.have.property 'saveCalled'
      model.saveCalled.should.be.true
