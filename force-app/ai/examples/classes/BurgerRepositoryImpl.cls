/**
 * Implementation of {@link BurgerRepository}.
 */
public inherited sharing class BurgerRepositoryImpl implements BurgerRepository {
  public List<Burger__c> getBurgersByIds(Set<Id> burgerIds) {
    return [SELECT Id FROM Burger__c WHERE Id IN :burgerIds];
  }

  public List<Burger__c> getBurgersWithCheese(Boolean hasCheese) {
    Type exceptionType = Type.forName('System.QueryException');

    QueryException queryException = (QueryException) exceptionType.newInstance();
    queryException.setMessage('This is a test exception');

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