/**
 * Implementation of {@link BurgerApi}.
 */
public inherited sharing class BurgerApiImpl1 implements BurgerApi {
  private final String namedCredential;
  private final Type exceptionType;

  public BurgerApiImpl1(String namedCredential, Type exceptionType) {
    this.namedCredential = namedCredential;
    this.exceptionType = exceptionType;
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
    // TODO: need to do something like this:
    // Untappd_API_Configuration__mdt config = Untappd_API_Configuration__mdt.getInstance('v4');
    //
    //HttpRequest httpRequest = new HttpRequest();
    //httpRequest.setEndpoint(String.format(
    //        '{0}?client_id={1}&client_secret={2}',
    //        new List<Object>{
    //                config.URL__c,
    //                config.Client_Id__c,
    //                config.Client_Secret__c
    //        }
    //));

    HttpRequest httpRequest = new HttpRequest();
    httpRequest.setEndpoint(
      String.format(
        'callout:{0}/{1}?client_id={2}&client_secret={3}',
        new List<Object>{ namedCredential, endpoint, 'client_id', 'client_secret' }
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

  private static String addUrlParameter(String url, String key, String value) {
    if (url.contains('?')) {
      return String.format('{0}&{1}={2}', new List<String>{ url, key, value });
    } else {
      return String.format('{0}?{1}={2}', new List<String>{ url, key, value });
    }
  }
}