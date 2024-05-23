/**
 * Implementation of {@link BurgerApi}.
 */
public inherited sharing class BurgerApiImpl2 implements BurgerApi {
  private final Map<String, Object> authParams;

  public BurgerApiImpl2(Map<String, Object> authParams) {
    this.authParams = authParams;
  }

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

  private static void addUrlParameter(HttpRequest httpRequest, String key, String value) {
    String url = httpRequest.getEndpoint();

    if (url.contains('?')) {
      httpRequest.setEndpoint(String.format('{0}&{1}={2}', new List<String>{ url, key, value }));
    } else {
      httpRequest.setEndpoint(String.format('{0}?{1}={2}', new List<String>{ url, key, value }));
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