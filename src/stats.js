(function (Backbone) {

    Backbone.Filters = Backbone.Filters || {};

    Stats = {};

    var Base = Backbone.Filter.extend({

        defaults: {
            attribute: ''
        },

        sort: function (collection) {
            var attribute = this.options.attribute,
                sortFilter = new Backbone.Filters.sortBy(function(m) {
                    return m.get(attribute);
                });
            return collection.filter(sortFilter);
        },

        stat: function (op, collection) {
            var statFilter = new Stats[op]({
                attribute: this.options.attribute
            });
            return collection.filter(statFilter);
        }
    });

    Stats.Sum = Base.extend({
        run: function (collection) {
            var attribute = this.options.attribute;
            return collection.reduce(function (memo, model) {
                return memo + model.get(attribute);
            }, 0);
        }
    });

    Stats.Mean = Base.extend({
        run: function (collection) {
            return this.stat('Sum', collection) / collection.length;
        }
    });

    Stats.Median = Base.extend({
        run: function (collection) {
            var lo, hi, 
                attribute = this.options.attribute,
                sorted = this.sort(collection),
                index = Math.floor((sorted.length - 1) / 2);

            if (sorted.length % 2) {
              return sorted.at(index).get(attribute);
            } else {
              lo = sorted.at(index).get(attribute);
              hi = sorted.at(index + 1).get(attribute);
              return (lo + hi) / 2;
            }
        }
    });

    Stats.Stdev = Base.extend({

        run: function (collection) {

            var attribute = this.options.attribute,
                mean = this.stat('Mean', collection);
                xbar = collection.reduce(function(memo, m) {
                    return memo + Math.pow(m.get(attribute) - mean, 2);
                }, 0);

            return Math.sqrt(xbar / collection.length);
        }
    });

    Backbone.Filters.Stats = Stats;

})(Backbone);

