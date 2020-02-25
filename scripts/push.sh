#!/usr/bin/env bash

# Available environment variables
#
# REPOSITORY
# SOURCE_REPOSITORY
# VERSION

SOURCE_REGISTRY=${SOURCE_REGISTRY:-quay.io}
VERSION=${VERSION:-latest}

# source: https://stackoverflow.com/questions/32113330/check-if-imagetag-combination-already-exists-on-docker-hub
function docker_tag_exists() {
    TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'${TRAVIS_DOCKER_USERNAME}'", "password": "'${TRAVIS_DOCKER_PASSWORD}'"}' https://hub.docker.com/v2/users/login/ | jq -r .token)
    EXISTS=$(curl -s -H "Authorization: JWT ${TOKEN}" https://hub.docker.com/v2/repositories/$1/tags/?page_size=10000 | jq -r "[.results | .[] | .name == \"$2\"] | any")
    test $EXISTS == true
}

if docker_tag_exists $REPOSITORY $VERSION; then
    NOPUSH=1
fi

if [[ -z $NOPUSH || $SOURCE_REGISTRY == "quay.io" ]]; then
    docker push "$REPOSITORY:$VERSION"
    docker rmi "$REPOSITORY:$VERSION"
else
    echo "The image $REPOSITORY:$VERSION already exists and source is not Quay. Skipping push."
fi
