# Astro API

Astro API is a proof-of-concept of a RESTful JSON API for searching the [SIMBAD](http://simbad.u-strasbg.fr/simbad/) astronomical database. Currently it supports searching for stars only, and filtering by constellation[^1] and limiting magnitude.

[^1]: Currently, only a few constellations can be used for filtering. The implementation of filtering by constellation requires constellation boundary data in the form of the vertices of the polygon comprising the boundary. I've obtained such vertices for all constellations from the IAU at [https://www.iau.org/public/themes/constellations], and the app appears to be submitting the vertices correctly to SIMBAD, but for many constellations, no results are returned. I thought that might be due to a limit on the number of vertices that SIMBAD can process, but it doesn't seem to be that simple. It may be that the vertex data I obtained isn't accurate enough.

## Motivation

SIMBAD is widely used by professional and amateur astronomers. At the time of this writing, it contained information on 11,526,886 astronomical objects. However, its [API](http://simbad.u-strasbg.fr/simbad/sim-help?Page=sim-url) is quirky and decidedly not RESTful. I wanted to see if I could wrap it with a more modern and ergonomic API.

## Tutorial

The code in this repository is deployed on Heroku at [https://secure-springs-70266.herokuapp.com]. Let's try it out.

### Stars
The `/stars` resource lets you search for stars. JSON is the only supported representation of the results.

```http request
GET https://secure-springs-70266.herokuapp.com/stars
Accept: application/json
```

But there are a lot of stars! By default, a maximum of 100 results are returned, but they could be any of the millions of stars in SIMBAD's database. We need to narrow our search. For example, we can find all stars with a visual magnitude brighter than 2.

```http request
GET https://secure-springs-70266.herokuapp.com/stars?limiting_magnitude=2
Accept: application/json
```

The default maximum of 100 results still applies here. You can set the maximum number of results to something else if you like.

```http request
GET https://secure-springs-70266.herokuapp.com/stars?limiting_magnitude=2&max_results=10
Accept: application/json
```

By default, results are sorted by identifier. You can sort by other star properties, such as visual magnitude, if you like.

```http request
GET https://secure-springs-70266.herokuapp.com/stars?limiting_magnitude=2&sort_by=visual_magnitude
Accept: application/json
```
Astronomical magnitudes are an ancient concept. They were originally a ranking of brightness into distinct tiers, like "1st brightest", 2nd brightest", "5th brightest", etc. Later they were formalized into a logarithmic scale, but it's still the case that smaller the magnitude value, the brighter the object. This app sorts objects into ascending order (descending order is currently not available), but due to the inversion of the scale for magnitudes, that still means objects sorted by magnitude are ordered in descending brightness.

Query parameters are validated. For example, setting `limiting_magnitude` to a non-numeric value results in a "400: Bad Request" response.
```http request
GET https://secure-springs-70266.herokuapp.com/stars?limiting_magnitude=shazbot
Accept: application/json
```

### Constellations

Still, it's a really big universe. How can we narrow our search for interesting stars even further? The app knows about all 88 constellations as defined by the International Astronomical Union. These data were scraped from https://www.iau.org/public/themes/constellations, and there is a rake task (`constellations:generate_yaml`) to regenerate the file where they are stored.

You can list all 88 IAU constellations.
```http request
GET https://secure-springs-70266.herokuapp.com/constellations
Accept: application/json
```

You can get the JSON representation for a particular constellation, like Orion.
```http request
GET https://secure-springs-70266.herokuapp.com/constellations/orion
Accept: application/json
```

But you can't get the JSON representation for a constellation that doesn't exist.
```http request
GET https://secure-springs-70266.herokuapp.com/constellations/baz
Accept: application/json
```

To help navigate in a big universe, you can filter your star search by constellation. For example, get all stars with visual magnitude brighter than 4 in Crux.
```http request
GET https://secure-springs-70266.herokuapp.com/constellations/Cru/stars?limiting_magnitude=4
Accept: application/json
```

## Unimplemented API Ideas

That's it for what you can currently do with the API. Here are some things I'd like to be able to do with it in the future.

Get a list of stellar types in SIMBAD's object hierarchy. Or should this be done only with query params?
```http request
GET https://secure-springs-70266.herokuapp.com/stars/types
Accept: application/json # I won't repeat this for the remainder of this document.
```

Get a list of [carbon stars](https://en.wikipedia.org/wiki/Carbon_star) brighter than mag 5.
```http request
GET https://secure-springs-70266.herokuapp.com/stars/types/carbon?limiting_magnitude=2
```
Carbon stars are really exciting to view in a telescope because they have a deep reddish-orange color. "carbon" is a convenience term that doesn't match SIMBAD's type identifier for carbon stars (`C*`), so a mapping would have to be established.

Get the JSON data for [Betelgeuse](https://en.wikipedia.org/wiki/Betelgeuse).
```http request
GET https://secure-springs-70266.herokuapp.com/stars/betelgeuse
```
The SIMBAD API for this has a completely different entity format, so it requires a new parser.

Galaxies! And other objects.
```http request

GET https://secure-springs-70266.herokuapp.com/galaxies?limiting_magnitude=14.0&type=spiral
###
GET https://secure-springs-70266.herokuapp.com/galaxies/ngc4565
###
GET https://secure-springs-70266.herokuapp.com/nebulae?type=emission
###
GET https://secure-springs-70266.herokuapp.com/nebulae/m42
```
