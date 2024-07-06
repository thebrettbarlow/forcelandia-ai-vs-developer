# Team AI

Contains files used by Team AI to solve the coding challenge.

---

## Technical Design

### Objective

The end goal is to be able to use Anonymous Apex to run the following code and
have it populate all `Beer__c` and `Check_In__c` data for the Deschutes Brewery
`Account`:

```apex
final String breweryName = 'Deschutes Brewery';

Untappd_API_Configuration__mdt apiConfig = Untappd_API_Configuration__mdt.getInstance('v4');
Map<String, Object> authParams = new Map<String, Object>{
        'url' => apiConfig.URL__c,
        'client_id' => apiConfig.Client_Id__c,
        'client_secret' => apiConfig.Client_Secret__c
};
UntappdApi untappdApi = new UntappdApiImpl(authParams);
UntappdRepository untappdRepository = new UntappdRepositoryImpl();

Map<Long, String> breweries = untappdApi.searchBreweries(breweryName);
System.debug('Breweries: ' + breweries);

UntappdBrewery brewery;
for (Long id : breweries.keySet()) {
    if (breweries.get(id) == breweryName) {
        brewery = untappdApi.getBreweryInfo(id);
    }
}

if (brewery == null) {
    throw new IllegalArgumentException(
            String.format('Brewery ({0}) not found in Untappd.', new List<Object>{ breweryName })
    );
}

System.debug(String.format('We found {0}!', new List<Object>{breweryName}));
System.debug(String.format(String.join(new List<String>{
        '{0} ({1})',
        '{2}',
        '{3} {4}, {5}',
        '{6}'
}, '\n'), new List<Object>{
        brewery.getName(),
        brewery.getId(),
        brewery.getWebsite(),
        brewery.getStreet(), brewery.getCity(), brewery.getState(),
        brewery.getDescription()
}));
System.debug(String.format('Beers: {0}', new List<Object>{brewery.getBeers().size()}));
for (UntappdBeer beer : brewery.getBeers()) {
    System.debug(String.format('{0} ({1} {2}%)', new List<Object>{beer.getName(), beer.getStyle(), beer.getAbv()}));
}

List<UntappdCheckIn> checkIns = new List<UntappdCheckIn>();
for (UntappdBeer untappdBeer : brewery.getBeers()) {
    List<UntappdCheckIn> beerCheckIns = untappdApi.getBeerCheckIns(untappdBeer.getId());
    System.debug(String.format('Check-Ins for {0}', new List<Object>{untappdBeer.getName()}));
    for (UntappdCheckIn checkIn : beerCheckIns) {
        String summary = checkIn.getRating().toString();

        if (String.isNotBlank(checkIn.getComment())) {
            summary += ' - ' + checkIn.getComment();
        }

        System.debug(summary);
    }

    checkIns.addAll(beerCheckIns);
}

untappdRepository.upsertBrewery(brewery);
untappdRepository.upsertBeers(brewery.getBeers());
untappdRepository.upsertCheckins(checkIns);
```

### Data Structures

These classes will be used to represent the data we're working with:

```apex
public class UntappdBeer {
  private final Long id;
  private final Long breweryId;
  private final String name;
  private final String style;
  private final Decimal abv;
}
```

```apex
public class UntappdBrewery {
  private final Long id;
  private final String name;
  private final String description;
  private final String website;
  private final String street;
  private final String city;
  private final String state;
  private final List<UntappdBeer> beers;
}
```

```apex
public class UntappdCheckIn {
  private final Long id;
  private final Long beerId;
  private final Decimal rating;
  private final String comment;
  private final Datetime dt;
  private final Integer toasts;
  private final Integer comments;
}
```

### Interfaces

Let's break down the task into more specific modules:

```apex
/**
 * Responsible for reading and writing data in the context of Untappd.
 */
public interface UntappdRepository {
  /**
   * Upserts the given {@link UntappdBrewery} as an {@link Account}.
   */
  Account upsertBrewery(UntappdBrewery brewery);

  /**
   * Upserts the given {@link UntappdBeer}s as {@link Beer__c} records.
   */
  List<Beer__c> upsertBeers(List<UntappdBeer> beers);

  /**
   * Upserts the given {@link UntappdCheckIn}s as {@link Check_In__c} records.
   */
  List<Check_In__c> upsertCheckins(List<UntappdCheckIn> checkIns);
}
```

```apex
/**
 * Wrapper around the Untappd API.
 *
 * @see https://untappd.com/api/docs
 */
public interface UntappdApi {
  /**
   * Returns a {@link Map} of brewery ID to Name (e.g. 123 => 'Name') that match the given query.
   *
   * @see https://untappd.com/api/docs#brewerysearch
   */
  Map<Integer, String> searchBreweries(String query);

  /**
   * Returns the {@link UntappdBrewery} with the given ID.
   *
   * @see https://untappd.com/api/docs#breweryinfo
   */
  UntappdBrewery getBreweryInfo(Long breweryId);

  /**
   * Returns a {@link UntappdGetCheckInsResult} for the beer with the given ID.
   *
   * Use the result object to page through the check-ins. The Untappd API returns 25 check-ins per
   * page.
   *
   * @see https://untappd.com/api/docs#beeractivityfeed
   */
  List<UntappdCheckIn> getBeerCheckIns(Long beerId);
}
```
