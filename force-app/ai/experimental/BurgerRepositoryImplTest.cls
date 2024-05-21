/**
 * Tests for {@link BurgerRepositoryImpl}.
 */
@IsTest(IsParallel=true)
private class BurgerRepositoryImplTest {
  private static final BurgerRepositoryImpl burgerRepository;

  static {
    burgerRepository = new BurgerRepositoryImpl();
  }

  @IsTest
  private static void getBurgersByIds_runsQuery() {
    Set<Id> burgerIds = new Set<Id>();

    burgerRepository.getBurgersByIds(burgerIds);

    Assert.areEqual(1, Limits.getQueries());
  }

  @IsTest
  private static void getBurgersWithCheese_runsQuery() {
    Boolean hasCheese = true;

    burgerRepository.getBurgersWithCheese(hasCheese);

    Assert.areEqual(1, Limits.getQueries());
  }

  @IsTest
  private static void insertBurgers_performsDml() {
    List<Burger__c> burgers = new List<Burger__c>{ new Burger__c() };

    try {
      burgerRepository.insertBurgers(burgers);
    } catch (DmlException e) {
      // Preventing the test from failing due to a DML exception
    }

    Assert.isTrue(Limits.getDmlStatements() > 0, 'Expected a DML statement to be executed');
  }

  @IsTest
  private static void updateBurgers_performsDml() {
    List<Burger__c> burgers = new List<Burger__c>{ new Burger__c() };

    try {
      burgerRepository.updateBurgers(burgers);
    } catch (DmlException e) {
      // Preventing the test from failing due to a DML exception
    }

    Assert.isTrue(Limits.getDmlStatements() > 0, 'Expected a DML statement to be executed');
  }

  @IsTest
  private static void upsertBurgers_performsDml() {
    List<Burger__c> burgers = new List<Burger__c>{ new Burger__c() };

    try {
      burgerRepository.upsertBurgers(burgers);
    } catch (DmlException e) {
      // Preventing the test from failing due to a DML exception
    }

    Assert.isTrue(Limits.getDmlStatements() > 0, 'Expected a DML statement to be executed');
  }

  @IsTest
  private static void deleteBurgers_performsDml() {
    List<Burger__c> burgers = new List<Burger__c>{ new Burger__c() };

    try {
      burgerRepository.deleteBurgers(burgers);
    } catch (DmlException e) {
      // Preventing the test from failing due to a DML exception
    }

    Assert.isTrue(Limits.getDmlStatements() > 0, 'Expected a DML statement to be executed');
  }

  @IsTest
  private static void undeleteBurgers_performsDml() {
    List<Burger__c> burgers = new List<Burger__c>{ new Burger__c() };

    try {
      burgerRepository.undeleteBurgers(burgers);
    } catch (DmlException e) {
      // Preventing the test from failing due to a DML exception
    }

    Assert.isTrue(Limits.getDmlStatements() > 0, 'Expected a DML statement to be executed');
  }
}