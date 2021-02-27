#!/bin/bash

# docker rm $(docker ps -a -q)
# docker rmi $(docker images -q) -f

docker build -t xo-idl -f Dockerfile .
docker run -v "$(pwd)"/gen/go:/xo-idl/gen/go xo-idl