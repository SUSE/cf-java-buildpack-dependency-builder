#!/bin/bash

# Setup .oscrc
sed -i "s|<username>|$OBS_USERNAME|g" /root/.oscrc
sed -i "s|<password>|$OBS_PASSWORD|g" /root/.oscrc

regex="(.*)(\.tar\..*|\.[tj]ar|\.zip|\.so)$"
file_name=`ls source-artifacts -1 | head -n1`
if [[ $file_name =~ $regex ]]; then
  package_name=${BASH_REMATCH[1]}
fi

if [ -z "$package_name" ]; then
  echo "No sources found."
  exit 1
fi

package=java-buildpack-binary-$package_name

# Set up osc working directory
osc co -M $PROJECT

# Create package if it doesn't exist yet
pushd $PROJECT
osc mkpac $package
popd

# Add source artifacts
pushd $PROJECT/$package/
ln -s ../../source-artifacts/* .
osc addremove
osc ci -m "Upload sources from latest build"

# Trigger legaldb
curl -X POST http://legaldb.suse.de/packages -d api=https://api.opensuse.org/ -d project=$PROJECT -d package=$package -d external_link=SCF -d priority=1
