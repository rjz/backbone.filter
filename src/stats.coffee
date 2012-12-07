Backbone.Filters ||= {}

Stats = {}


class Base extends Backbone.Filter
  defaults:
    attribute: ''

  stat: (op, collection) ->
    statFilter = new Stats[op](attribute: @options.attribute)
    collection.filter(statFilter)

class Stats.Sum extends Base
  run: (collection) ->
    sum = 0
    collection.each (model) =>
      sum += model.get(@options.attribute)
    sum

class Stats.Mean extends Base
  run: (collection) ->
    @stat('Sum', collection)
    sum / collection.length
   
Backbone.Filters.Stats = Stats
