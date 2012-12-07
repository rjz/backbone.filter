Backbone Filters
================

Adds `Backbone.Filter` class for authoring collection filters. Create and chain reusable 
filters!

    // A filter
    var nameFilter = new Backbone.Filters.select(function (model) {
        var names = ['Cathcart', 'Peckem', 'Dreedle'];
        return names.indexOf(model.get('name')) > -1;
    });

    var myCollection = new MyCollection([
      { name: 'Cathcart' },
      { name: 'Yossarian' },
      { name: 'Peckem' },
      { name: 'Dreedle' }
    ]);

    var results = myCollection.filter(nameFilter); 
    //  results = Cathcart, Peckem, Dreedle

Or apply a list of filters in sequence!

    var orderByNameFilter = new Backbone.Filters.sortBy(function (model) {
        return model.get('name');
    });

    var results = myCollection.filter([nameFilter, orderByNameFilter]);
    //  results = Cathcart, Dreedle, Peckem

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


