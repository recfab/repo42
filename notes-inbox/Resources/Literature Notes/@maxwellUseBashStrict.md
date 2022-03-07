---
title: Use Bash Strict Mode (Unless You Love Debugging)
authors: Aaron Maxwell
year: 
---

Topic: [[Bash]]

## TL;DR

```bash
#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
```

## Explanation

- `set -e` option - cease execution on first error
- `set -u` option - treat undefined variables as an error
- `set -o pipefail` option - 

## References

* [Original Article](http://redsymbol.net/articles/unofficial-bash-strict-mode/)


