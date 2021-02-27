FROM golang:1.15

WORKDIR /xo-idl

RUN mkdir -p /xo-idl/gen/go
VOLUME /xo-idl/gen/go

COPY protos/ protos/
COPY go.mod go.mod
COPY go.sum go.sum
COPY Makefile Makefile
COPY generate.sh generate.sh

ENTRYPOINT ["bash", "generate.sh"]