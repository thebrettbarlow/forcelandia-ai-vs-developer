# Implement an API Interface - Part 1

The prompt starts below this line.

---

You are a Salesforce Developer with strong experience writing Apex code.

Your task is to implement an Interface that represents an API. The result must
meet the following requirements:

- Accept the following constructor parameters:
  - `HttpRequestFactory`
  - `Type` of an `Exception` to throw when an error occurs
- Include a `private HttpResponse send(HttpRequest request)` method
  - When the response contains a status code >= 300, throw the exception
- Include a
  `private static String addUrlParameter(String url, String key, String value)`
  method
  - This method should return a new URL with the key-value pair added as a query
    parameter
- Implement each method to meet the following requirements:
  - Create a new `HttpRequest` using `HttpRequestFactory`
  - Add a comment directly below this line with "TODO: modify request
    parameters"
  - Use `send(HttpRequest)` to send the request
  - Return `null`
  - Add a comment directly before the return statement with "TODO: parse
    response into expected return type"
  - Do not implement logic mentioned in the TODO comments. We will do this in
    the next task

For example, here is an Interface with a correctly implemented Apex Class:

```apex
/**
 * Wrapper around the Burger API.
 */
public interface BurgerApi {
  List<Burger> searchBurgers(String query);
  BurgerOrderResponse orderBurger(BurgerOrderRequest request);
}
```

```apex
/**
 * Implementation of {@link BurgerApi}.
 */
public inherited sharing class BurgerApiImpl implements BurgerApi {
  private final HttpRequestFactory httpRequestFactory;
  private final Type exceptionType;

  public BurgerApi1Impl(
    HttpRequestFactory httpRequestFactory,
    Type exceptionType
  ) {
    this.httpRequestFactory = httpRequestFactory;
    this.exceptionType = exceptionType;
  }

  public List<Burger> searchBurgers(String query) {
    String endpoint = '';
    HttpRequest httpRequest = httpRequestFactory.create(endpoint);
    // TODO: modify request parameters

    HttpResponse httpResponse = send(httpRequest);

    // TODO: parse response into expected return type
    return null;
  }

  public BurgerOrderResponse orderBurger(BurgerOrderRequest request) {
    String endpoint = '';
    HttpRequest httpRequest = httpRequestFactory.create(endpoint);
    // TODO: modify request parameters

    HttpResponse httpResponse = send(httpRequest);

    // TODO: parse response into expected return type
    return null;
  }

  private HttpResponse send(HttpRequest request) {
    HttpResponse response = new Http().send(request);
    if (response.getStatusCode() >= 300) {
      Exception e = (Exception) exceptionType.newInstance();
      e.setMessage(response.getBody());

      throw e;
    }

    return response;
  }

  private static String addUrlParameter(String url, String key, String value) {
    if (url.contains('?')) {
      return String.format('{0}&{1}={2}', new List<String>{ url, key, value });
    } else {
      return String.format('{0}?{1}={2}', new List<String>{ url, key, value });
    }
  }
}
```

Write an Apex Class that implements this Interface:

```apex
// TODO: put interface here
```
