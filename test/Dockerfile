FROM teamon/alpine-asdf-pre:3.6

RUN mkdir /app
WORKDIR /app
ADD .tool-version .
RUN asdf-pre install
