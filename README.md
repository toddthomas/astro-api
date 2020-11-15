# Astro API

Astro API is a proof-of-concept of a RESTful JSON API for searching the [SIMBAD](http://simbad.u-strasbg.fr/simbad/) astronomical database. Currently it supports searching for stars only, and filtering by limiting magnitude and constellation (with some [caveats](#Caveats)).

## Motivation

SIMBAD is widely used by professional and amateur astronomers. At the time of this writing, it contained information on 11,526,886 astronomical objects. However, its [API](http://simbad.u-strasbg.fr/simbad/sim-help?Page=sim-url) is quirky and decidedly not RESTful. I wanted to see if I could wrap it with a more modern and ergonomic API.

## Tutorial

The code in this repository is deployed on Heroku at https://secure-springs-70266.herokuapp.com. Let's try it out.

### Stars
The `/stars` resource lets you search for stars. JSON is the only supported representation of the results.

```http request
GET https://secure-springs-70266.herokuapp.com/stars
Accept: application/json
```

That gives a response with a body like this
```json
{
  "search": {
    "params": {
      "model_class_name": "Star",
      "constellation_abbreviation": null,
      "limiting_magnitude": null,
      "max_results": 100,
      "sort_by": "identifier"
    },
    "result_count": 100,
    "results": [
      {
        "star": {
          "identifier": "BD+35 4333",
          "object_type": "*",
          "spectral_type": "A2",
          "coordinates": "RA 20h 56m 38.5275565387s Dec +36° 19' 49.734260067\"",
          "visual_magnitude": 9.45
        }
      },
```
Then there are 99 more stars I've omitted to save your scrolling finger.

There are a lot of stars in the sky! By default, searches return a maximum of 100 results, but in this case, I don't know how SIMBAD picks these 100 stars out of the millions in its database. We need to narrow our search. For example, we can find all stars with a visual magnitude brighter than 2.

```http request
GET https://secure-springs-70266.herokuapp.com/stars?limiting_magnitude=2
Accept: application/json
```

```json
{
  "search": {
    "params": {
      "model_class_name": "Star",
      "constellation_abbreviation": null,
      "limiting_magnitude": 2.0,
      "max_results": 100,
      "sort_by": "identifier"
    },
    "result_count": 56,
    "results": [
      {
        "star": {
          "identifier": "* alf Aql",
          "object_type": "dS*",
          "spectral_type": "A7Vn",
          "coordinates": "RA 19h 50m 46.99855s Dec +8° 52' 5.9563\"",
          "visual_magnitude": 0.76
        }
      },
```

(Again, I've omitted all but the first result.) The default maximum of 100 results still applies here, but note that there are only 56 in this case, so I think we've found all the stars in SIMBAD with a magnitude greater than 2.

You can set the maximum number of results to something else if you like.

```http request
GET https://secure-springs-70266.herokuapp.com/stars?limiting_magnitude=2&max_results=1
Accept: application/json
```

```json
{
  "search": {
    "params": {
      "model_class_name": "Star",
      "constellation_abbreviation": null,
      "limiting_magnitude": 2.0,
      "max_results": 1,
      "sort_by": "identifier"
    },
    "result_count": 1,
    "results": [
      {
        "star": {
          "identifier": "* alf Cyg",
          "object_type": "sg*",
          "spectral_type": "A2Ia",
          "coordinates": "RA 20h 41m 25.91514s Dec +45° 16' 49.2197\"",
          "visual_magnitude": 1.25
        }
      }
    ]
  }
}
```

By the way, SIMBAD responds with a completely different resource representation when you request only one result. I didn't know that until I was testing the above example while writing this readme. That's the kind of quirkiness that motivates this wrapper API.

You can't set `max_results` larger than 1000, because I haven't done extensive testing with large values, and I don't want to blow up SIMBAD or Heroku.

```http request
GET https://secure-springs-70266.herokuapp.com/stars?limiting_magnitude=2&max_results=1000000000000
Accept: application/json
```

```json
{
  "error": {
    "message": "{:max_results=>[\"must be an integer no greater than 1000\"]}"
  }
}
```

By default, results are sorted by identifier. You can sort by other star properties, such as visual magnitude, if you like.

```http request
GET https://secure-springs-70266.herokuapp.com/stars?limiting_magnitude=0&sort_by=visual_magnitude
Accept: application/json
```

```json
{
  "search": {
    "params": {
      "model_class_name": "Star",
      "constellation_abbreviation": null,
      "limiting_magnitude": 0.0,
      "max_results": 100,
      "sort_by": "visual_magnitude"
    },
    "result_count": 4,
    "results": [
      {
        "star": {
          "identifier": "* alf CMa",
          "object_type": "SB*",
          "spectral_type": "A1V+DA",
          "coordinates": "RA 6h 45m 8.91728s Dec -16° 42' 58.0171\"",
          "visual_magnitude": -1.46
        }
      },
      {
        "star": {
          "identifier": "* alf Car",
          "object_type": "*",
          "spectral_type": "A9II",
          "coordinates": "RA 6h 23m 57.10988s Dec -52° 41' 44.381\"",
          "visual_magnitude": -0.74
        }
      },
      {
        "star": {
          "identifier": "* alf Cen",
          "object_type": "**",
          "spectral_type": "G2V+K1V",
          "coordinates": "RA 14h 39m 29.71993s Dec -60° 49' 55.999\"",
          "visual_magnitude": -0.1
        }
      },
      {
        "star": {
          "identifier": "* alf Boo",
          "object_type": "RG*",
          "spectral_type": "K1.5IIIFe-0.5",
          "coordinates": "RA 14h 15m 39.67207s Dec +19° 10' 56.673\"",
          "visual_magnitude": -0.05
        }
      }
    ]
  }
}
```

This time I included all four results. Compare with Wikipedia's [list of the brightest stars](https://en.wikipedia.org/wiki/List_of_brightest_stars).

[Astronomical magnitude](https://en.wikipedia.org/wiki/Magnitude_(astronomy)) is an ancient concept. It was originally a ranking of brightness into tiers, like "1st brightest", 2nd brightest", "5th brightest", etc. Later it was formalized into a logarithmic scale, but it's still the case that the smaller the magnitude value, the brighter the object. This app sorts objects into ascending order (descending order is currently not available), but due to the inversion of the scale for magnitudes, objects sorted in order of ascending magnitude are ordered in descending brightness.

Query parameters are validated. For example, setting `limiting_magnitude` to a non-numeric value results in a "400: Bad Request" response.
```http request
GET https://secure-springs-70266.herokuapp.com/stars?limiting_magnitude=foo
Accept: application/json
```

```json
{
  "error": {
    "message": "{:limiting_magnitude=>[\"is not a number\"]}"
  }
}
```

If you know what star you're looking for, you can ask for it by name. Let's look up [Aldebaran](https://en.wikipedia.org/wiki/Aldebaran), the brightest star in Taurus.

```http request
GET http://secure-springs-70266.herokuapp.com/stars/Aldebaran
Accept: application/json
```

```json
{
  "star": {
    "identifier": "* alf Tau",
    "object_type": "LP?",
    "spectral_type": "K5+III",
    "coordinates": "RA 4h 35m 55.23907s Dec +16° 30' 33.4885\"",
    "visual_magnitude": 0.86
  }
}
```

If you know SIMBAD's idiosyncratic identifier syntax—`* alf Tau` means Alpha Tauri, another name for Aldebaran—you can use that directly.

```http request
GET http://secure-springs-70266.herokuapp.com/stars/*%20alf%20Tau
Accept: application/json
```

```json
{
  "star": {
    "identifier": "* alf Tau",
    "object_type": "LP?",
    "spectral_type": "K5+III",
    "coordinates": "RA 4h 35m 55.23907s Dec +16° 30' 33.4885\"",
    "visual_magnitude": 0.86
  }
}
```

SIMBAD knows a lot of identifiers for each celestial object in its database. Yet another name for Aldebaran is HD 29139, which comes from the [_Henry Draper Catalogue_](https://en.wikipedia.org/wiki/Henry_Draper_Catalogue).

```http request
GET http://secure-springs-70266.herokuapp.com/stars/HD%2029139
Accept: application/json
```

```json
{
  "star": {
    "identifier": "* alf Tau",
    "object_type": "LP?",
    "spectral_type": "K5+III",
    "coordinates": "RA 4h 35m 55.23907s Dec +16° 30' 33.4885\"",
    "visual_magnitude": 0.86
  }
}
```

You'll get a 404 if SIMBAD can't make any sense out of the identifier you provide.

```http request
GET http://secure-springs-70266.herokuapp.com/stars/beeblebrox
Accept: application/json
```

```json
{
  "error": {
    "message": "can't find star identified by 'beeblebrox'"
  }
}
```

### Constellations

Still, it's a really big universe. How can we narrow our search for interesting stars even further? The app knows about all 88 constellations as defined by the International Astronomical Union. These data were scraped from https://www.iau.org/public/themes/constellations, and there is a rake task (`constellations:generate_yaml`) to regenerate the file where they are stored.

You can list all constellations.
```http request
GET https://secure-springs-70266.herokuapp.com/constellations
Accept: application/json
```

```json
{
  "constellations": [
    {
      "constellation": {
        "name": "Andromeda",
        "abbreviation": "And",
        "genitive": "Andromedae",
        "description": "the Chained Maiden"
      }
    },
```

(Plus 87 more.)

You can get the JSON representation for a particular constellation, like Orion.
```http request
GET https://secure-springs-70266.herokuapp.com/constellations/orion
Accept: application/json
```

```json
{
  "constellation": {
    "name": "Orion",
    "abbreviation": "Ori",
    "genitive": "Orionis",
    "description": "the Hunter"
  }
}
```

But you can't get the JSON representation for a constellation that doesn't exist.
```http request
GET https://secure-springs-70266.herokuapp.com/constellations/baz
Accept: application/json
```

```json
{
  "error": {
    "message": "no constellation identified by 'baz'"
  }
}
```

To help navigate in a big universe, you can filter your star search by constellation (with some [caveats](#Caveats)). For example, get all stars with visual magnitude brighter than 3 in Crux, the Southern Cross.
```http request
GET https://secure-springs-70266.herokuapp.com/constellations/crux/stars?limiting_magnitude=3
Accept: application/json
```

```json
{
  "search": {
    "params": {
      "model_class_name": "Star",
      "constellation_abbreviation": "crux",
      "limiting_magnitude": 3.0,
      "max_results": 100,
      "sort_by": "identifier"
    },
    "result_count": 5,
    "results": [
      {
        "star": {
          "identifier": "* alf01 Cru",
          "object_type": "*",
          "spectral_type": "B0.5IV",
          "coordinates": "RA 12h 26m 35.896s Dec -63° 5' 56.73\"",
          "visual_magnitude": 1.28
        }
      },
      {
        "star": {
          "identifier": "* alf02 Cru",
          "object_type": "*",
          "spectral_type": "B1V",
          "coordinates": "RA 12h 26m 36.442s Dec -63° 5' 58.28\"",
          "visual_magnitude": 1.58
        }
      },
      {
        "star": {
          "identifier": "* bet Cru",
          "object_type": "bC*",
          "spectral_type": "B1IV",
          "coordinates": "RA 12h 47m 43.26877s Dec -59° 41' 19.5792\"",
          "visual_magnitude": 1.25
        }
      },
      {
        "star": {
          "identifier": "* del Cru",
          "object_type": "Pu*",
          "spectral_type": "B2IV",
          "coordinates": "RA 12h 15m 8.7167245s Dec -58° 44' 56.136936\"",
          "visual_magnitude": 2.752
        }
      },
      {
        "star": {
          "identifier": "* gam Cru",
          "object_type": "PM*",
          "spectral_type": "M3.5III",
          "coordinates": "RA 12h 31m 9.95961s Dec -57° 6' 47.5684\"",
          "visual_magnitude": 1.64
        }
      }
    ]
  }
}
```

## Caveats

Currently, only some constellations can be used for filtering. The implementation of filtering by constellation requires constellation boundary data in the form of the vertices of the polygon comprising the boundary. The constellation data I scraped from the IAU at https://www.iau.org/public/themes/constellations includes these vertices, and the app appears to be submitting them correctly to SIMBAD, but for many constellations, no results are returned. I thought that might be due to a limit on the number of vertices that SIMBAD can process, but it doesn't seem to be that simple. It may be that the vertex data I obtained isn't accurate enough. The Rake task `constellations:search_in_all` generates a report in the file `results-for-all-constellations.txt` of the success or failure of attempting to find stars in each constellation. See that file to learn which constellation filters are working.

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

Galaxies! And other objects.
```http request
GET https://secure-springs-70266.herokuapp.com/galaxies?limiting_magnitude=14.0&type=spiral
```

```http request
GET https://secure-springs-70266.herokuapp.com/galaxies/ngc4565
```

```http request
GET https://secure-springs-70266.herokuapp.com/nebulae?type=emission
```

```http request
GET https://secure-springs-70266.herokuapp.com/nebulae/m42
```
