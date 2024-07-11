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