#!/usr/bin/env bash
set -xeuo pipefail

ID=${1}
REPO=${2}
LABELS=${3}
/app/bin/crystal-ball.exe check -n "${ID}" -r "${REPO}" -l "${LABELS}"