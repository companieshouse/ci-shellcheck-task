FROM 416670754337.dkr.ecr.eu-west-2.amazonaws.com/ci-base-build:1.0.0 AS patched

RUN dnf upgrade -y \
  && dnf update

FROM patched AS builder

ARG SHELLCHECK_VERSION=v0.9.0

# Pipefail handled via the exit
# hadolint ignore=DL4006
RUN arch="$(uname -m)" \
  && dnf install -y tar-2:1.34 xz-5.2.5 \
  && url_base='https://github.com/koalaman/shellcheck/releases/download/' \
  && tar_file="${SHELLCHECK_VERSION}/shellcheck-${SHELLCHECK_VERSION}.linux.${arch}.tar.xz" \
  && { wget -q "${url_base}${tar_file}" -O - | tar xJf -; } || exit 1 \
  && mv "shellcheck-${SHELLCHECK_VERSION}/shellcheck" /bin/ \
  && rm -rf "shellcheck-${SHELLCHECK_VERSION}"

FROM patched

COPY --from=builder /bin/shellcheck /bin/shellcheck

RUN dnf install -y bash-5.2.15 make-4.3 findutils-1:4.8.0 file-5.39 && dnf clean all

LABEL base.image="alpine:3.12" \
  repostory.name="ci-shellcheck-task"

ENTRYPOINT [ "/bin/bash" ]
