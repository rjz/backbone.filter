Backbone.Filters ||= {}

class Backbone.Filters.clone extends Backbone.Filter

  apply: (collection) ->
    models = _.map collection, (model) ->
      model.clone()
    new collection.constructor

