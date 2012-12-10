require './helper.coffee'
require '../src/backbone.filter.js'
require '../src/stats.js'

describe 'Backbone.Filter.Stats', ->

  collection = null

  beforeEach ->
    collection = new TestCollection(Fixtures.testModels)

  describe 'operations', ->

    it 'accepts an attribute', ->
      meanAge = new Backbone.Filters.Stats.Mean attribute: 'age'
      expect(meanAge.options.attribute).toEqual('age')

  describe 'Stats.Sum', ->

    expected = _.reduce(Fixtures.testModels, ((memo, val) -> memo + val.age), 0)

    it 'computes the sum', ->
      sumAge = new Backbone.Filters.Stats.Sum attribute: 'age'
      sum = collection.filter(sumAge)
      expect(sum).toEqual(expected)

  describe 'Stats.Mean', ->
    
    sum = _.reduce(Fixtures.testModels, ((memo, val) -> memo + val.age), 0)
    expected = sum / Fixtures.testModels.length

    it 'computes the mean', ->
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

  describe 'Stats.Min', ->
    it 'returns the minimum value of the attribute', ->
      minAge = new Backbone.Filters.Stats.Min attribute: 'age'
      expected = collection.min((m) -> m.attributes.age).get('age')
      expect(collection.filter(minAge)).toEqual(expected)

  describe 'Stats.Max', ->
    it 'returns the maximum value of the attribute', ->
      minAge = new Backbone.Filters.Stats.Max attribute: 'age'
      expected = collection.max((m) -> m.attributes.age).get('age')
      expect(collection.filter(minAge)).toEqual(expected)

  describe 'Stats.Limits', ->
    it 'returns an array with min, max limits of the attribute', ->
      limitsAge = new Backbone.Filters.Stats.Limits attribute: 'age'
      expected = [
        collection.min((m) -> m.attributes.age).get('age')
        collection.max((m) -> m.attributes.age).get('age')
      ]
      expect(collection.filter(limitsAge)).toEqual(expected)

  describe 'Stats.Range', ->
    it 'returns the difference of the min+max values of the attribute', ->
      rangeAge = new Backbone.Filters.Stats.Range attribute: 'age'
      range = [
        collection.min((m) -> m.attributes.age).get('age')
        collection.max((m) -> m.attributes.age).get('age')
      ]
      expect(collection.filter(rangeAge)).toEqual(range[1] - range[0])

  describe 'Stats.Variance', ->

    ages = null
    varianceAge = new Backbone.Filters.Stats.Variance attribute: 'age'

    beforeEach -> # straight outta wikipedia
      ages = _.map([2, 4, 4, 4, 5, 5, 7, 9], (i) -> { age: i })

    it 'computes the variance', ->
      collection = new TestCollection(ages)
      variance = collection.filter(varianceAge)
      expect(variance).toEqual(4)


  describe 'Stats.Stdev', ->

    ages = null
    stdevAge = new Backbone.Filters.Stats.Stdev attribute: 'age'

    beforeEach -> # straight outta wikipedia
      ages = _.map([2, 4, 4, 4, 5, 5, 7, 9], (i) -> { age: i })

    it 'computes standard deviations', ->
      collection = new TestCollection(ages)
      stdev = collection.filter(stdevAge)
      expect(stdev).toEqual(2)


