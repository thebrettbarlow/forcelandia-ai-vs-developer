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

    Map<Long, String> breweryMap = new Map<Long, String>();
    Map<String, Object> response = (Map<String, Object>) result.get('response');
    List<Object> items = (List<Object>) ((Map<String, Object>) response.get('brewery'))
      .get('items');
    for (Object itemObj : items) {
      Map<String, Object> item = (Map<String, Object>) itemObj;
      Map<String, Object> brewery = (Map<String, Object>) item.get('brewery');
      breweryMap.put((Long) brewery.get('brewery_id'), (String) brewery.get('brewery_name'));
    }

    return breweryMap;
  }

  public UntappdBrewery getBreweryInfo(Long breweryId) {
    String endpoint = '/v4/brewery/info/' + breweryId;
    HttpRequest httpRequest = createRequest(endpoint);
    httpRequest.setMethod('GET');

    HttpResponse httpResponse = send(httpRequest);
    Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(
      httpResponse.getBody()
    );

    Map<String, Object> breweryInfo = (Map<String, Object>) ((Map<String, Object>) result.get(
        'response'
      ))
      .get('brewery');

    // Extract basic brewery information
    Long id = (Long) breweryInfo.get('brewery_id');
    String name = (String) breweryInfo.get('brewery_name');
    String description = (String) breweryInfo.get('brewery_description');

    // Extract optional contact information
    Map<String, Object> contact = (Map<String, Object>) breweryInfo.get('contact');
    String website = contact != null ? (String) contact.get('url') : null;

    // Extract optional location information
    Map<String, Object> location = (Map<String, Object>) breweryInfo.get('location');
    String street = location != null ? (String) location.get('brewery_address') : null;
    String city = location != null ? (String) location.get('brewery_city') : null;
    String state = location != null ? (String) location.get('brewery_state') : null;

    UntappdBrewery.Builder breweryBuilder = UntappdBrewery.newBuilder()
      .setId(id)
      .setName(name)
      .setDescription(description)
      .setWebsite(website)
      .setStreet(street)
      .setCity(city)
      .setState(state);

    // Extract beers (up to 25 according to the docs)
    Map<String, Object> beerList = (Map<String, Object>) breweryInfo.get('beer_list');
    if (beerList != null) {
      List<Object> items = (List<Object>) beerList.get('items');
      for (Object itemObj : items) {
        Map<String, Object> itemMap = (Map<String, Object>) itemObj;
        Map<String, Object> beerMap = (Map<String, Object>) itemMap.get('beer');

        breweryBuilder.addBeer(
          UntappdBeer.newBuilder()
            .setId((Long) beerMap.get('bid'))
            .setBreweryId(id)
            .setName((String) beerMap.get('beer_name'))
            .setStyle((String) beerMap.get('beer_style'))
            .setAbv(Decimal.valueOf(String.valueOf(beerMap.get('beer_abv'))))
            .build()
        );
      }
    }

    return breweryBuilder.build();
  }

  public List<UntappdCheckIn> getBeerCheckIns(Long beerId) {
    String endpoint = '/v4/beer/checkins/' + beerId;
    HttpRequest httpRequest = createRequest(endpoint);
    httpRequest.setMethod('GET');
    addUrlParameter(httpRequest, 'limit', '10');

    HttpResponse httpResponse = send(httpRequest);
    Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(
      httpResponse.getBody()
    );

    Map<String, Object> response = (Map<String, Object>) result.get('response');
    List<Object> items = (List<Object>) ((Map<String, Object>) response.get('checkins'))
      .get('items');

    List<UntappdCheckIn> checkIns = new List<UntappdCheckIn>();
    for (Object itemObj : items) {
      Map<String, Object> itemMap = (Map<String, Object>) itemObj;

      checkIns.add(
        UntappdCheckIn.newBuilder()
          .setId((Long) itemMap.get('checkin_id'))
          .setBeerId(beerId)
          .setRating(Decimal.valueOf(String.valueOf(itemMap.get('rating_score'))))
          .setComment((String) itemMap.get('checkin_comment'))
          .setDt(parseCreatedAt((String) itemMap.get('created_at')))
          .build()
      );
    }

    return checkIns;
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