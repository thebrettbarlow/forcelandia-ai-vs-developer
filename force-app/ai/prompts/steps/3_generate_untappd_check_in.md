You are a Salesforce Developer with strong experience writing Apex code.

Your task is to write an Apex Class to represent a data structure. The result
must meet the following requirements:

- Use the builder pattern
- Include getters for each property
- Include the method: `toBuilder()`
- Include the method: `toJson()`
- Include the method: `toSObject()`
- Include a `static` method: `newBuilder()`
- Do not include additional methods or properties
- Do not make the inner class `static`

For example, here is a correctly implemented Apex Class:

```apex
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
    return hasCheese;
  }

  public Integer getNumberOfPatties() {
    return numberOfPatties;
  }

  public Builder toBuilder() {
    return new Builder(this);
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

  public static Burger.Builder newBuilder() {
    return new Builder();
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

    private Builder() {
    }

    private Builder(Burger burger) {
      bun = burger.bun;
      hasCheese = burger.hasCheese;
      numberOfPatties = burger.numberOfPatties;
    }
  }

  private Burger(Builder builder) {
    bun = builder.bun;
    hasCheese = builder.hasCheese;
    numberOfPatties = builder.numberOfPatties;
  }
}
```

Write an Apex Class for this data structure:

```apex
public class UntappdCheckIn {
  private final Long id;
  private final Long beerId;
  private final Decimal rating;
  private final String comment;
  private final Datetime dt;
  private final Integer toasts;
  private final Integer comments;
}
```

The `Builder` should use a default value of `0` for `toasts` and `comments`. An
`UntappdCheckIn` is a `Check_In__c` in Salesforce. When implementing the
`toSObject()` method, return a new `Check_In__c`. When converting
`UntappdCheckIn` to the `Check_In__c` SObject, Map the `dt` field to `Date__c`,
`comments` to `Number_of_Comments__c` and `toasts` to `Number_of_Toasts__c`. The
`Check_In__c` object has an External Id field named `Untappd_Id__c`. Assign the
`String` value of the `id` field to `Untappd_Id__c`. Create a new `Beer__c`
object, assign the String value of `beerId` to the `Untappd_Id__c`field and
assign this to the `Beer__r` field.
