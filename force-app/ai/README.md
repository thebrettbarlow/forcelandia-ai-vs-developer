# Team AI

Contains files used by Team AI to solve the coding challenge.

---

## TODOs

- [ ] Update the API generation to have a method that builds `HttpRequest`
  - We need to do this in a way that lets us use the values from the CMDT. Or
    maybe we pass a Map<String, Object> in as `authenticationParameters`? We
    could accept another parameter of `endpoint`, which will be the base
    endpoint
- [ ] End-to-end testing
- [ ] Outline the key takeaways

## Technical Design

### Objective

The end goal is to be able to use Anonymous Apex to run the following code and
have it populate all `Beer__c` and `Check_In__c` data for the Deschutes Brewery
`Account`:

```apex
final String breweryName = 'Deschutes Brewery';
UntappdApi untappdApi = new UntappdApiImpl();
UntappdRepository untappdRepository = new UntappdRepositoryImpl();

Map<Integer, String> breweries = untappdApi.searchBreweries(breweryName);
UntappdBrewery brewery;
for (Integer id : breweries.keySet()) {
    if (breweries.get(id) == breweryName) {
        brewery = untappdApi.getBreweryInfo(id);
    }
}

if (brewery == null) {
    throw new IllegalArgumentException(
            String.format('Brewery not found in Untappd: {0}', new List<Object>{ breweryName })
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

### Interfaces

Let's break down the task into more specific modules:

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
  private final Datetime date;
  private final Integer toasts;
  private final Integer comments;
}
```
