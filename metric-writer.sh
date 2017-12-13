#!/usr/bin/env bash

set -e -u -o pipefail

source $(dirname "$0")/common.sh

# VersionResolver expects versions like X.Y.0_RELEASE and complains about X.Y.0.RELEASE
# The `sed` below is a workaround to hide the warning but needs more investigation
# on why this is needed.
VERSION=$(cat metric-writer-archives/version | sed -re 's/\.([A-Z]+$)/_\1/g')

INDEX_PATH="/metric-writer/index.yml"
UPLOAD_PATH="/metric-writer/metric-writer-$VERSION.jar"

transfer_to_s3 "metric-writer-archives/java-buildpack-metric-writer-*.jar" $UPLOAD_PATH
update_index $INDEX_PATH $VERSION $UPLOAD_PATH
invalidate_cache $INDEX_PATH $UPLOAD_PATH
