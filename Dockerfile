FROM alpine:3.12 AS builder

ARG tag=v0.9.0

RUN set -x \
  && apk upgrade --no-cache \
  && arch="$(uname -m)" \
  && echo "arch is $arch" \
  && url_base='https://github.com/koalaman/shellcheck/releases/download/' \
  && tar_file="${tag}/shellcheck-${tag}.linux.${arch}.tar.xz" \
  && wget "${url_base}${tar_file}" -O - | tar xJf - \
  && mv "shellcheck-${tag}/shellcheck" /bin/ \
  && rm -rf "shellcheck-${tag}"

FROM alpine:3.12

COPY --from=builder /bin/shellcheck /bin/shellcheck

RUN set -x \
  && apk upgrade --no-cache \
  && apk add --no-cache bash make

LABEL BASE_IMAGE="alpine:3.12"
LABEL SHELLCHECK_VERSION="0.9.0"
LABEL REPOSITORY="ci-shellcheck-task"

ENTRYPOINT [ "/bin/bash" ]
