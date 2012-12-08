require './helper.coffee'
require '../src/backbone.filter.js'
require '../src/examples.js'

describe 'Example filters', ->

  collection = null
  invalid = 0

  beforeEach ->
    invalid = 0
    collection = new TestCollection(Fixtures.testModels)
    collection.each (m, i) ->
      if i % 2
        invalid++
        m.set 'valid', false

  describe 'Backbone.Filters.reverse', ->
    it 'returns a collection with model order reversed', ->
      before = collection.pluck('name')
      after = collection.filter(new Backbone.Filters.reverse).pluck('name')
      expect(after).toEqual(before.reverse())

  describe 'Backbone.Filters.valid', ->
    it 'returns a collection with all valid models', ->
      valids = collection.filter(new Backbone.Filters.valid)
      expect(valids.length).toEqual(collection.length - invalid)
  
  describe 'Backbone.Filters.invalid', ->
    it 'returns a collection with all invalid models', ->
      invalids = collection.filter(new Backbone.Filters.invalid)
      expect(invalids.length).toEqual(invalid)

