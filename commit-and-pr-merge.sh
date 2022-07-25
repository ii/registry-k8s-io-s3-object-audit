#!/bin/bash

# commit-and-pr-merge.sh
# commits and pushes changes if there are any, then creates a PR to merge

set -x
set -o errexit
set -o nounset
set -o pipefail

if git diff-index --name-only --diff-filter=d HEAD | grep --regexp='data/.*[.]json$'; then
    echo changes detected
else
    exit 0
fi
TIMESTAMP="$(git log -n1 --pretty='format:%cd' --date=format:'%Y-%m-%d-%H-%M')"
NEW_BRANCH="audit-update-for-${TIMESTAMP}"
git add ./data/*.json
git branch "${NEW_BRANCH}"
git checkout "${NEW_BRANCH}"
git commit -s -m "update registry.k8s.io objects dump for ${TIMESTAMP}"
git push origin "${NEW_BRANCH}"
gh pr create --title "Update registry.k8s.io objects dump ${TIMESTAMP}" --body "updates to registry.k8s.io objects dump for ${TIMESTAMP}"
gh pr merge --merge --auto "${NEW_BRANCH}"
