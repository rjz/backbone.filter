(function (Backbone) {

  var oldFilter = Backbone.Collection.prototype.filter;
  Backbone.Filters = {};

  // Base class for describing Backbone Filters
  Backbone.Filter = (function () {

    Filter.prototype.defaults = {};
    Filter.prototype.options = {};

    function Filter (opts) {

      var key, 
          keys = _.keys(this.defaults);

      if (opts == null) {
        opts = {};
      }

      while (key = keys.pop()) {
        this.options[key] = opts[key] || this.defaults[key];
      }
    }

    Filter.prototype.comparator = function (model) {
      return true;
    };

    Filter.prototype.run = function (collection, query) {
      this.query = query;
      return new collection.constructor(collection.models);
    };

    return Filter;

  })();

  // Add underscore methods
  _.each(['filter','invoke','reject','select','shuffle','sortBy','without'], function (key) {
    var extend = Backbone.Collection.extend;
    Backbone.Filters[key] = extend.call(Backbone.Filter, {
      constructor: function () {
        this.args = [].slice.call(arguments, 0);
      },
      run: function (collection) {
        var models = _[key].apply(_, [collection.models].concat(this.args));
        return new collection.constructor(models);
      }
    });
  });

  // Patch `Backbone.Collection.filter` method to support filters
  Backbone.Collection.prototype.filter = function (filter) {

    var args = [].slice.call(arguments, 1);
    var collection = this;

    if (filter instanceof Array) {
      _.each(filter, function (f) { collection = collection.filter(f) });
    }
    else if (filter instanceof Backbone.Filter) {
      collection = filter.run(this, args);
    }
    else {
      collection = oldFilter.apply(collection, arguments);
    }

    return collection;
  }

})(Backbone);
