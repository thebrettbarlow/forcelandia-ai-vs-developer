/**
 * Implementation of {@link BurgerApi}.
 */
public inherited sharing class BurgerApiImpl2 implements BurgerApi {
  private final HttpRequestFactory httpRequestFactory;
  private final Type exceptionType;

  public BurgerApiImpl2(HttpRequestFactory httpRequestFactory, Type exceptionType) {
    this.httpRequestFactory = httpRequestFactory;
    this.exceptionType = exceptionType;
  }

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

  private HttpResponse send(HttpRequest request) {
    HttpResponse response = new Http().send(request);
    if (response.getStatusCode() >= 300) {
      Exception e = (Exception) exceptionType.newInstance();
      e.setMessage(response.getBody());

      throw e;
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
}