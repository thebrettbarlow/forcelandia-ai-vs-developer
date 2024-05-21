# Implement an API Interface - Part 2

The prompt starts below this line.

_This must be sent directly after sending Part 1_

---

Your task is to finish implementing a specific method. This is a two-part task.
The first part is to modify request parameters. The second part is to parse the
response into expected return type.

When you have completed the task, only respond with the specific method that you
have implemented. Remove all TODO comments.

The result of modifying request parameters must meet the following requirements:

- Review the API documentation to see if parameters need to be passed in the URL
  or the request body
- Assume that the `HttpRequestFactory` has returned an `HttpRequest` that
  already has all authentication-related parameters set

The result of parsing the response into expected return type must meet the
following requirements:

- Use `JSON.deserializeUntyped` to parse the response body into a `result`
- Review the API documentation to see if the `result` should be a
  `Map<String, Object>` or `List<Object>`
- Review the API documentation to see how to extract data from the `result`

For example, here is the correct implementation of the `BurgerApi.searchBurgers`
and `BurgerApi.orderBurger` methods:

```apex
public List<Burger> searchBurgers(String query) {
  String endpoint = '/search/burger';
  HttpRequest httpRequest = httpRequestFactory.create(endpoint);
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
  HttpRequest httpRequest = httpRequestFactory.create(endpoint);
  httpRequest.setMethod('POST');
  httpRequest.setBody(request.toJson());

  HttpResponse httpResponse = send(httpRequest);
  Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(
    httpResponse.getBody()
  );

  return BurgerOrderResponse.newBuilder().setOrderId((String) result.get('order_id')).build();
}
```

Implement the `todo` method.

Here is the API documentation:

> TODO: paste documentation here
