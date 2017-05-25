#!/usr/bin/env bash

set -e -o pipefail

source $(dirname "$0")/common.sh

VERSION=$(cat redis-store-archives/version)

INDEX_PATH="/redis-store/index.yml"
UPLOAD_PATH="/redis-store/redis-store-$VERSION.jar"

# The public archive contains a sources JAR file, remove it so it doesn't get
# included in the call to transfer_to_s3.
rm -f redis-store-archives/redis-store-*sources.jar

transfer_to_s3 "redis-store-archives/redis-store-*.jar" $UPLOAD_PATH
update_index $INDEX_PATH $VERSION $UPLOAD_PATH
invalidate_cache $INDEX_PATH $UPLOAD_PATH
