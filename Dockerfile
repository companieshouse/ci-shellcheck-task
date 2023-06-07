FROM alpine:3.12 AS patched

RUN apk upgrade --no-cache
FROM patched AS builder

ARG SHELLCHECK_VERSION=v0.9.0

RUN arch="$(uname -m)" \
  && url_base='https://github.com/koalaman/shellcheck/releases/download/' \
  && tar_file="${tag}/shellcheck-${tag}.linux.${arch}.tar.xz" \
  && wget "${url_base}${tar_file}" -O - | tar xJf - \
  && mv "shellcheck-${tag}/shellcheck" /bin/ \
  && rm -rf "shellcheck-${tag}"

FROM patched

COPY --from=builder /bin/shellcheck /bin/shellcheck

RUN apk add --no-cache bash make

LABEL BASE_IMAGE="alpine:3.12"
LABEL SHELLCHECK_VERSION="${SHELLCHECK_VERSION}"
LABEL REPOSITORY="ci-shellcheck-task"

ENTRYPOINT [ "/bin/bash" ]
