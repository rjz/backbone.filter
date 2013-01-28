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
        }),
        limit2 = new Backbone.Filters.first(2);

    // Applying a filter chain
    var filters = [
            nameFilter,        // Remove Yossarian
            orderByNameFilter, // Sort by name
            limit2             // Pick first two names
        ];
        
     var firstTwo = myCollection.filter(filters);

### Using built-in filters

To create a filter based on one of the provided filter classes, just create
new instances of filter with appropriate arguments. Passing the filter to a 
collection's `filter` method will return a new collection containing the 
filter's results. In this case, the first three items of the collection will 
be returned:

    var random = new Backbone.Filter.shuffle,
        limit3 = new Backbone.Filter.first(3);

    var first3 = myCollection.filter(limit3);
    var entropized = myCollection.filter(random)

They can also be chained using array notation:

    var random3 = myCollection.filter([random,limit3]);

### Writing filter classes

Filters are derived from `Backbone.Filter`. They'll need to include a `run` 
method that accepts a single `Backbone.Collection` arguments, but the details
of their implementation are left intentionally vague:

    var MyFilterClass = Backbone.Filter.extend({
      run: function (collection) {
        // filter+return
      }
    });

### Filter chaining

Filters that don't reduce to a single value (e.g. the included `Stats` filters)
will probably want to return an instance of the same `Collection` class that
they received. As long as each filter in a chain returns a result that the next
filter can understand, however, chains of filters will run to completion.

### Included filters

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
* Stats.Min
* Stats.Max
* Stats.Range
* Stats.Limits
* Stats.Variance
* Stats.Stdev

## Contributing

Contributions are welcome!

  1. Fork this repo
  2. Add your changes and update the spec as needed
  3. Submit a [pull request](help.github.com/pull-requests/)

## License

MIT License
