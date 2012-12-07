Backbone Filters
================

Recycleable filters for Backbone collections. Create, bind, chain, and 
recycle your own!

    // A collection
    var myCollection = new MyCollection([
      { name: 'Cathcart' },
      { name: 'Yossarian' },
      { name: 'Peckem' },
      { name: 'Dreedle' }
    ]);

    // A filter
    var nameFilter = new Backbone.Filters.select(function (model) {
        var names = ['Cathcart', 'Peckem', 'Dreedle'];
        return names.indexOf(model.get('name')) > -1;
    });

    // Everyone but Yossarian
    var results = myCollection.filter(nameFilter); 

Or apply a list of filters in sequence!

    var orderByNameFilter = new Backbone.Filters.sortBy(function (model) {
        return model.get('name');
    });

    var results = myCollection.filter([nameFilter, orderByNameFilter]);
    //  results = Cathcart, Dreedle, Peckem

### Using built-in filters

To create a filter based on one of the provided filter classes, just create
a new instance of the filter with appropriate arguments:

    var limit3 = new Backbone.Filter.first(3);

Passing the filter to a collection's `filter` method will return a new
collection containing the filter's results. In this case, the first three
items of the collection will be returned:

    var first3 = myCollection.filter(limit3);

### Writing filter classes

Filters are derived from `Backbone.Filter` and include a `run` method for
accepting `Backbone.Collection` arguments. Beyond that, though, development
is their show.

    var MyFilterClass = Backbone.Filter.extend({
      run: function (collection) {
        // filter+return
      }
    });

### Filter chaining

Unless a filter returns a single value (see the `Stats` filters for an example),
it will probably want to return an instance of the same `Collection` classes to
be used by subsequent filters. What really matters, though, is that the output
of each preceding filter matches the input expected by the next filter in a 
chain.

## Built-in filters

To get things started, `Backbone.Filter` provides filter classes for many of the 
[underscore methods](http://documentcloud.github.com/backbone/#Collection-Underscore-Methods).
The ones attached to `Backbone.Filters` straight out of the box are:

* filter
* first
* invoke
* last
* reject
* select
* shuffle
* sortBy
* without

A few other filters provide really basic statistical utilities for the attributes
of models in a collection. By default, they're also attached to `Backbone.Filters`

* Stats.Sum
* Stats.Mean
* Stats.Median
* Stats.Stdev

