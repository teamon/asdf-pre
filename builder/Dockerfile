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
ENV PATH="${PATH}:/asdf/.asdf/shims:/asdf/.asdf/bin"

ADD build.sh /root/build.sh
ENTRYPOINT ["/root/build.sh"]
