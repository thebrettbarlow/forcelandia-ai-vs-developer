# AI vs Developer

Example project that was presented at [Forcelandia](https://forcelandia.com/)
2024
([slides](https://docs.google.com/presentation/d/1svI3bp4-2TtruKcXtuZKcR5X97Yo9yOAKuB1mu7Ygyk/edit?usp=sharing)).

---

In the ultimate showdown of man vs machine, Chuck Liddell takes on AI in a
coding challenge. The task is to build an integration between Salesforce and the
Untappd API.

During the session, we will use AI to generate code to solve the problem. We'll
then compare it to the code written by the human developer.

We hope to show some practical ways of using AI for coding tasks. We'll also
talk about how to break down a problem into smaller steps and how this can help
you create a more robust solution (whether you code it yourself or AI does it
for you).

## Coding Challenge

Retrieve and store Untappd check-in data for Deschutes Brewery.

- Each check-in should be related to the Deschutes Brewery `Account` record
- Each beer should be stored as its own `Beer__c` record
  - Include the following: Name, Style, ABV
- Each check-in should be stored as its own `Check_In__c` record
  - Include the following: Rating, Comment, Date, Number of Toasts, Number of
    Comments

Notes about schema:

- `Account` is a parent of `Beer__c` using a master-detail relationship
- `Beer__c` is a parent of `Check_In__c` using a master-detail relationship
- We have created rollup summary fields on `Account` and `Beer__c` to summarize
  check-in data

## Development

### Connect to the Dev Hub

```shell
org_alias="forcelandia-ai-vs-dev"

sf org login web \
  --alias="${org_alias}" \
  --set-default-dev-hub
```

### Make a scratch org

```shell
./scripts/create_org
```

### Retrieve non-code metadata

This is useful for getting metadata during the development process.

```shell
target_org="forcelandia-ai-vs-dev--scratch"

sf project retrieve start \
  --target-org="${target_org}" \
  --metadata=CustomApplication:standard__LightningSales \
  --metadata=PermissionSet:Forcelandia_AI_vs_Dev \
  --metadata=CustomObject:Account \
  --metadata=CustomObject:Beer__c \
  --metadata=CustomObject:Check_In__c \
  --metadata=CustomObject:Untappd_API_Configuration__mdt \
  --metadata="Layout:Account-Account Layout" \
  --metadata="Layout:Beer__c-Beer Layout" \
  --metadata="Layout:Check_In__c-Check-In Layout" \
  --metadata="Layout:Untappd_API_Configuration__mdt-Untappd API Configuration Layout" \
  --metadata=Flexipage:Account_Record_Page \
  --metadata=Flexipage:Beer_Record_Page \
  --metadata=Flexipage:Check_In_Record_Page \
  --metadata=RemoteSiteSetting:Untappd_API
```
