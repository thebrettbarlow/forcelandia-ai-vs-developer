/**
 * Wrapper around the Burger API.
 */
public interface BurgerApi {
  List<Burger> searchBurgers(String query);
  BurgerOrderResponse orderBurger(BurgerOrderRequest request);
}