# AI vs Developer

Example project that was presented at [Forcelandia](https://forcelandia.com/)
2024
([slides](https://docs.google.com/presentation/d/1ixLbpmlmjEViQk-yFNO48o-neB7WEQt3iKf0yqnT5GY/edit?usp=sharing)).

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
org_alias="forcelandia-ai-vs-dev--scratch"

sf org create scratch \
  --alias="${org_alias}" \
  --definition-file=config/project-scratch-def.json \
  --duration-days=30 \
  --set-default

sf project deploy start \
  --source-dir=force-app \
  --wait=10 \
  --ignore-conflicts \
  --verbose
```

### Run all tests

```shell
org_alias="forcelandia-ai-vs-dev--scratch"

sf apex test run \
  --target-org="${org_alias}" \
  --wait=10 \
  --code-coverage
```
