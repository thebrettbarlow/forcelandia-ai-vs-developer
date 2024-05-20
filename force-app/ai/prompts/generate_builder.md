# Generate a Builder Class

The prompt starts below this line.

---

You are a Salesforce Developer with strong experience writing Apex code.

Your task is to write an Apex Class to represent a data structure. The result
must meet the following requirements:

- Use the builder pattern
- Include getters for each property
- Include the method: `toJson()`
- Include the method: `toSObject()`
- Do not include additional methods or properties

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
```

Write an Apex Class for this data structure:

```apex
// TODO: put data structure here
```

Optionally include custom instructions here.

[//]:
  #
  "For example: In this case, an `UntappdBrewery` is an `Account` in Salesforce. When implementing the `toSObject()` method, return a new `Account`. Map the `id` field to the `Untappd_Id__c` field."
