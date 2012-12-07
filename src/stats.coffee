Backbone.Filters ||= {}

Stats = {}

# Base class for statistics filters. Provides `stat` 
# utility for retrieving the results of other statistical
# operations and `sort` utility for sorting a collection.
class Base extends Backbone.Filter

  defaults:
    attribute: ''

  sort: (collection) ->
    attribute = @options.attribute
    sortFilter = new Backbone.Filters.sortBy (m) -> m.get(attribute)
    collection.filter(sortFilter)

  stat: (op, collection) ->
    statFilter = new Stats[op](attribute: @options.attribute)
    collection.filter(statFilter)

# Sum value for the specified `attribute` in the filtered 
# collection
class Stats.Sum extends Base
  run: (collection) ->
    attribute = @options.attribute
    reducer = (memo, model) -> memo + model.get(attribute)
    collection.reduce reducer, 0

# Find mean value for the specified `attribute` in the 
# filtered collection
class Stats.Mean extends Base
  run: (collection) ->
    @stat('Sum', collection) / collection.length

# Find median value for the specified `attribute` in the 
# filtered collection
class Stats.Median extends Base
  run: (collection) ->
    attribute = @options.attribute
    sorted = @sort(collection)
    index = Math.floor((sorted.length - 1) / 2)

    if sorted.length % 2
      sorted.at(index).get(attribute)
    else
      lo = sorted.at(index).get(attribute)
      hi = sorted.at(index + 1).get(attribute)
      (lo + hi) / 2

# Compute standard deviation for the specified `attribute`
# in the filtered collection
class Stats.Stdev extends Base
  run: (collection) ->
    attribute = @options.attribute
    mean = @stat('Mean', collection)
    reducer = (memo, m) -> memo + Math.pow(m.get(attribute) - mean, 2)
    xbar = collection.reduce reducer, 0
    Math.sqrt(xbar / collection.length)

# Attach `Stats` filters
Backbone.Filters.Stats = Stats

