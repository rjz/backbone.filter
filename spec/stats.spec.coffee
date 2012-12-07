require './helper.coffee'
require '../src/backbone.filter.js'
require '../src/stats.coffee'

describe 'Backbone.Filter.Stats', ->

  collection = null

  beforeEach ->
    collection = new TestCollection(Fixtures.testModels)

  describe 'operations', ->

    it 'accepts an attribute', ->
      meanAge = new Backbone.Filters.Stats.Mean attribute: 'age'
      expect(meanAge.options.attribute).toEqual('age')

    it 'computes the sum', ->

      expected = _.reduce(Fixtures.testModels, ((memo, val) -> memo + val.age), 0)

      sumAge = new Backbone.Filters.Stats.Sum attribute: 'age'
      sum = collection.filter(sumAge)
      expect(sum).toEqual(expected)

    it 'computes the mean', ->

      sum = _.reduce(Fixtures.testModels, ((memo, val) -> memo + val.age), 0)

      meanAge = new Backbone.Filters.Stats.Mean attribute: 'age'
      mean = collection.filter(meanAge)

      expected = sum / Fixtures.testModels.length

      expect(mean).toEqual(expected)
