FROM alpine:3.6

RUN apk add --update \
  bash \
  curl \
  git \
  build-base \
  perl-dev \
  ncurses-dev \
  ca-certificates \
  openssl-dev \
  python \
  linux-headers

RUN git clone --depth 1 https://github.com/asdf-vm/asdf.git --branch v0.4.0 /asdf/.asdf
ADD asdf-pre /asdf/.asdf/bin/asdf-pre
ENV PATH="${PATH}:/asdf/.asdf/shims:/asdf/.asdf/bin"
