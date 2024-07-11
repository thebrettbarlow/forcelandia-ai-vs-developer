/**
 * Represents an Untappd check-in with mapping to Check_In__c object.
 */
public class UntappdCheckIn {
  private final Long id;
  private final Long beerId;
  private final Decimal rating;
  private final String comment;
  private final Datetime dt;
  private final Integer toasts;
  private final Integer comments;

  public Long getId() {
    return id;
  }

  public Long getBeerId() {
    return beerId;
  }

  public Decimal getRating() {
    return rating;
  }

  public String getComment() {
    return comment;
  }

  public Datetime getDt() {
    return dt;
  }

  public Integer getToasts() {
    return toasts;
  }

  public Integer getComments() {
    return comments;
  }

  public Builder toBuilder() {
    return new Builder(this);
  }

  public String toJson() {
    return JSON.serialize(this);
  }

  public Check_In__c toSObject() {
    Beer__c beer = new Beer__c(Untappd_Id__c = beerId.toString());
    return new Check_In__c(
      Untappd_Id__c = id.toString(),
      Date__c = dt,
      Rating__c = rating,
      Comment__c = comment,
      Number_of_Comments__c = comments,
      Number_of_Toasts__c = toasts,
      Beer__r = beer
    );
  }

  public static Builder newBuilder() {
    return new Builder();
  }

  public class Builder {
    private Long id;
    private Long beerId;
    private Decimal rating;
    private String comment;
    private Datetime dt;
    private Integer toasts = 0;
    private Integer comments = 0;

    public Builder setId(Long id) {
      this.id = id;
      return this;
    }

    public Builder setBeerId(Long beerId) {
      this.beerId = beerId;
      return this;
    }

    public Builder setRating(Decimal rating) {
      this.rating = rating;
      return this;
    }

    public Builder setComment(String comment) {
      this.comment = comment;
      return this;
    }

    public Builder setDt(Datetime dt) {
      this.dt = dt;
      return this;
    }

    public Builder setToasts(Integer toasts) {
      this.toasts = toasts;
      return this;
    }

    public Builder setComments(Integer comments) {
      this.comments = comments;
      return this;
    }

    public UntappdCheckIn build() {
      return new UntappdCheckIn(this);
    }

    private Builder() {
    }

    private Builder(UntappdCheckIn checkIn) {
      id = checkIn.id;
      beerId = checkIn.beerId;
      rating = checkIn.rating;
      comment = checkIn.comment;
      dt = checkIn.dt;
      toasts = checkIn.toasts;
      comments = checkIn.comments;
    }
  }

  private UntappdCheckIn(Builder builder) {
    id = builder.id;
    beerId = builder.beerId;
    rating = builder.rating;
    comment = builder.comment;
    dt = builder.dt;
    toasts = builder.toasts;
    comments = builder.comments;
  }
}