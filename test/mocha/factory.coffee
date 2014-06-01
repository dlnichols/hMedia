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

    Factory.define 'assoc', Assoc,
      monkey: Factory.assoc 'static'

  describe 'Method define', ->
    it 'should throw an exception if no attributes are given', ->
      expect(Factory.define).to.throw Error, /Invalid arguments/
      expect(Factory.define.bind(null, 'name')).to.throw Error, /Invalid arguments/
      expect(Factory.define.bind(null, 'name', dummy: true)).to.not.throw Error

  describe 'Method attributesFor', ->
    it 'should return the attributes when called synchronously', ->
      attrs = Factory.attributesFor 'static'
      expect(attrs).to.exist
      expect(attrs).not.to.be.instanceof Static
      expect(attrs).to.be.instanceof Object

    it 'should pass attributes when called asynchronously', ->
      Factory.attributesFor 'static', (attrs) ->
        expect(attrs).to.exist
        expect(attrs).not.to.be.instanceof Static
        expect(attrs).to.be.instanceof Object

    it 'should lazy evaluate synchronous functions', ->
      attrs = Factory.attributesFor 'sync'
      expect(attrs.name).to.match /^Synchronous monkey/

    it 'should allow overriding and/or adding attributes', ->
      attrs = Factory.build 'static',
        name: 'Not a monkey'
        foo: 'bar'
      expect(attrs).to.be.instanceof Static
      expect(attrs.name).to.eql 'Not a monkey'
      expect(attrs.age).to.eql 12
      expect(attrs.foo).to.exist
      expect(attrs.foo).to.eql 'bar'
      expect(attrs).to.not.have.property 'saveCalled'

    it 'should allow synchronous dynamic attributes', ->
      attrs = Factory.build 'sync'
      expect(attrs).to.be.instanceof Sync
      expect(attrs.name).to.match /^Synchronous monkey/

      attrs2 = Factory.build 'sync'
      expect(attrs2).to.be.instanceof Sync
      expect(attrs2.name).to.match /^Synchronous monkey/

    it 'should allow associative attributes', ->
      model = Factory.build 'assoc'
      expect(model).to.be.instanceof Assoc
      expect(model.monkey).to.be.instanceof Static
      expect(model.monkey.name).to.eql 'Monkey'

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
