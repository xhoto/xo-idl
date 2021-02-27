.PHONY: install generate
.DEFAULT_GOAL := generate

PROTOC := $(shell which protoc)
PROTO_FILES := $(shell cd ./protos && find . -mindepth 2 -maxdepth 2 -type f)
UNAME := $(shell uname)
GOPATH := ${GOPATH}

install:
	mkdir -p gen/go
ifeq ($(PROTOC),)
ifeq ($(UNAME),Darwin)
	brew install protobuf
endif
ifeq ($(UNAME), Linux)
	apt-get update && export DEBIAN_FRONTEND=noninteractive \
	&& apt-get -y install --no-install-recommends libprotobuf-dev protobuf-compiler golang-goprotobuf-dev
endif
endif
	go get -u github.com/golang/protobuf/protoc-gen-go
	go install google.golang.org/protobuf/cmd/protoc-gen-go
	go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc
	go get -u github.com/grpc-ecosystem/grpc-gateway@v1.14.6
	go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway
	go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2

generate: $(PROTO_FILES)
$(PROTO_FILES):
	@echo protoc : $@
	@protoc \
    -I $(GOPATH)/src \
    -I $(GOPATH)/pkg/mod/github.com/grpc-ecosystem/grpc-gateway@v1.14.6/third_party/googleapis \
    --proto_path=protos \
    --go_out=gen/go \
    --go_opt=paths=source_relative \
    --go-grpc_out=gen/go \
    --go-grpc_opt=paths=source_relative \
    --plugin=protoc-gen-grpc-gateway=$(GOPATH)/bin/protoc-gen-grpc-gateway\
    --grpc-gateway_opt=logtostderr=true \
    --grpc-gateway_out=gen/go \
    --grpc-gateway_opt=logtostderr=true \
    --grpc-gateway_opt=paths=source_relative \
    $@
