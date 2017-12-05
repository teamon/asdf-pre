# asdf-pre

Speed up [asdf](https://github.com/asdf-vm) installs using precompiled installs.
Made specifically to be used inside docker with alpine images.

## Quick start

1. Create a `.tool-versions` file

```
# .tool-versions
erlang 20.1
elixir 1.5.2-otp-20
nodejs 9.2.0
```

2. In your Dockerfile start with `alpine-asdf-pre` image`

```Dockerfile
# start with fat build image
FROM teamon/alpine-asdf-pre:3.6 as build

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install & cache tool dependencies
ADD .tool-versions ./
RUN asdf-pre install

# install & cache app dependencies
ENV MIX_ENV=prod
COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

ADD package.json package-lock.json ./
RUN npm install

# build release
COPY . .
RUN npm run build
RUN mix phx.digest
RUN mix release --verbose

# remove unnecessary files
RUN rm -rf _build/prod/rel/myapp/releases/*/*.tar.gz



# prepare tiny release image
FROM alpine:3.6
RUN apk add --update bash ca-certificates openssl

RUN mkdir /app && chown -R nobody: /app
WORKDIR /app
USER nobody

COPY --from=build /app/_build/prod/rel/myapp ./

ENV REPLACE_OS_VARS=true
EXPOSE 4000

ENTRYPOINT ["/app/bin/myapp"]
```

## Development

Install dependencies

```bash
brew install awscli
```

Build tool

```bash
TOOL=elixir VERSION=1.5.2-otp-20 make tool
```

Debug build

```bash
make debug
# /root/build.sh TOOL VERSION
bash-4.3# /root/build.sh erlang 18.1
```
