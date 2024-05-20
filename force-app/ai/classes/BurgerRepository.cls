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