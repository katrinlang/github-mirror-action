#! /bin/sh -l

REMOTE="${1}"

if [ -z "${REMOTE}" ]; then
  echo Please specify an origin
  exit 1
fi

git config --global --add safe.directory /github/workspace

git clone --recurse-submodules --bare "https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git" . || exit 1
git remote add --mirror=fetch mirror "${REMOTE}" || exit 1
git submodule update --init --recursive
git fetch --recurse-submodules=yes mirror +refs/heads/*:refs/remotes/origin/* || exit 1
git push --force --mirror --prune origin || exit 1
