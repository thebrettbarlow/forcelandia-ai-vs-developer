# Team AI

Contains files used by Team AI to solve the coding challenge.

---

## TODOs

- [ ] End-to-end testing
  - Finding that the API explorer has more accurate example responses
- [ ] Outline the key takeaways

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
Account account = untappdRepository.upsertBrewery(brewery);

List<Beer__c> beers = new List<Beer__c>();
for (UntappdBeer untappdBeer : brewery.getBeers()) {
    Beer__c beer = untappdBeer.toSObject();
    beer.Brewery__c = account.Id;

    beers.add(beer);
}
untappdRepository.upsertBeers(beers);

List<UntappdCheckIn> checkIns = new List<UntappdCheckIn>();
for (UntappdBeer untappdBeer : brewery.getBeers()) {
    // Not implementing pagination because we can only do 100 calls per hour
    checkIns.addAll(untappdApi.getBeerCheckIns(untappdBeer.getId()));
}
untappdRepository.upsertCheckins(checkIns);
```

### Data Structures

These classes will be used to represent the data we're working with:

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
public class UntappdBeer {
  private final Long id;
  private final Long breweryId;
  private final String name;
  private final String style;
  private final Decimal abv;
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
