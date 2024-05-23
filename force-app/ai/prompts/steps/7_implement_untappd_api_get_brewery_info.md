Your task is to finish implementing a specific method. This is a two-part task.
The first part is to modify request parameters. The second part is to parse the
response into expected return type.

When you have completed the task, only respond with the specific method that you
have implemented. Remove all TODO comments.

The result of modifying request parameters must meet the following requirements:

- Use string concatenation to construct the `endpoint` URL
- Review the API documentation to see if parameters need to be passed in the URL
  or the request body
- Assume that the `createRequest(String endpoint)` has returned an `HttpRequest`
  that already has all authentication-related parameters set

The result of parsing the response into expected return type must meet the
following requirements:

- Use `JSON.deserializeUntyped` to parse the response body into a `result`
- Review the API documentation to see if the `result` should be a
  `Map<String, Object>` or `List<Object>`
- Review the API documentation to see how to extract data from the `result`
- Use the builder pattern to return the value in this object:

```apex
public class UntappdBrewery {
    private final Long id;
    private final String name;
    private final String description;
    private final String website;
    private final String street;
    private final String city;
    private final String state;
    private final List<UntappdBeer> beers;
}
public class UntappdBeer {
    private final Long id;
    private final Long breweryId;
    private final String name;
    private final String style;
    private final Decimal abv;
}
```

For example, here is the correct implementation of the `BurgerApi.searchBurgers`
and `BurgerApi.orderBurger` methods:

```apex
public List<Burger> searchBurgers(String query) {
  String endpoint = '/search/burger';
  HttpRequest httpRequest = createRequest(endpoint);
  httpRequest.setMethod('GET');
  addUrlParameter(httpRequest, 'q', query);

  HttpResponse httpResponse = send(httpRequest);
  List<Object> result = (List<Object>) JSON.deserializeUntyped(httpResponse.getBody());

  List<Burger> burgers = new List<Burger>();
  for (Object obj : result) {
    Map<String, Object> o = (Map<String, Object>) obj;

    burgers.add(
      Burger.newBuilder()
        .setBun((String) o.get('bun'))
        .setHasCheese((Boolean) o.get('has_cheese'))
        .setNumberOfPatties((Integer) o.get('number_of_patties'))
        .build()
    );
  }

  return burgers;
}

public BurgerOrderResponse orderBurger(BurgerOrderRequest request) {
  String endpoint = '/burger';
  HttpRequest httpRequest = createRequest(endpoint);
  httpRequest.setMethod('POST');
  httpRequest.setBody(request.toJson());

  HttpResponse httpResponse = send(httpRequest);
  Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(
    httpResponse.getBody()
  );

  return BurgerOrderResponse.newBuilder().setOrderId((String) result.get('order_id')).build();
}
```

Implement the `getBreweryInfo` method.

Here is the API documentation:

Brewery Info Authentication: Not Required HTTP Method: GET Endpoint:
/v4/brewery/info/BREWERY_ID This method will allow you to see extended
information about a brewery.

Parameters BREWERY_ID (int, required) - The Brewery ID that you want to display
checkins access_token or client_id and client_secret (string, required) - Either
pass the access_token for authorized calls OR the client_id and client_secret
for unauthorized calls compact (string, optional) - You can pass "true" here
only show the brewery infomation, and remove the "checkins", "media",
"beer_list", etc attributes

Example Response

```json
{
  "meta": {
    "code": 200,
    "response_time": {
      "time": 0.502,
      "measure": "seconds"
    },
    "init_time": {
      "time": 0,
      "measure": "seconds"
    }
  },
  "notifications": [],
  "response": {
    "brewery": {
      "brewery_id": 459,
      "brewery_name": "Dogfish Head Craft Brewery",
      "brewery_slug": "dogfish-head-craft-brewery",
      "brewery_page_url": "/dogfishbeer",
      "brewery_label": "https://assets.untappd.com/site/brewery_logos/brewery-459_75746.jpeg",
      "brewery_label_hd": "https://assets.untappd.com/site/brewery_logos_hd/brewery-459_21f0f_hd.jpeg",
      "country_name": "United States",
      "brewery_in_production": 0,
      "is_independent": 0,
      "claimed_status": {
        "is_claimed": true,
        "claimed_slug": "dogfishbeer",
        "follow_status": false,
        "follower_count": 207203,
        "uid": 108982,
        "mute_status": "none"
      },
      "beer_count": 1246,
      "contact": {
        "twitter": "dogfishbeer",
        "facebook": "http://www.facebook.com/dogfishheadbeer",
        "instagram": "dogfishhead",
        "url": "http://www.dogfish.com/"
      },
      "brewery_type": "Regional Brewery",
      "brewery_type_id": 11,
      "location": {
        "brewery_address": "6 Cannery Village Blvd",
        "brewery_city": "Milton",
        "brewery_state": "DE",
        "brewery_lat": 38.7776,
        "brewery_lng": -75.3099
      },
      "rating": {
        "count": 5616483,
        "rating_score": 3.84
      },
      "brewery_description": "Dogfish Head started in June 1995 when Dogfish Head Brewings & Eats was established in the beach community of Rehoboth Beach, Delaware. Dogfish Head was the first brewpub of the state. The original plan to deliver great music, delicious food and fine beers to the community came to life when the first batch of Shelter Pale Ale beers were started. Soon, Dogfish Head engaged in brewing 12 gallons of beer batches to supply the restaurant’s need. Dogfish Head brewery quickly achieved popularity beyond the state and reaches to nearby areas like Philadelphia and Washington D.C. By 2000, Dogfish Head is selling over 20 types of beers in 30 states.",
      "stats": {
        "total_count": 8562266,
        "unique_count": 1097186,
        "monthly_count": 7013,
        "weekly_count": 231,
        "user_count": 0,
        "age_on_service": 4996.143067129629
      },
      "owners": {
        "count": 1,
        "items": [
          {
            "brewery_id": 0,
            "is_brewery_group": 1,
            "brewery_name": "The Boston Beer Company"
          }
        ]
      },
      "beer_list": {
        "show_all_beers": false,
        "has_not_had_before": false,
        "source": "info",
        "total_count": 1246,
        "is_search": false,
        "type_id": false,
        "sort": false,
        "is_multi_type": false,
        "count": 25,
        "items": [
          {
            "total_user_count": 0,
            "has_had": null,
            "total_count": 987990,
            "beer": {
              "bid": 3952,
              "beer_name": "60 Minute IPA",
              "beer_label": "https://assets.untappd.com/site/beer_logos/beer-3952_1420e_sm.jpeg",
              "beer_style": "IPA - American",
              "beer_abv": 6,
              "beer_ibu": 60,
              "beer_slug": "dogfish-head-craft-brewery-60-minute-ipa",
              "beer_description": "60 Minute IPA is continuously hopped -- more than 60 hop additions over a 60-minute boil. Getting a vibe of where the name came from? 60 Minute is brewed with a slew of great Northwest hops. A powerful but balanced East Coast IPA with a lot of citrusy hop character, it's the session beer for hardcore enthusiasts!",
              "is_in_production": 1,
              "created_at": "Sat, 21 Aug 2010 14:26:35 +0000",
              "user_rating_score": 0,
              "rating_score": 3.84,
              "rating_count": 403756,
              "has_had": null,
              "on_list": false,
              "auth_rating": 0,
              "wish_list": false
            },
            "brewery": {
              "brewery_id": 459,
              "brewery_name": "Dogfish Head Craft Brewery",
              "brewery_slug": "dogfish-head-craft-brewery",
              "brewery_page_url": "/dogfishbeer",
              "brewery_type": "Regional Brewery",
              "brewery_label": "https://assets.untappd.com/site/brewery_logos/brewery-459_75746.jpeg",
              "country_name": "United States",
              "contact": {
                "twitter": "dogfishbeer",
                "facebook": "http://www.facebook.com/dogfishheadbeer",
                "instagram": "dogfishhead",
                "url": "http://www.dogfish.com/"
              },
              "location": {
                "brewery_city": "Milton",
                "brewery_state": "DE",
                "lat": 38.7775993,
                "lng": -75.3098984
              },
              "brewery_active": 1
            },
            "friends": {
              "items": [],
              "count": 0
            }
          },
          {
            "total_user_count": 0,
            "has_had": null,
            "total_count": 803201,
            "beer": {
              "bid": 8056,
              "beer_name": "90 Minute Imperial IPA",
              "beer_label": "https://assets.untappd.com/site/beer_logos/beer-8056_db7aa_sm.jpeg",
              "beer_style": "IPA - Imperial / Double",
              "beer_abv": 9,
              "beer_ibu": 90,
              "beer_slug": "dogfish-head-craft-brewery-90-minute-imperial-ipa",
              "beer_description": "Esquire Magazine calls our 90 Minute IPA \"perhaps the best IPA in America.\" An imperial IPA best savored from a snifter, 90 Minute has a great malt backbone that stands up to the extreme hopping rate. ",
              "is_in_production": 1,
              "created_at": "Mon, 08 Nov 2010 19:02:57 +0000",
              "user_rating_score": 0,
              "rating_score": 4.045,
              "rating_count": 363818,
              "has_had": null,
              "on_list": false,
              "auth_rating": 0,
              "wish_list": false
            },
            "brewery": {
              "brewery_id": 459,
              "brewery_name": "Dogfish Head Craft Brewery",
              "brewery_slug": "dogfish-head-craft-brewery",
              "brewery_page_url": "/dogfishbeer",
              "brewery_type": "Regional Brewery",
              "brewery_label": "https://assets.untappd.com/site/brewery_logos/brewery-459_75746.jpeg",
              "country_name": "United States",
              "contact": {
                "twitter": "dogfishbeer",
                "facebook": "http://www.facebook.com/dogfishheadbeer",
                "instagram": "dogfishhead",
                "url": "http://www.dogfish.com/"
              },
              "location": {
                "brewery_city": "Milton",
                "brewery_state": "DE",
                "lat": 38.7775993,
                "lng": -75.3098984
              },
              "brewery_active": 1
            },
            "friends": {
              "items": [],
              "count": 0
            }
          },
          {
            "total_user_count": 0,
            "has_had": null,
            "total_count": 371725,
            "beer": {
              "bid": 4996,
              "beer_name": "Punkin Ale",
              "beer_label": "https://assets.untappd.com/site/beer_logos/beer-4946504_b39d1_sm.jpeg",
              "beer_style": "Pumpkin / Yam Beer",
              "beer_abv": 7,
              "beer_ibu": 28,
              "beer_slug": "dogfish-head-craft-brewery-punkin-ale",
              "beer_description": "A full-bodied brown ale with smooth hints of pumpkin and brown sugar. We brew our Punkin Ale with pumpkin meat, brown sugar and spices. As the season cools, this is the perfect beer to warm up with. ",
              "is_in_production": 1,
              "created_at": "Sat, 21 Aug 2010 14:26:35 +0000",
              "user_rating_score": 0,
              "rating_score": 3.742,
              "rating_count": 207315,
              "has_had": null,
              "on_list": false,
              "auth_rating": 0,
              "wish_list": false
            },
            "brewery": {
              "brewery_id": 459,
              "brewery_name": "Dogfish Head Craft Brewery",
              "brewery_slug": "dogfish-head-craft-brewery",
              "brewery_page_url": "/dogfishbeer",
              "brewery_type": "Regional Brewery",
              "brewery_label": "https://assets.untappd.com/site/brewery_logos/brewery-459_75746.jpeg",
              "country_name": "United States",
              "contact": {
                "twitter": "dogfishbeer",
                "facebook": "http://www.facebook.com/dogfishheadbeer",
                "instagram": "dogfishhead",
                "url": "http://www.dogfish.com/"
              },
              "location": {
                "brewery_city": "Milton",
                "brewery_state": "DE",
                "lat": 38.7775993,
                "lng": -75.3098984
              },
              "brewery_active": 1
            },
            "friends": {
              "items": [],
              "count": 0
            }
          }
        ]
      }
    }
  }
}
```

Make sure to parse the `List<UntappdBeer>` out of `response.brewery.beer_list`.
