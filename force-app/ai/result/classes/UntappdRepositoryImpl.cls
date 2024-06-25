/**
 * Implementation of {@link UntappdRepository}.
 */
public class UntappdRepositoryImpl implements UntappdRepository {
  public Account upsertBrewery(UntappdBrewery brewery) {
    Account accountToUpsert = brewery.toSObject();
    upsert accountToUpsert Untappd_Id__c;
    return accountToUpsert;
  }

  public List<Beer__c> upsertBeers(List<UntappdBeer> beers) {
    List<Beer__c> beersToUpsert = new List<Beer__c>();
    for (UntappdBeer beer : beers) {
      beersToUpsert.add(beer.toSObject());
    }
    upsert beersToUpsert Untappd_Id__c;
    return beersToUpsert;
  }

  public List<Check_In__c> upsertCheckins(List<UntappdCheckIn> checkIns) {
    List<Check_In__c> checkInsToUpsert = new List<Check_In__c>();
    for (UntappdCheckIn checkIn : checkIns) {
      checkInsToUpsert.add(checkIn.toSObject());
    }
    upsert checkInsToUpsert Untappd_Id__c;
    return checkInsToUpsert;
  }
}