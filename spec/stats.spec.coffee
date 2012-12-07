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

  describe 'Stats.Sum', ->

    it 'computes the sum', ->
      expected = _.reduce(Fixtures.testModels, ((memo, val) -> memo + val.age), 0)
      sumAge = new Backbone.Filters.Stats.Sum attribute: 'age'
      sum = collection.filter(sumAge)
      expect(sum).toEqual(expected)

  describe 'Stats.Mean', ->
    it 'computes the mean', ->
      sum = _.reduce(Fixtures.testModels, ((memo, val) -> memo + val.age), 0)
      expected = sum / Fixtures.testModels.length
      meanAge = new Backbone.Filters.Stats.Mean attribute: 'age'
      mean = collection.filter(meanAge)
      expect(mean).toEqual(expected)
 
  describe 'Stats.Median', ->

    ages = null
    medianAge = new Backbone.Filters.Stats.Median attribute: 'age'

    beforeEach ->
      ages = [
        { age: 13 },
        { age: 14 },
        { age: 15 },
      ]

    it 'works on odd-count collections', ->
      collection = new TestCollection(ages)
      median = collection.filter(medianAge)
      expect(median).toEqual(14)

    it 'even works on even-count collections', ->
      collection = new TestCollection(ages.concat { age: 16 } )
      median = collection.filter(medianAge)
      expect(median).toEqual(14.5)

  describe 'Stats.Stdev', ->

    ages = null
    stdevAge = new Backbone.Filters.Stats.Stdev attribute: 'age'

    beforeEach -> # straight outta wikipedia
      ages = _.map([2, 4, 4, 4, 5, 5, 7, 9], (i) -> { age: i })

    it 'computes standard deviations', ->
      collection = new TestCollection(ages)
      stdev = collection.filter(stdevAge)
      expect(stdev).toEqual(2)


