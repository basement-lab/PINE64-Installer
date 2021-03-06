#!/bin/bash

###
# Copyright 2016 resin.io
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###

# See http://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -u
set -e

./scripts/build/check-dependency.sh aws

function usage() {
  echo "Usage: $0"
  echo ""
  echo "Options"
  echo ""
  echo "    -f <file>"
  echo "    -b <s3 bucket>"
  echo "    -v <version>"
  echo "    -p <product name>"
  exit 1
}

ARGV_FILE=""
ARGV_BUCKET=""
ARGV_VERSION=""
ARGV_PRODUCT_NAME=""

while getopts ":f:b:v:p:" option; do
  case $option in
    f) ARGV_FILE="$OPTARG" ;;
    b) ARGV_BUCKET="$OPTARG" ;;
    v) ARGV_VERSION="$OPTARG" ;;
    p) ARGV_PRODUCT_NAME="$OPTARG" ;;
    *) usage ;;
  esac
done

if [ -z "$ARGV_FILE" ] || \
   [ -z "$ARGV_BUCKET" ] || \
   [ -z "$ARGV_VERSION" ] || \
   [ -z "$ARGV_PRODUCT_NAME" ]
then
  usage
fi

FILENAME=$(basename "$ARGV_FILE")

aws s3api put-object \
  --bucket "$ARGV_BUCKET" \
  --acl public-read \
  --key "$ARGV_PRODUCT_NAME/$ARGV_VERSION/$FILENAME" \
  --body "$ARGV_FILE"
