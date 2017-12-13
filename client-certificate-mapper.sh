#!/usr/bin/env bash

set -e -u -o pipefail

source $(dirname "$0")/common.sh

# VersionResolver expects versions like X.Y.0_RELEASE and complains about X.Y.0.RELEASE
# The `sed` below is a workaround to hide the warning but needs more investigation
# on why this is needed.
VERSION=$(cat client-certificate-mapper-archives/version | sed -re 's/\.([A-Z]+$)/_\1/g')

INDEX_PATH="/client-certificate-mapper/index.yml"
UPLOAD_PATH="/client-certificate-mapper/client-certificate-mapper-$VERSION.jar"

transfer_to_s3 "client-certificate-mapper-archives/java-buildpack-client-certificate-mapper-*.jar" $UPLOAD_PATH
update_index $INDEX_PATH $VERSION $UPLOAD_PATH
invalidate_cache $INDEX_PATH $UPLOAD_PATH
