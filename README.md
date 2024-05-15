# AI vs Developer

Example project that was presented at [Forcelandia](https://forcelandia.com/)
2024
([slides](https://docs.google.com/presentation/d/1ixLbpmlmjEViQk-yFNO48o-neB7WEQt3iKf0yqnT5GY/edit?usp=sharing)).

---

TODO: add a description here

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
