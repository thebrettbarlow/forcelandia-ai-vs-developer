# Implement an API Interface - Part 1

The prompt starts below this line.

---

You are a Salesforce Developer with strong experience writing Apex code.

Your task is to implement an Interface that represents an API. The result must
meet the following requirements:

- Accept the following constructor parameters:
  - `Map<String, Object>` that contains authentication parameters
- Include a `private HttpRequest createRequest(String endpoint)` method
  - This method should return a new `HttpRequest` that has been built using the
    endpoint and authentication parameters
- Include a `private HttpResponse send(HttpRequest request)` method
  - When the response contains a status code >= 300, throw a CalloutException
- Include a
  `private static void addUrlParameter(String url, String key, String value)`
  method
  - This method should return a new URL with the key-value pair added as a query
    parameter
- Include a `private static Datetime parseCreatedAt(String createdAt)` method
  - This method should parse the `createdAt` string into a `Datetime` object
- Implement each method to meet the following requirements:
  - Create a new `HttpRequest` using `createRequest(String endpoint)`
  - Leave the `endpoint` variable as an empty `String`
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
  private final Map<String, Object> authParams;

  public BurgerApiImpl(Map<String, Object> authParams) {
    this.authParams = authParams;
  }

  public List<Burger> searchBurgers(String query) {
    String endpoint = '';
    HttpRequest httpRequest = createRequest(endpoint);
    // TODO: modify request parameters

    HttpResponse httpResponse = send(httpRequest);

    // TODO: parse response into expected return type
    return null;
  }

  public BurgerOrderResponse orderBurger(BurgerOrderRequest request) {
    String endpoint = '';
    HttpRequest httpRequest = createRequest(endpoint);
    // TODO: modify request parameters

    HttpResponse httpResponse = send(httpRequest);

    // TODO: parse response into expected return type
    return null;
  }

  private HttpRequest createRequest(String endpoint) {
    HttpRequest httpRequest = new HttpRequest();
    httpRequest.setEndpoint(
      String.format(
        '{0}{1}?client_id={2}&client_secret={3}',
        new List<Object>{
          authParams.get('url'),
          endpoint,
          authParams.get('client_id'),
          authParams.get('client_secret')
        }
      )
    );

    return httpRequest;
  }

  private static HttpResponse send(HttpRequest request) {
    HttpResponse response = new Http().send(request);
    if (response.getStatusCode() >= 300) {
      throw new CalloutException(response.getBody());
    }

    return response;
  }

  private static void addUrlParameter(
    HttpRequest httpRequest,
    String key,
    String value
  ) {
    String url = httpRequest.getEndpoint();

    if (url.contains('?')) {
      httpRequest.setEndpoint(
        String.format('{0}&{1}={2}', new List<String>{ url, key, value })
      );
    } else {
      httpRequest.setEndpoint(
        String.format('{0}?{1}={2}', new List<String>{ url, key, value })
      );
    }
  }

  private static Datetime parseCreatedAt(String createdAt) {
    Map<String, Integer> monthMap = new Map<String, Integer>{
      'Jan' => 1,
      'Feb' => 2,
      'Mar' => 3,
      'Apr' => 4,
      'May' => 5,
      'Jun' => 6,
      'Jul' => 7,
      'Aug' => 8,
      'Sep' => 9,
      'Oct' => 10,
      'Nov' => 11,
      'Dec' => 12
    };
    List<String> dateParts = createdAt.split(' ');
    List<String> timeParts = dateParts[4].split(':');

    Date d = Date.newInstance(
      Integer.valueOf(dateParts[3]),
      monthMap.get(dateParts[2]),
      Integer.valueOf(dateParts[1])
    );
    Time t = Time.newInstance(
      Integer.valueOf(timeParts[0]),
      Integer.valueOf(timeParts[1]),
      Integer.valueOf(timeParts[2]),
      0
    );

    return Datetime.newInstanceGmt(d, t);
  }
}
```

Write an Apex Class that implements this Interface:

```apex
// TODO: put interface here
```
