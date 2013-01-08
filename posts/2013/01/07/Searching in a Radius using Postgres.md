Creating a GEO application has never been easier. You can have a fully working "What's close to me" in a matter of minutes using some great open-source tools.

Postgres has lots of features. With the biggest in my opinion being extensions. Which take this amazing Database platform to the next level.

## Options

When writing a app that wishes to use Postgres for GEO functions you have 2 choices (to the best of my knowledge):

* PostGis which provides advance GEO functions to Postgres. I've played with it and it seems way to bulky for my needs
* Cube and EarthDistance, these 2 extensions provide easy to use and very fast methods to accomplish some of the more minor geo related activities.

## Why do the calculations in a database server

It should be pretty obvious. The server already has all the data and with extensions being written in c / c++ it's very fast. 

An Index can also be added for a even bigger boost.

## Using my Choice - Cube and EarthDistance

To start using these 2 extensions you will need to create a database (which I take it you know how to do) and "create" / enable them for use by the schema you'll be using.

To do this run

<pre class="prettyprint">CREATE EXTENSION cube;</pre>

and

<pre class="prettyprint">CREATE EXTENSION earthdistance;</pre>

This will create +-44 functions that will be usable by your queries.

<strong style="color:red;">For our examples I created a table named events with a id (serial), name (varchar 255), lat (double) and lng (double) columns. Be sure to keep that in mind.</strong>

### Calculating the distance between coordinates

To calculate the distance between 2 coordinates we use <code>earth_distance(ll_to_earth($lat_lng_cube), ll_to_earth($lat_lng_cube))</code>. This functions allows us to pass 2 sets of coordinates and it will return a numerical value representing metres.

This can be used for many things such as ordering according to events that are nearest to a certain location. An example of which would be:

<pre class="prettyprint">SELECT events.id, events.name, earth_distance(ll_to_earth( {current_user_lat}, {current_user_lng} ), ll_to_earth(events.lat, events.lng)) as distance_from_current_location FROM events ORDER BY distance_from_current_location ASC;</pre>

This will give us a nice list of events sorted by their distance to our current location. With the closest being first.

### Finding Records in a Radius

Another great function provided by these extensions is the <code>earth_box(ll_to_earth($lat_lng_cube), $radius_in_metres)</code> this function allows us to perform a simple compare to find all records in a certain radius. This is done by the function by returning the great circle distance between the points, a more thorough explanation is located at <a href="http://en.wikipedia.org/wiki/Great_circle">http://en.wikipedia.org/wiki/Great_circle</a>. 

This could be used to show all events in our current city.

An example of such a query:

<pre class="prettyprint">SELECT events.id, events.name FROM events WHERE earth_box( {current_user_lat}, {current_user_lng}, {radius_in_metres}) @> ll_to_earth(events.lat, events.lng);</pre>

This Query would then only return the records in that radius. Pretty easy !

## Speeding up these queries

You might have noticed that these queries could get pretty expensive. In my experience it's best to ensure that the table has a index for these fields. This is created using:

<pre class="prettyprint">CREATE INDEX ${name_of_index} on events USING gist(ll_to_earth(lat, lng));</pre>

This will pre-calculate the degrees for each of the coordinates that will make the above queries run much faster as it's not doing those calculations on each row for each run.

This of course assumes that you have a table named events which has a lat and lng column.

### Datatypes 

For my quick app I simply used double datatypes for my <strong>lat</strong> and <strong>lng</strong> columns. This allowed me to use it with one of the NodeJS ORM's that made development much quicker, instead of having to find some custom solution to handle the other GIST datatypes.

## That's it !

Amazing right ?!? We've just built a quick database that is able to handle some GEO functions to build amazing mapping and GEO social apps !