#!/usr/bin/env bash

# this is used along side github-release. install it via go get github.com/aktau/github-release
VERSION=$1

if [ -z "$VERSION" ]; then
  echo "Missing version"
  exit;
fi

github-release release \
    --user bitslercasino \
    --repo docker-bitcoinsv \
    --tag v$VERSION \
    --name "v$VERSION Stable Release" \
    --description "BitcoinSV"

github-release upload \
    --user bitslercasino \
    --repo docker-bitcoinsv \
    --tag v$VERSION \
    --name "bsv_install.sh" \
    --file bsv_install.sh

github-release upload \
    --user bitslercasino \
    --repo docker-bitcoinsv \
    --tag v$VERSION \
    --name "bsv_utils.sh" \
    --file bsv_utils.sh

sed -i "s/docker-bitcoinsv\/releases\/download\/.*\/bsv_install\.sh/docker-bitcoinsv\/releases\/download\/v$VERSION\/bsv_install\.sh/g" README.md
sed -i "s/docker-bitcoinsv\/releases\/download\/.*\/bsv_utils\.sh/docker-bitcoinsv\/releases\/download\/v$VERSION\/bsv_utils\.sh/g" README.md