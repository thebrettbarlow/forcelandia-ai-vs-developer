/**
 * Implementation of {@link UntappdApi}.
 */
public class UntappdApiImpl implements UntappdApi {
  private final Map<String, Object> authParams;

  public UntappdApiImpl(Map<String, Object> authParams) {
    this.authParams = authParams;
  }

  public Map<Long, String> searchBreweries(String query) {
    String endpoint = '/v4/search/brewery';
    HttpRequest httpRequest = createRequest(endpoint);
    httpRequest.setMethod('GET');
    addUrlParameter(httpRequest, 'q', query);

    HttpResponse httpResponse = send(httpRequest);
    Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(
      httpResponse.getBody()
    );

    Map<Long, String> breweries = new Map<Long, String>();
    Map<String, Object> response = (Map<String, Object>) result.get('response');
    List<Object> items = (List<Object>) ((Map<String, Object>) response.get('brewery'))
      .get('items');
    for (Object itemObj : items) {
      Map<String, Object> item = (Map<String, Object>) itemObj;
      Map<String, Object> brewery = (Map<String, Object>) item.get('brewery');
      breweries.put((Long) brewery.get('brewery_id'), (String) brewery.get('brewery_name'));
    }

    return breweries;
  }

  public UntappdBrewery getBreweryInfo(Long breweryId) {
    String endpoint = '/v4/brewery/info/' + breweryId;
    HttpRequest httpRequest = createRequest(endpoint);
    httpRequest.setMethod('GET');

    HttpResponse httpResponse = send(httpRequest);
    Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(
      httpResponse.getBody()
    );

    Map<String, Object> response = (Map<String, Object>) result.get('response');
    Map<String, Object> brewery = (Map<String, Object>) response.get('brewery');

    String name = (String) brewery.get('brewery_name');
    String description = (String) brewery.get('brewery_description');
    String website = null;
    if (brewery.containsKey('contact')) {
      Map<String, Object> contact = (Map<String, Object>) brewery.get('contact');
      website = (String) contact.get('url');
    }
    String street = null;
    String city = null;
    String state = null;
    if (brewery.containsKey('location')) {
      Map<String, Object> location = (Map<String, Object>) brewery.get('location');
      street = (String) location.get('brewery_address');
      city = (String) location.get('brewery_city');
      state = (String) location.get('brewery_state');
    }

    List<UntappdBeer> beers = new List<UntappdBeer>();
    if (brewery.containsKey('beer_list')) {
      Map<String, Object> beerList = (Map<String, Object>) brewery.get('beer_list');
      List<Object> items = (List<Object>) beerList.get('items');
      for (Object itemObj : items) {
        Map<String, Object> item = (Map<String, Object>) itemObj;
        Map<String, Object> beer = (Map<String, Object>) item.get('beer');
        beers.add(
          UntappdBeer.newBuilder()
            .setId((Long) beer.get('bid'))
            .setBreweryId(breweryId)
            .setName((String) beer.get('beer_name'))
            .setStyle((String) beer.get('beer_style'))
            .setAbv((Double) beer.get('beer_abv'))
            .build()
        );
      }
    }

    return UntappdBrewery.newBuilder()
      .setId((Long) brewery.get('brewery_id'))
      .setName(name)
      .setDescription(description)
      .setWebsite(website)
      .setStreet(street)
      .setCity(city)
      .setState(state)
      .setBeers(beers)
      .build();
  }

  public List<UntappdCheckIn> getBeerCheckIns(Long beerId) {
    String endpoint = '/v4/beer/checkins/' + beerId;
    HttpRequest httpRequest = createRequest(endpoint);
    httpRequest.setMethod('GET');
    addUrlParameter(httpRequest, 'limit', '10'); // Limit to 10 results

    HttpResponse httpResponse = send(httpRequest);
    Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(
      httpResponse.getBody()
    );

    Map<String, Object> response = (Map<String, Object>) result.get('response');
    Map<String, Object> pagination = (Map<String, Object>) response.get('pagination');

    List<UntappdCheckIn> checkIns = new List<UntappdCheckIn>();
    if (response.containsKey('checkins')) {
      Map<String, Object> checkinsJson = (Map<String, Object>) response.get('checkins');
      List<Object> items = (List<Object>) checkinsJson.get('items');
      for (Object itemObj : items) {
        Map<String, Object> item = (Map<String, Object>) itemObj;

        UntappdCheckIn.Builder checkInBuilder = UntappdCheckIn.newBuilder();
        checkInBuilder.setId((Long) item.get('checkin_id'));
        checkInBuilder.setBeerId(beerId);
        checkInBuilder.setRating((Double) item.get('rating_score'));
        checkInBuilder.setComment((String) item.get('checkin_comment'));
        checkInBuilder.setDt(parseCreatedAt((String) item.get('created_at')));

        checkIns.add(checkInBuilder.build());
      }
    }

    return checkIns;
  }

  private static DateTime parseCreatedAt(String createdAt) {
    return Datetime.now();
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