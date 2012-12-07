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

Or you can apply a list of filters in sequence:

    var orderByNameFilter = new Backbone.Filters.sortBy(function (model) {
        return model.get('name');
    });

    var results = myCollection.filter([nameFilter,orderByNameFilter]);

To get things started, `Backbone.Filter` provides filter classes for many of the 
[underscore methods](http://documentcloud.github.com/backbone/#Collection-Underscore-Methods), 
including:

* filter
* invoke
* reject
* select
* shuffle
* sortBy
* without


