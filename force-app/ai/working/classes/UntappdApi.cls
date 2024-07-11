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
  Map<Long, String> searchBreweries(String query);

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