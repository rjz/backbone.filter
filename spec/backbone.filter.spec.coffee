require './helper.coffee'
require '../src/backbone.filter.js'

describe 'Backbone.Filter', ->

  # Retrieve an array of fixture models where the specified
  # key has the specified value
  getExpectedResult = (fixture, key, value) ->
    whereVal = {}
    whereVal[key] = value
    _.where(fixture, whereVal )

  collection = null

  beforeEach ->
    collection = new TestCollection(Fixtures.testModels)

  it 'returns the same type of collection', ->
    filter = new Backbone.Filter
    expect(filter.run(collection) instanceof TestCollection).toBeTruthy()

  it 'does not alter original collection', ->
    before = collection.models
    (new Backbone.Filters.sortBy(->)).run(collection)
    expect(collection.models).toEqual(before)

  describe 'Backbone.Filters', ->

    it 'is defined', ->
      expect(Backbone.Filters instanceof Object).toBeTruthy()

    it 'includes filters from underscore methods', ->
      for key in ['sortBy']
        filter = new Backbone.Filters[key]((m) -> m.attributes.name)
        expect(filter instanceof Backbone.Filter).toBeTruthy()
        result = collection.filter(filter)

    it 'can pass arguments to a filters created from underscore methods', ->

      age = 33

      filter = new Backbone.Filters.select (m) ->
        m.attributes.age == age

      result = collection.filter(filter, age)
      expect(result.length).toEqual(getExpectedResult(Fixtures.testModels, 'age', age).length)

  describe 'patched Backbone.Collection.filter', ->

    collection = null

    beforeEach ->
      collection = new TestCollection(Fixtures.testModels)

    it 'can filter with a Filter instance', ->
      age = 33
      ageFilter = new Backbone.Filters.select (m) -> m.attributes.age == age
      result = collection.filter(ageFilter)
      expect(result.length).toEqual(getExpectedResult(Fixtures.testModels, 'age', age).length)

    it 'can filter with an array of filters', ->
      sortByName = new Backbone.Filters.sortBy (m) -> m.attributes.name
      filterBySecondLetter = new Backbone.Filters.select (m) -> m.attributes.name[1] == 'o'
      result = collection.filter([filterBySecondLetter,sortByName])
      

