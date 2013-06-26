(function(root, factory) {
  // Set up Backbone.Filter appropriately for the environment.
  if (typeof exports !== 'undefined') {
    // Node/CommonJS.
    factory(require('underscore'), require('backbone'));
  } else if (typeof define === 'function' && define.amd) {
    // AMD
    define(['underscore', 'backbone'], factory);
  } else {
    // Browser globals
    factory(root._, root.Backbone);
  }
}(this, function(_, Backbone) {

  var oldFilter = Backbone.Collection.prototype.filter,
      aliases = {},
      _exists = function (obj, key) { return obj.hasOwnProperty(key); },
      _slice = [].slice;

  Backbone.Filters = {};

  // Base class for describing Backbone Filters
  Backbone.Filter = (function () {

    function Filter (opts) {
      this.options = _.defaults(_.pick(opts, _.keys(this.defaults)), this.defaults);
    }

    _.extend(Filter.prototype, {
      defaults: {},
      options: {},
      run: function (collection, query) {
        this.query = query;
        return new collection.constructor(collection.models);
      }
    });

    // Provide aliasing (for the truly lazy)
    _.extend(Filter, {

      // Piggyback onto Backbone's `extend` method
      extend: Backbone.Collection.extend,

      define: function (alias, filter) {
          if (_exists(aliases, alias)) {
              throw('Filter alias ' + alias + ' is already defined');
          } else {
              aliases[alias] = filter;
          }
      },

      undefine: function (alias, filter) {
          if (_exists(aliases, alias)) {
              delete aliases[alias];
          } else {
              throw('Unknown filter alias ' + alias);
          }
      },

      lookup: function (alias) {
          if (_exists(aliases, alias)) {
              return aliases[alias];
          }

          return null;
      }
    });

    return Filter;

  })();

  // Add underscore methods
  _.each(['filter','first','invoke','last','reject','select','shuffle','sortBy','without'], function (key) {
    Backbone.Filters[key] = Backbone.Filter.extend({
      constructor: function () {
        this.args = _slice.call(arguments, 0);
      },
      run: function (collection) {
        var models = _[key].apply(_, [collection.models].concat(this.args));
        return new collection.constructor(models);
      }
    });
  });

  // Evaluates a single filter, a chained array of filters, or a 
  // string list of filter aliases
  var runFilters = function (collection, filter) {

    var args = _slice.call(arguments, 2),
        recurse = function (filter) {
          collection = runFilters.apply(this, [collection, filter].concat(args))
        };

    if (filter instanceof Backbone.Filter) {
      collection = filter.run(collection, args);
    }
    else {
      if (_.isString(filter)) {
        filter = _.map(filter.split('|'), Backbone.Filter.lookup)
      }
      _.each(filter, recurse);
    }

    return collection;
  };

  // Patch `Backbone.Collection.filter` method to support filters
  Backbone.Collection.prototype.filter = function (filter) {
    if (_.isFunction(filter)) {
      return oldFilter.apply(this, arguments);
    }
    else {
      return runFilters.apply(this, [this].concat(_slice.call(arguments)));
    }
  };

}));
