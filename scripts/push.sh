#!/usr/bin/env bash

# Available environment variables
#
# REPOSITORY
# VERSION

docker push "$REPOSITORY:$VERSION"
docker rmi "$REPOSITORY:$VERSION"
