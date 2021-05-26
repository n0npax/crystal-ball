#!/usr/bin/env sh
set -x
ID=$1
ORG=$2
REPO=$3
/app/bin/crystal-ball.exe check -n "${ID}" -o "${ORG}" -r "${REPO}"
echo "::set-output name=fortuneTeller::$fortuneTeller"