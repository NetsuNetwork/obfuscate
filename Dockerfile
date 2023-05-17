FROM elixir:alpine

WORKDIR /app/obfuscate

COPY ./mix* .

ENV MIX_ENV='prod'

RUN apk update && apk add git openssl

RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get && mix deps.compile

COPY lib .
COPY native .
COPY config .

EXPOSE 5488

RUN mix compile 
