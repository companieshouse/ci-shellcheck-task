# ci-shellcheck-task

This repository contains a minimal Docker image that can be used to run
[ShellCheck](https://www.shellcheck.net/). The image is based on `alpine:3.12`.

## Build Args

* `SHELLCHECK_VERSION` - The version of ShellCheck to install. Defaults to `0.9.0`.

## Entrypoint

The entrypoint is set to `/bin/bash`.

## /opt/ci-shellcheck-task/bin/run

This script will run shellcheck against all shell files (bash and posix shell
scripts) within the repository.

### Usage

The following snippet runs shellcheck against all shell files within the local
directory `./source-code` (much like in a CI environment.)

```sh
/opt/ci-shellcheck-task/bin/run ./source-code
```
