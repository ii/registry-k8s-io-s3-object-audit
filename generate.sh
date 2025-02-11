#!/bin/bash

# generate.sh
# audits and writes the objects

set -x
set -o errexit
set -o nounset
set -o pipefail

REGIONS=(
    ap-northeast-1
    ap-south-1
    ap-southeast-1

    eu-central-1
    eu-west-1

    us-east-1
    us-east-2
    us-west-1
    us-west-2
)

mkdir -p ./data

for REGION in "${REGIONS[@]}"; do
  aws s3api list-objects --bucket "prod-registry-k8s-io-$REGION" --no-sign-request --output json > "./data/bucket-$REGION.json"
done
