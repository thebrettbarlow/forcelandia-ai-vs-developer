Your task is to finish implementing a specific method. This is a two-part task.
The first part is to modify request parameters. The second part is to parse the
response into expected return type.

When you have completed the task, only respond with the specific method that you
have implemented. Remove all TODO comments. Do not omit any part for brevity.

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

Implement the `searchBreweries` method.

Here is the API documentation:

Brewery Search Authentication: Not Required HTTP Method: GET Endpoint:
/v4/search/brewery This will allow you to search exclusively for breweries in
the Untappd system.

Parameters access_token or client_id and client_secret (string, required) -
Either pass the access_token for authorized calls OR the client_id and
client_secret for unauthorized calls q (string, required) - The search term that
you want to search. offset (int, optional) - The numeric offset that you what
results to start limit (int, optional) - The number of results to return, max of
50, default is 25

Example Response

```json
{
  "meta": {
    "code": 200,
    "response_time": {
      "time": 0.028,
      "measure": "seconds"
    },
    "init_time": {
      "time": 0,
      "measure": "seconds"
    }
  },
  "notifications": [],
  "response": {
    "engine": "_algolia",
    "page": 0,
    "search_type": "wildcard",
    "sort": "",
    "term": "Russian River",
    "key": "Russian River",
    "found": 2,
    "brewery": {
      "count": 2,
      "items": [
        {
          "brewery": {
            "brewery_id": 5143,
            "beer_count": 230,
            "brewery_name": "Russian River Brewing Company",
            "brewery_slug": "russian-river-brewing-company",
            "brewery_page_url": "/RussianRiverBrewingCompany",
            "brewery_label": "https://assets.untappd.com/site/brewery_logos/brewery-5143_e6069.jpeg",
            "country_name": "United States",
            "location": {
              "brewery_city": "Windsor",
              "brewery_state": "CA",
              "lat": 38.5471,
              "lng": -122.816
            }
          }
        },
        {
          "brewery": {
            "brewery_id": 350093,
            "beer_count": 2,
            "brewery_name": "Not Russian River (Homebrew)",
            "brewery_slug": "not-russian-river",
            "brewery_page_url": "/w/not-russian-river/350093",
            "brewery_label": "https://assets.untappd.com/site/assets/images/temp/badge-brewery-default.png",
            "country_name": "United States",
            "location": {
              "brewery_city": "",
              "brewery_state": "",
              "lat": 0,
              "lng": 0
            }
          }
        }
      ]
    }
  }
}
```
