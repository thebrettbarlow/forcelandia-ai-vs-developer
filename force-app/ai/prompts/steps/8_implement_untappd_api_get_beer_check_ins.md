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
public class UntappdCheckIn {
  private final Long id;
  private final Long beerId;
  private final Decimal rating;
  private final String comment;
  private final Datetime dt;
  private final Integer toasts;
  private final Integer comments;
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

Implement the `getBeerCheckIns` method.

Here is the API documentation:

Beer Activity Feed Authentication: Not Required HTTP Method: GET Endpoint:
/v4/beer/checkins/BID Note: This will return only users who have made their
account public.

This method allows you the obtain an activity feed for a single beer for
Untappd. By default it will return at max 25 records

Parameters BID (int, required) - The beer ID that you want to display checkins
access_token or client_id and client_secret (string, required) - Either pass the
access_token for authorized calls OR the client_id and client_secret for
unauthorized calls max_id (int, optional) - The checkin ID that you want the
results to start with min_id (int, optional) - Returns only checkins that are
newer than this value limit (int, optional) - The number of results to return,
max of 25, default is 25

Example Response

```json
{
  "meta": {
    "code": 200,
    "response_time": {
      "time": 0.133,
      "measure": "seconds"
    },
    "init_time": {
      "time": 0,
      "measure": "seconds"
    }
  },
  "notifications": [],
  "response": {
    "pagination": {
      "since_url": "https://api.untappd.com/v4/beer/checkins/3839?utv=3.5.0&max_id=1383135177",
      "next_url": "https://api.untappd.com/v4/beer/checkins/3839?utv=3.5.0&max_id=1383135177",
      "max_id": 1383135177
    },
    "checkins": {
      "count": 25,
      "items": [
        {
          "checkin_id": 1383158057,
          "created_at": "Thu, 23 May 2024 01:53:54 +0000",
          "checkin_comment": "",
          "rating_score": 4.75,
          "user": {
            "uid": 1687301,
            "user_name": "JimInKC",
            "first_name": "Jim",
            "last_name": "K",
            "location": "Kansas City MO",
            "url": "",
            "is_supporter": 0,
            "bio": "",
            "relationship": null,
            "user_avatar": "https://assets.untappd.com/profile/40a77f536af1bcdd2100a76623bf9be3_100x100.jpg",
            "is_private": 0,
            "public_toasts": 1
          },
          "beer": {
            "bid": 3839,
            "beer_name": "Belgian White",
            "beer_label": "https://assets.untappd.com/site/beer_logos/beer-3839_a1ad9_sm.jpeg",
            "beer_abv": 5.4,
            "beer_ibu": 9,
            "beer_slug": "blue-moon-brewing-company-belgian-white",
            "beer_description": "Blue Moon Belgian White, Belgian-style wheat ale, is a refreshing, medium-bodied, unfiltered Belgian-style wheat ale spiced with fresh coriander and orange peel for a uniquely complex taste and an uncommonly smooth finish.",
            "beer_style": "Wheat Beer - Witbier / Blanche",
            "has_had": false,
            "beer_active": 1
          },
          "brewery": {
            "brewery_id": 127804,
            "brewery_name": "Blue Moon Brewing Company",
            "brewery_slug": "blue-moon-brewing-company",
            "brewery_page_url": "/BlueMoonBrewingCompany",
            "brewery_label": "https://assets.untappd.com/site/brewery_logos/brewery-127804_1a670.jpeg",
            "country_name": "United States",
            "contact": {
              "twitter": "BlueMoonBrewCo",
              "facebook": "https://www.facebook.com/bluemoon",
              "url": "https://www.bluemoonbrewingcompany.com"
            },
            "location": {
              "brewery_city": "Denver",
              "brewery_state": "CO",
              "lat": 39.7736,
              "lng": -104.977
            },
            "brewery_active": 1
          },
          "venue": {
            "venue_id": 9917985,
            "venue_name": "Untappd at Home",
            "venue_slug": "at-home",
            "primary_category_key": null,
            "primary_category": null,
            "parent_category_id": "4e67e38e036454776db1fb3a",
            "categories": {
              "count": 1,
              "items": [
                {
                  "category_key": "home_private",
                  "category_name": "Home (private)",
                  "category_id": "4bf58dd8d48988d103941735",
                  "is_primary": true
                }
              ]
            },
            "location": {
              "venue_address": "",
              "venue_city": "",
              "venue_state": "NC",
              "venue_country": "United States",
              "lat": 34.2346611,
              "lng": -77.9482117
            },
            "contact": {
              "twitter": "",
              "venue_url": ""
            },
            "foursquare": {
              "foursquare_id": "5e7b4d99c91df60008e8b168",
              "foursquare_url": "https://4sq.com/3bDWYuq"
            },
            "venue_icon": {
              "sm": "https://assets.untappd.com/venuelogos/venue_9917985_b3a5d245_bg_64.png",
              "md": "https://assets.untappd.com/venuelogos/venue_9917985_b3a5d245_bg_88.png",
              "lg": "https://assets.untappd.com/venuelogos/venue_9917985_b3a5d245_bg_176.png?v=1"
            },
            "is_verified": true
          },
          "comments": {
            "total_count": 0,
            "count": 0,
            "items": []
          },
          "toasts": {
            "total_count": 0,
            "count": 0,
            "auth_toast": false,
            "items": []
          },
          "media": {
            "count": 0,
            "items": []
          },
          "source": {
            "app_name": "Untappd for iPhone - (V4)",
            "app_website": "http://untpd.it/iphoneapp"
          },
          "badges": {
            "count": 0,
            "items": []
          }
        },
        {
          "checkin_id": 1383156491,
          "created_at": "Thu, 23 May 2024 01:43:28 +0000",
          "checkin_comment": "",
          "rating_score": 2.5,
          "user": {
            "uid": 11553422,
            "user_name": "luke_pilsner",
            "first_name": "Luke",
            "last_name": "Piller",
            "location": "Charleston ",
            "url": "",
            "is_supporter": 0,
            "bio": "",
            "relationship": null,
            "user_avatar": "https://gravatar.com/avatar/d28534a38954f3a727bf668b240bda77?size=100&d=https%3A%2F%2Fassets.untappd.com%2Fsite%2Fassets%2Fimages%2Fdefault_avatar_v3_gravatar.jpg%3Fv%3D2",
            "is_private": 0,
            "public_toasts": 1
          },
          "beer": {
            "bid": 3839,
            "beer_name": "Belgian White",
            "beer_label": "https://assets.untappd.com/site/beer_logos/beer-3839_a1ad9_sm.jpeg",
            "beer_abv": 5.4,
            "beer_ibu": 9,
            "beer_slug": "blue-moon-brewing-company-belgian-white",
            "beer_description": "Blue Moon Belgian White, Belgian-style wheat ale, is a refreshing, medium-bodied, unfiltered Belgian-style wheat ale spiced with fresh coriander and orange peel for a uniquely complex taste and an uncommonly smooth finish.",
            "beer_style": "Wheat Beer - Witbier / Blanche",
            "has_had": false,
            "beer_active": 1
          },
          "brewery": {
            "brewery_id": 127804,
            "brewery_name": "Blue Moon Brewing Company",
            "brewery_slug": "blue-moon-brewing-company",
            "brewery_page_url": "/BlueMoonBrewingCompany",
            "brewery_label": "https://assets.untappd.com/site/brewery_logos/brewery-127804_1a670.jpeg",
            "country_name": "United States",
            "contact": {
              "twitter": "BlueMoonBrewCo",
              "facebook": "https://www.facebook.com/bluemoon",
              "url": "https://www.bluemoonbrewingcompany.com"
            },
            "location": {
              "brewery_city": "Denver",
              "brewery_state": "CO",
              "lat": 39.7736,
              "lng": -104.977
            },
            "brewery_active": 1
          },
          "venue": [],
          "comments": {
            "total_count": 0,
            "count": 0,
            "items": []
          },
          "toasts": {
            "total_count": 0,
            "count": 0,
            "auth_toast": false,
            "items": []
          },
          "media": {
            "count": 0,
            "items": []
          },
          "source": {
            "app_name": "Untappd for iPhone - (V4)",
            "app_website": "http://untpd.it/iphoneapp"
          },
          "badges": {
            "retro_status": false,
            "count": 1,
            "items": [
              {
                "badge_id": 5631,
                "user_badge_id": 1204487019,
                "badge_name": "Wheel of Styles (Level 2)",
                "badge_description": "Round and round the wheel goes! Which style you’ll be drinking, nobody knows! Your desire to explore different styles is inspiring. Keep it up! That's a check-in to at least 10 different styles. Try 5 more for Level 3!",
                "created_at": "Thu, 23 May 2024 01:43:28 +0000",
                "badge_image": {
                  "sm": "https://assets.untappd.com/badges/bdg_WheelofStyles_sm.jpg",
                  "md": "https://assets.untappd.com/badges/bdg_WheelofStyles_md.jpg",
                  "lg": "https://assets.untappd.com/badges/bdg_WheelofStyles_lg.jpg"
                }
              }
            ]
          }
        },
        {
          "checkin_id": 1383154035,
          "created_at": "Thu, 23 May 2024 01:28:24 +0000",
          "checkin_comment": "",
          "rating_score": 4,
          "user": {
            "uid": 474919,
            "user_name": "andersonbeii",
            "first_name": "Bill",
            "last_name": "Anderson",
            "location": "Cincinnati",
            "url": "",
            "is_supporter": 0,
            "bio": "",
            "relationship": null,
            "user_avatar": "https://assets.untappd.com/profile/a70a19909d3808cffa7b26b609e5d086_100x100.jpg",
            "is_private": 0,
            "public_toasts": 1
          },
          "beer": {
            "bid": 3839,
            "beer_name": "Belgian White",
            "beer_label": "https://assets.untappd.com/site/beer_logos/beer-3839_a1ad9_sm.jpeg",
            "beer_abv": 5.4,
            "beer_ibu": 9,
            "beer_slug": "blue-moon-brewing-company-belgian-white",
            "beer_description": "Blue Moon Belgian White, Belgian-style wheat ale, is a refreshing, medium-bodied, unfiltered Belgian-style wheat ale spiced with fresh coriander and orange peel for a uniquely complex taste and an uncommonly smooth finish.",
            "beer_style": "Wheat Beer - Witbier / Blanche",
            "has_had": false,
            "beer_active": 1
          },
          "brewery": {
            "brewery_id": 127804,
            "brewery_name": "Blue Moon Brewing Company",
            "brewery_slug": "blue-moon-brewing-company",
            "brewery_page_url": "/BlueMoonBrewingCompany",
            "brewery_label": "https://assets.untappd.com/site/brewery_logos/brewery-127804_1a670.jpeg",
            "country_name": "United States",
            "contact": {
              "twitter": "BlueMoonBrewCo",
              "facebook": "https://www.facebook.com/bluemoon",
              "url": "https://www.bluemoonbrewingcompany.com"
            },
            "location": {
              "brewery_city": "Denver",
              "brewery_state": "CO",
              "lat": 39.7736,
              "lng": -104.977
            },
            "brewery_active": 1
          },
          "venue": {
            "venue_id": 8241367,
            "venue_name": "Wings Etc.",
            "venue_slug": "wings-etc",
            "primary_category_key": "Dining and Drinking",
            "primary_category": "Dining and Drinking",
            "parent_category_id": "63be6904847c3692a84b9bb5",
            "categories": {
              "count": 2,
              "items": [
                {
                  "category_key": "bar",
                  "category_name": "Bar",
                  "category_id": "4bf58dd8d48988d116941735",
                  "is_primary": true
                },
                {
                  "category_key": "food",
                  "category_name": "Restaurant",
                  "category_id": "4d4b7105d754a06374d81259",
                  "is_primary": false
                }
              ]
            },
            "location": {
              "venue_address": "1439 N Cass St",
              "venue_city": "Wabash",
              "venue_state": "IN",
              "venue_country": "United States",
              "lat": 40.8172798,
              "lng": -85.8368073
            },
            "contact": {
              "twitter": "",
              "venue_url": "https://www.wingsetc.com/wabash"
            },
            "foursquare": {
              "foursquare_id": "5adf88c96bd36b0908b60fbb",
              "foursquare_url": "https://4sq.com/2Hn8rDX"
            },
            "venue_icon": {
              "sm": "https://ss3.4sqi.net/img/categories_v2/nightlife/pub_bg_64.png",
              "md": "https://ss3.4sqi.net/img/categories_v2/nightlife/pub_bg_88.png",
              "lg": "https://ss3.4sqi.net/img/categories_v2/nightlife/pub_bg_512.png"
            },
            "is_verified": false
          },
          "comments": {
            "total_count": 0,
            "count": 0,
            "items": []
          },
          "toasts": {
            "total_count": 0,
            "count": 0,
            "auth_toast": false,
            "items": []
          },
          "media": {
            "count": 0,
            "items": []
          },
          "source": {
            "app_name": "Untappd for Android - (V4)",
            "app_website": "http://untpd.it/androidapp"
          },
          "badges": {
            "count": 0,
            "items": []
          }
        }
      ]
    }
  }
}
```

Make sure to parse the `UntappdCheckIn.dt` out of `created_at` using
`parseCreatedAt(String createdAt)`. Ignore information about the user who
checked in the beer. Use the optional `limit` parameter to only retrieve 10
results.
