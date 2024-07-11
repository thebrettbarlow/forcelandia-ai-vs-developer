/**
 * Represents an Untappd brewery with mapping to Account object.
 */
public class UntappdBrewery {
  private final Long id;
  private final String name;
  private final String description;
  private final String website;
  private final String street;
  private final String city;
  private final String state;
  private final List<UntappdBeer> beers;

  public Long getId() {
    return id;
  }

  public String getName() {
    return name;
  }

  public String getDescription() {
    return description;
  }

  public String getWebsite() {
    return website;
  }

  public String getStreet() {
    return street;
  }

  public String getCity() {
    return city;
  }

  public String getState() {
    return state;
  }

  public List<UntappdBeer> getBeers() {
    return beers;
  }

  public Builder toBuilder() {
    return new Builder(this);
  }

  public String toJson() {
    return JSON.serialize(this);
  }

  public Account toSObject() {
    return new Account(
      Untappd_Id__c = String.valueOf(id),
      Name = name,
      Website = website,
      BillingStreet = street != null ? street : '',
      BillingCity = city != null ? city : '',
      BillingState = state != null ? state : '',
      Description = description != null ? description : ''
    );
  }

  public static Builder newBuilder() {
    return new Builder();
  }

  public class Builder {
    private Long id;
    private String name;
    private String description;
    private String website;
    private String street;
    private String city;
    private String state;
    private List<UntappdBeer> beers = new List<UntappdBeer>();

    public Builder setId(Long id) {
      this.id = id;
      return this;
    }

    public Builder setName(String name) {
      this.name = name;
      return this;
    }

    public Builder setDescription(String description) {
      this.description = description;
      return this;
    }

    public Builder setWebsite(String website) {
      this.website = website;
      return this;
    }

    public Builder setStreet(String street) {
      this.street = street;
      return this;
    }

    public Builder setCity(String city) {
      this.city = city;
      return this;
    }

    public Builder setState(String state) {
      this.state = state;
      return this;
    }

    public Builder addBeer(UntappdBeer beer) {
      this.beers.add(beer);
      return this;
    }

    public Builder setBeers(List<UntappdBeer> beers) {
      this.beers = beers;
      return this;
    }

    public UntappdBrewery build() {
      return new UntappdBrewery(this);
    }

    private Builder() {
    }

    private Builder(UntappdBrewery brewery) {
      id = brewery.id;
      name = brewery.name;
      description = brewery.description;
      website = brewery.website;
      street = brewery.street;
      city = brewery.city;
      state = brewery.state;
      beers = new List<UntappdBeer>(brewery.beers);
    }
  }

  private UntappdBrewery(Builder builder) {
    id = builder.id;
    name = builder.name;
    description = builder.description;
    website = builder.website;
    street = builder.street;
    city = builder.city;
    state = builder.state;
    beers = new List<UntappdBeer>(builder.beers);
  }
}