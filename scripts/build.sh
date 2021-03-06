#!/usr/bin/env bash

# Available environment variables
#
# BUILD_OPTS
# REPOSITORY
# SOURCE_REPOSITORY
# SOURCE_REGISTRY
# VERSION

# Set default values

BUILD_OPTS=${BUILD_OPTS:-}
CREATED=$(date --rfc-3339=ns)
SOURCE_REGISTRY=${SOURCE_REGISTRY:-quay.io}
SOURCE_REPOSITORY=${SOURCE_REPOSITORY:-osism/horizon}
REVISION=$(git rev-parse --short HEAD)
VERSION=${VERSION:-latest}

# source: https://stackoverflow.com/questions/32113330/check-if-imagetag-combination-already-exists-on-docker-hub
function docker_tag_exists() {
    TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'${TRAVIS_DOCKER_USERNAME}'", "password": "'${TRAVIS_DOCKER_PASSWORD}'"}' https://hub.docker.com/v2/users/login/ | jq -r .token)
    EXISTS=$(curl -s -H "Authorization: JWT ${TOKEN}" https://hub.docker.com/v2/repositories/$1/tags/?page_size=10000 | jq -r "[.results | .[] | .name == \"$2\"] | any")
    test $EXISTS == true
}

if docker_tag_exists $REPOSITORY $VERSION; then
    NOBUILD=1
fi

if [[ -z $NOBUILD || $SOURCE_REGISTRY == "quay.io" ]]; then
    docker build \
        --build-arg "SOURCE=$SOURCE_REGISTRY/$SOURCE_REPOSITORY" \
        --build-arg "VERSION=$VERSION" \
        --label "org.opencontainers.image.created=$CREATED" \
        --label "org.opencontainers.image.revision=$REVISION" \
        --label "org.opencontainers.image.version=$VERSION" \
        --tag "$REPOSITORY:$VERSION" \
        --squash \
        $BUILD_OPTS .
else
    echo "The image $REPOSITORY:$VERSION already exists and source is not Quay. Skipping build."
fi
