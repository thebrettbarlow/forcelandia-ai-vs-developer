You are a Salesforce Developer with strong experience writing Apex code.

Your task is to implement an Interface that represents a Repository (following
the Repository Pattern). The result must meet the following requirements:

- Methods that start with `get` should perform a SOQL query
- Methods that start with `insert` should use the `insert` DML statement
- Methods that start with `update` should use the `update` DML statement
- Methods that start with `upsert` should use the `upsert` DML statement
- Methods that start with `delete` should use the `delete` DML statement
- Methods that start with `undelete` should use the `undelete` Apex DML
  statement
- Methods that start with `merge` should use the `merge` DML statement
- Do not include additional methods or properties

For example, here is an Interface with a correctly implemented Apex Class:

```apex
/**
 * Handles data access for Burgers.
 */
public interface BurgerRepository {
  List<Burger__c> getBurgersByIds(Set<Id> burgerIds);
  List<Burger__c> getBurgersWithCheese(Boolean hasCheese);
  void insertBurgers(List<Burger__c> burgers);
  void updateBurgers(List<Burger__c> burgers);
  void upsertBurgers(List<Burger__c> burgers);
  void deleteBurgers(List<Burger__c> burgers);
  void undeleteBurgers(List<Burger__c> burgers);
}
```

```apex
/**
 * Implementation of {@link BurgerRepository}.
 */
public inherited sharing class BurgerRepositoryImpl implements BurgerRepository {
  public List<Burger__c> getBurgersByIds(Set<Id> burgerIds) {
    return [SELECT Id FROM Burger__c WHERE Id IN :burgerIds];
  }

  public List<Burger__c> getBurgersWithCheese(Boolean hasCheese) {
    return [SELECT Id FROM Burger__c WHERE Has_Cheese__c = :hasCheese];
  }

  public void insertBurgers(List<Burger__c> burgers) {
    insert burgers;
  }

  public void updateBurgers(List<Burger__c> burgers) {
    update burgers;
  }

  public void upsertBurgers(List<Burger__c> burgers) {
    upsert burgers;
  }

  public void deleteBurgers(List<Burger__c> burgers) {
    delete burgers;
  }

  public void undeleteBurgers(List<Burger__c> burgers) {
    undelete burgers;
  }
}
```

Write an Apex Class that implements this Interface:

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

`UntappdBrewery`, `UntappdBeer` and `UntappdCheckIn` classes all have a
`toSObject()` method. Use this to convert the object into an SObject before
performing DML. All of the SObjects have an External Id field named
`Untappd_Id__c`. Perform DML and then return the SObjects in 2 statements.
