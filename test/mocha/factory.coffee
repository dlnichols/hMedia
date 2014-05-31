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
expect = require('chai').expect

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
      expect(Factory.define).to.throw Error, /Invalid arguments/
      expect(Factory.define.bind(null, 'name')).to.throw Error, /Invalid arguments/
      expect(Factory.define.bind(null, 'name', dummy: true)).to.not.throw Error

  describe 'Method build', ->
    it 'should return the model when called synchronously', ->
      model = Factory.build 'static'
      expect(model).to.exist
      expect(model).to.be.instanceof Static

    it 'should pass the model when call asynchronously', (done) ->
      Factory.build 'static', (model) ->
        expect(model).to.exist
        expect(model).to.be.instanceof Static
        done()

    it 'should provide a dummy/stub factory class', ->
      model = Factory.build 'dummy', dummy: true
      expect(model).to.be.instanceof Factory.dummy
      expect(model.name).to.eql 'Dummy'
      expect(model.dummy).to.eql true

    it 'should build, but not save the model', ->
      model = Factory.build 'static'
      expect(model).to.be.instanceof Static
      expect(model.name).to.be.eql 'Monkey'
      expect(model.age).to.be.eql 12
      expect(model).to.not.have.property 'saveCalled'

    it 'should allow overriding and/or adding attributes', ->
      model = Factory.build 'static',
        name: 'Not a monkey'
        foo: 'bar'
      expect(model).to.be.instanceof Static
      expect(model.name).to.eql 'Not a monkey'
      expect(model.age).to.eql 12
      expect(model.foo).to.exist
      expect(model.foo).to.eql 'bar'
      expect(model).to.not.have.property 'saveCalled'

    it 'should allow synchronous dynamic attributes', ->
      model = Factory.build 'sync'
      expect(model).to.be.instanceof Sync
      expect(model.name).to.eql 'Synchronous monkey 1'
      model2 = Factory.build 'sync'
      expect(model2).to.be.instanceof Sync
      expect(model2.name).to.eql 'Synchronous monkey 2'

    it 'should allow associative attributes', ->
      model = Factory.build 'assoc'
      expect(model).to.be.instanceof Assoc
      expect(model.monkey).to.be.instanceof Static
      expect(model.monkey.name).to.eql 'Monkey'

  describe 'Method create', ->
    it 'should return the model when called synchronously', ->
      model = Factory.create 'static'
      expect(model).to.exist
      expect(model).to.be.instanceof Static

    it 'should pass the model when call asynchronously', (done) ->
      Factory.create 'static', (model) ->
        expect(model).to.exist
        expect(model).to.be.instanceof Static
        done()

    it 'should build and save the model', ->
      model = Factory.create 'static'
      expect(model).to.be.instanceof Static
      expect(model).to.have.property 'saveCalled'
      expect(model.saveCalled).to.eql true
