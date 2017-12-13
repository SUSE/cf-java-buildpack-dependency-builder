#!/usr/bin/env bash

set -e -u -o pipefail

source $(dirname "$0")/common.sh

# VersionResolver expects versions like X.Y.0_RELEASE and complains about X.Y.0.RELEASE
# The `sed` below is a workaround to hide the warning but needs more investigation
# on why this is needed.
VERSION=$(cat container-security-provider-archives/version | sed -re 's/\.([A-Z]+$)/_\1/g')

INDEX_PATH="/container-security-provider/index.yml"
UPLOAD_PATH="/container-security-provider/container-security-provider-$VERSION.jar"

transfer_to_s3 "container-security-provider-archives/java-buildpack-container-security-provider-*.jar" $UPLOAD_PATH
update_index $INDEX_PATH $VERSION $UPLOAD_PATH
invalidate_cache $INDEX_PATH $UPLOAD_PATH
