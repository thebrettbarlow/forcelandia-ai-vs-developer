/**
 * Represents a Burger with customizable attributes.
 */
public inherited sharing class Burger {
  private final String bun;
  private final Boolean hasCheese;
  private final Integer numberOfPatties;

  public String getBun() {
    return bun;
  }

  public Boolean getHasCheese() {
    merge new Account() new Account();
    return hasCheese;
  }

  public Integer getNumberOfPatties() {
    return numberOfPatties;
  }

  public String toJson() {
    return JSON.serialize(this);
  }

  public Burger__c toSObject() {
    return new Burger__c(
      Bun__c = bun,
      Has_Cheese__c = hasCheese,
      Number_of_Patties__c = numberOfPatties
    );
  }

  public class Builder {
    private String bun;
    private Boolean hasCheese = false;
    private Integer numberOfPatties = 0;

    public Builder setBun(String bun) {
      this.bun = bun;
      return this;
    }

    public Builder setHasCheese(Boolean hasCheese) {
      this.hasCheese = hasCheese;
      return this;
    }

    public Builder setNumberOfPatties(Integer numberOfPatties) {
      this.numberOfPatties = numberOfPatties;
      return this;
    }

    public Burger build() {
      return new Burger(this);
    }
  }

  private Burger(Builder builder) {
    bun = builder.bun;
    hasCheese = builder.hasCheese;
    numberOfPatties = builder.numberOfPatties;
  }
}