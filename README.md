# ci-shellcheck-task

This repository contains a Docker image that can be used to run
[ShellCheck](https://www.shellcheck.net/). The image is based on `alpine:3.12`.

## Build Args

* `SHELLCHECK_VERSION` - The version of ShellCheck to install. Defaults to `0.9.0`.

## Entrypoint

The entrypoint is set to `/bin/bash`.
