#!/usr/bin/env bash
set -xeuo pipefail

ID=${1}
ORG=${2}
REPO=${3}
LABELS=${4}
/app/bin/crystal-ball.exe check -n "${ID}" -o "${ORG}" -r "${REPO}" -l "${LABELS}"