/**
 * Represents an Untappd beer with mapping to Beer__c object.
 */
public class UntappdBeer {
  private final Long id;
  private final Long breweryId;
  private final String name;
  private final String style;
  private final Decimal abv;

  public Long getId() {
    return id;
  }

  public Long getBreweryId() {
    return breweryId;
  }

  public String getName() {
    return name;
  }

  public String getStyle() {
    return style;
  }

  public Decimal getAbv() {
    return abv;
  }

  public Builder toBuilder() {
    return new Builder(this);
  }

  public String toJson() {
    return JSON.serialize(this);
  }

  public Beer__c toSObject() {
    Account brewery = new Account(Untappd_Id__c = breweryId.toString());
    return new Beer__c(
      Untappd_Id__c = id.toString(),
      Name = name,
      Style__c = style,
      ABV__c = abv,
      Brewery__r = brewery
    );
  }

  public static Builder newBuilder() {
    return new Builder();
  }

  public class Builder {
    private Long id;
    private Long breweryId;
    private String name;
    private String style;
    private Decimal abv = 0.0;

    public Builder setId(Long id) {
      this.id = id;
      return this;
    }

    public Builder setBreweryId(Long breweryId) {
      this.breweryId = breweryId;
      return this;
    }

    public Builder setName(String name) {
      this.name = name;
      return this;
    }

    public Builder setStyle(String style) {
      this.style = style;
      return this;
    }

    public Builder setAbv(Decimal abv) {
      this.abv = abv;
      return this;
    }

    public UntappdBeer build() {
      return new UntappdBeer(this);
    }

    private Builder() {
    }

    private Builder(UntappdBeer beer) {
      id = beer.id;
      breweryId = beer.breweryId;
      name = beer.name;
      style = beer.style;
      abv = beer.abv;
    }
  }

  private UntappdBeer(Builder builder) {
    id = builder.id;
    breweryId = builder.breweryId;
    name = builder.name;
    style = builder.style;
    abv = builder.abv;
  }
}