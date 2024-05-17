# Team AI

Contains files used by Team AI to solve the coding challenge.

---

## TODOs

Notes to self about what else needs to be done:

- Write a prompt to generate the [Data Structures](#data-structures)
  - Use the builder pattern. Also include `toJson()` and `toSObject()`
- Write prompts to implement each method of `UntappdRepository`
- Write a prompt to generate a test for `UntappdRepository`
- Write prompts to implement each method of `UntappdApi`
- Write a prompt to generate a test for `UntappdApi`
- Write prompts to implement each method of `LimitsChecker`
- Write a prompt to generate a test for `LimitsChecker`
- Write a prompt to generate a `Mock` from an interface
  - Also add an example usage to this doc below
- Write a prompt to generate a test for `UpsertUntappdCheckInsQueueable`
- Write a prompt to generate a test for `UntappdPipeline`

## Technical Design

### Objective

The end goal is to run this and have it populate all `Beer__c` and `Check_In__c`
data for the Deschutes Brewery `Account`:

```apex
UntappdPipeline.run('Deschutes Brewery');
```

### High-Level Plan

We can get data about the brewery and the beers they produce in a couple of API
calls. I don't think Deschutes produces more than 10k beers, so we should be
safe to do these API calls and upsert the data right after. From there, we'll
use a `Queueable` to get the check-ins for each beer. We'll need to be careful
about exceeding limits, so we'll need to check for that.

```apex
public class UntappdPipeline {
  @TestVisible
  private static UntappdApi untappdApi = new UntappdApiImpl();
  @TestVisible
  private static UntappdRepository untappdRepository = new UntappdRepositoryImpl();
  @TestVisible
  private static LimitsChecker limitsChecker = new LimitsCheckerImpl();

  public static void run(String breweryName) {
    UntappdBrewery brewery = untappdRepository.getBreweryByName(breweryName);
    untappdRepository.upsertBrewery(brewery);

    List<UntappdBeer> beers = untappdRepository.getBeersForBrewery(
      brewery.getId()
    );
    untappdRepository.upsertBeers(beers);

    System.enqueueJob(
      new UpsertUntappdCheckInsQueueable(
        untappdApi,
        untappdRepository,
        limitsChecker,
        beers
      )
    );
  }

  private static UntappdBrewery getBreweryByName(String breweryName) {
    Map<Integer, String> breweries = untappdApi.searchBreweries(breweryName);
    for (Integer id : breweries.keySet()) {
      if (breweries.get(id) == breweryName) {
        return untappdApi.getBreweryInfo(id);
      }
    }

    throw new UntappdException(
      String.format(
        'Brewery not found in Untappd: {0}.',
        new List<Object>{ breweryName }
      )
    );
  }
}
```

```apex
public class UpsertUntappdCheckInsQueueable implements Queueable, Database.AllowsCallouts {
  private final UntappdApi untappdApi;
  private final UntappdRepository untappdRepository;
  private final LimitsChecker limitsChecker;
  private final List<UntappdBeer> beers;

  public UpsertUntappdCheckInsQueueable(
    UntappdApi untappdApi,
    UntappdRepository untappdRepository,
    LimitsChecker limitsChecker,
    List<UntappdBeer> beers
  ) {
    this.untappdApi = untappdApi;
    this.untappdRepository = untappdRepository;
    this.limitsChecker = limitsChecker;
    this.beers = beers;
  }

  public void execute(QueueableContext context) {
    while (
      limitsChecker.canCallout() && limitsChecker.getProcessingLimitUsage() < 80
    ) {
      List<UntappdCheckIn> checkIns = untappdRepository.getCheckInsForBeer(
        beers[0].getId()
      );

      if (limitsChecker.canDml(checkIns.size())) {
        untappdRepository.upsertCheckins(checkIns);
        beers.remove(0);
      } else {
        break;
      }
    }

    if (beers.size() > 0) {
      System.enqueueJob(
        new UpsertUntappdCheckInsQueueable(
          untappdApi,
          untappdRepository,
          limitsChecker,
          beers
        )
      );
    }
  }
}
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
  UntappdBeerActivityFeed getBeerActivityFeed(
    Long beerId,
    UntappdPagination pagination
  );
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

```apex
public interface LimitsChecker {
  /**
   * Returns {@code true} when the transaction has enough limits left to perform DML on the given
   * number of records.
   */
  Boolean canDml(Integer recordsToDml);

  /**
   * Returns {@code true} when the transaction has enough limits left to perform a callout.
   */
  Boolean canCallout();

  /**
   * Evaluates processing-related limits (e.g. heap size, CPU time, etc.) and returns a number
   * between 0 and 100 that represents the percentage of the highest limit used.
   */
  Integer getProcessingLimitUsage();
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
public class UntappdBeerActivityFeed {
  private final UntappdPagination pagination;
  private final List<UntappdCheckIn> checkIns;
}
```

```apex
public class UntappdPagination {
  private final String sinceUrl;
  private final String nextUrl;
  private final Long maxId;
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

### Mocking Framework

We will use a simple mocking framework to allow us to test each class in
isolation. Here is an example usage of the framework:

```apex
// TODO: add example
```
