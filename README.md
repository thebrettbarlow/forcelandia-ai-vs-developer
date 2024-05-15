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
