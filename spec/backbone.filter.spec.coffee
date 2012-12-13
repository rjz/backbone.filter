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

  describe 'Registration + Aliasing', ->

    single = null

    beforeEach ->
      single = new Backbone.Filters.first(1)

    it 'defines filters by alias', ->
      key = 'single'
      Backbone.Filter.define key, single
      expect(Backbone.Filter.lookup(key)).toEqual(single)
      Backbone.Filter.undefine 'single'

    it 'returns null when alias lookup fails', ->
      expect(Backbone.Filter.lookup('unknown')).toEqual(null)

    it 'unaliases stored filters', ->
      key = 'single'
      Backbone.Filter.define key, single
      Backbone.Filter.undefine key
      expect(Backbone.Filter.lookup(key)).toEqual(null)

    it 'throws an exception if a filter cannot be unaliased', ->
      meth = ->
        Backbone.Filter.undefine 'unknown'
      expect(meth).toThrow(new Error('Unknown filter alias unknown'))

    it 'throws an exception if an alias already exists', ->
      do meth = ->
        Backbone.Filter.define 'single', single
      expect(meth).toThrow(new Error('Filter alias single is already defined'))
      Backbone.Filter.undefine 'single'

  describe 'Backbone.Filters', ->

    it 'is defined', ->
      expect(Backbone.Filters instanceof Object).toBeTruthy()

    it 'includes filters from underscore methods', ->
      for key in ['filter','first','invoke','last','reject','select','shuffle','sortBy','without']
        filter = new Backbone.Filters[key]
        expect(filter instanceof Backbone.Filter).toBeTruthy()

    it 'can pass arguments to filters created from underscore methods', ->

      age = 33

      filter = new Backbone.Filters.select (m) ->
        m.attributes.age == age

      result = collection.filter(filter, age)
      expect(result.length).toEqual(getExpectedResult(Fixtures.testModels, 'age', age).length)

    describe 'Backbone.Filters.first', ->

      it 'chooses first items from collection', ->
        first2 = new Backbone.Filters.first(2)
        result = collection.filter(first2)
        expect(result.length).toEqual(2)

  describe 'patched Backbone.Collection.filter', ->

    collection = null

    beforeEach ->
      collection = new TestCollection(Fixtures.testModels)

    it 'retains existing behavior', ->
      iterator = (model) -> model.get('name')[1] == 'o'
      expect(collection.filter(iterator)).toEqual(collection.select(iterator))

    it 'can filter with a Filter instance', ->
      age = 33
      ageFilter = new Backbone.Filters.select (m) -> m.attributes.age == age
      result = collection.filter(ageFilter)
      expect(result.length).toEqual(getExpectedResult(Fixtures.testModels, 'age', age).length)

    it 'can filter with an array of filters', ->
      sortByName = new Backbone.Filters.sortBy (m) -> m.attributes.name
      filterBySecondLetter = new Backbone.Filters.select (m) -> m.attributes.name[1] == 'o'
      result = collection.filter([filterBySecondLetter,sortByName])

      expected = collection.filter(filterBySecondLetter)
      expected = expected.filter(sortByName)

      expect(result.pluck('name')).toEqual(expected.pluck('name'))
      
    it 'can filter with a single alias', ->
      one = new Backbone.Filters.sortBy (m) -> m.attributes.name
      Backbone.Filter.define 'one', one
      expect(collection.filter("one")).toEqual(collection.filter(one))
      Backbone.Filter.undefine 'one'
    
    it 'can filter with a chain of aliases', ->
      one = new Backbone.Filters.sortBy (m) -> m.attributes.name
      two = new Backbone.Filters.select (m) -> m.attributes.name[1] == 'o'

      Backbone.Filter.define 'one', one
      Backbone.Filter.define 'two', two

      expect(collection.filter("one|two")).toEqual(collection.filter([one, two]))
      
      Backbone.Filter.undefine 'one'
      Backbone.Filter.undefine 'two'
