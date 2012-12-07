Backbone Filters
================

Adds `Backbone.Filter` class for authoring collection filters. Create and chain reusable 
filters!

    // A filter
    var nameFilter = new Backbone.Filters.select(function (model) {
        var names = ['Cathcart', 'Peckem', 'Dreedle'];
        return names.indexOf(model.get('name')) > -1;
    });

    var results = myCollection.filter(nameFilter);

You can even pass an array of filters to be run in turn:

    var orderByNameFilter = new Backbone.Filters.sortBy(function (model) {
        return model.get('name');
    });

    var results = myCollection.filter([nameFilter,orderByNameFilter]);

