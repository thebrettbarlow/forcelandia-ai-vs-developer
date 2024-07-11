/**
 * Implementation of {@link UntappdRepository}.
 */
public class UntappdRepositoryImpl implements UntappdRepository {
  public Account upsertBrewery(UntappdBrewery brewery) {
    Account accountToUpsert = brewery.toSObject();
    // Explicitly include Untappd_Id__c in the upsert statement
    upsert accountToUpsert Untappd_Id__c;
    return accountToUpsert;
  }

  public List<Beer__c> upsertBeers(List<UntappdBeer> beers) {
    List<Beer__c> sobjBeers = new List<Beer__c>();
    for (UntappdBeer beer : beers) {
      sobjBeers.add(beer.toSObject());
    }
    // Explicitly include Untappd_Id__c in the upsert statement
    upsert sobjBeers Untappd_Id__c;
    return sobjBeers;
  }

  public List<Check_In__c> upsertCheckins(List<UntappdCheckIn> checkIns) {
    List<Check_In__c> sobjCheckIns = new List<Check_In__c>();
    for (UntappdCheckIn checkIn : checkIns) {
      sobjCheckIns.add(checkIn.toSObject());
    }
    // Explicitly include Untappd_Id__c in the upsert statement
    upsert sobjCheckIns Untappd_Id__c;
    return sobjCheckIns;
  }
}