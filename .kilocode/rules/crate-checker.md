# Rule: Rust Crate Checker

When adding or updating `Cargo.toml` dependencies, it's important to ensure that the latest version of the crate is used.

This rule ensures no hardcoded crate names or versions when checking for the latest version of a dependency. 

Always fetch versions dynamically from crates.io.

### Basic Command

Use this command to get the latest version of any crate:

replace CRATE_NAME with the name of the crate you want to check.

```bash
CRATE_NAME="sha2"
curl -s "https://crates.io/api/v1/crates/$CRATE_NAME/versions" \
  | grep -o '"num":"[^"]*"' \
  | grep -E '^"num":"[0-9]+\.[0-9]+\.[0-9]+"' \
  | head -1 \
  | cut -d'"' -f4
```

IMPORTANT: Use the output of this command to update your dependencies in your project.