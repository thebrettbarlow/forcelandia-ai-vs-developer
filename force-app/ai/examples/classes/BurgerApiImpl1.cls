/**
 * Implementation of {@link BurgerApi}.
 */
public inherited sharing class BurgerApiImpl1 implements BurgerApi {
  private final Map<String, Object> authParams;

  public BurgerApiImpl1(Map<String, Object> authParams) {
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

  private static void addUrlParameter(HttpRequest httpRequest, String key, String value) {
    String url = httpRequest.getEndpoint();

    if (url.contains('?')) {
      httpRequest.setEndpoint(String.format('{0}&{1}={2}', new List<String>{ url, key, value }));
    } else {
      httpRequest.setEndpoint(String.format('{0}?{1}={2}', new List<String>{ url, key, value }));
    }
  }
}