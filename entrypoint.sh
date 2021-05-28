#!/usr/bin/env sh
set -x

ID=${1}
ORG=${2}
REPO=${3}
LABELS=${4}

/app/bin/crystal-ball.exe check -n "${ID}" -o "${ORG}" -r "${REPO}" $(echo -n "${LABELS}" | xargs -r -d ',' -IITEM echo -n " -l 'ITEM' ")