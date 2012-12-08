(function (Backbone) {

    Backbone.Filters = Backbone.Filters || {};

    _.extend(Backbone.Filters, {

        // Returns a collection with the order of the models reversed
        reverse: Backbone.Filter.extend({
            run: function (collection) {
                var models = collection.models;
                return new collection.constructor(models.reverse());
            }
        }),

        // Returns a collection containing all valid models from the
        // original collection
        valid: Backbone.Filter.extend({
            run: function (collection) {
                invalidFilter = new Backbone.Filters.select(function (m) {
                    return m.isValid();
                });
                return collection.filter(invalidFilter);
            }
        }),

        // Returns a collection containing all invalid models from the
        // original collection
        invalid: Backbone.Filter.extend({
            run: function (collection) {
                invalidFilter = new Backbone.Filters.reject(function (m) {
                    return m.isValid();
                });
                return collection.filter(invalidFilter);
            }
        })
    });

})(Backbone);

