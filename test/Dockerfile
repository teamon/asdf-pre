FROM teamon/alpine-asdf-pre:3.6

RUN mkdir /app
WORKDIR /app
ADD .tool-versions .
RUN asdf-pre install
