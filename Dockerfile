FROM alpine:3.12 AS patched

RUN apk upgrade --no-cache

FROM patched AS builder

ARG SHELLCHECK_VERSION=v0.9.0

# Pipefail handled via the exit
# hadolint ignore=DL4006
RUN arch="$(uname -m)" \
  && url_base='https://github.com/koalaman/shellcheck/releases/download/' \
  && tar_file="${SHELLCHECK_VERSION}/shellcheck-${SHELLCHECK_VERSION}.linux.${arch}.tar.xz" \
  && { wget -q "${url_base}${tar_file}" -O - | tar xJf -; } || exit 1 \
  && mv "shellcheck-${SHELLCHECK_VERSION}/shellcheck" /bin/ \
  && rm -rf "shellcheck-${SHELLCHECK_VERSION}"

FROM patched

COPY --from=builder /bin/shellcheck /bin/shellcheck

RUN apk add --no-cache bash~=5.0 make~=4.3

LABEL base.image="alpine:3.12" \
  repostory.name="ci-shellcheck-task"

ENTRYPOINT [ "/bin/bash" ]
