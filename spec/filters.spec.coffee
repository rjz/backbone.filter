require './helper.coffee'
require '../src/backbone.filter.js'
require '../src/filters.coffee'

describe 'Backbone.Filter.clone', ->

  collection = null

  beforeEach ->
    collection = new TestCollection(Fixtures.testModels)

  it 'returns collection with all models cloned', ->
    clone = new Backbone.Filters.clone

    result = collection.filter(clone)
    collection.each (m) ->
      expect(result.get(m.id)).not.toEqual(m)
