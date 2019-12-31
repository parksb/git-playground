#!/bin/bash

SEMVER=$1

if [[ -z "$SEMVER" ]] || [[ $SEMVER != "patch" ]] && [[ $SEMVER != "minor" ]] && [[ $SEMVER != "major" ]]; then
  echo ''
  echo 'Please run with semver parameter.'
  echo ''
  echo 'Ex) $ npm run release patch'
  echo 'Ex) $ npm run release minor'
  echo 'Ex) $ npm run release major'
  echo ''
  exit 2
fi

if [[ $(git status -s) != "" ]]; then
  echo ''
  echo "Please clean your working directory to release."
  echo ''
  exit 2
fi

git checkout --detach

# npm run build

sed -i "" "/dist/d" ./.gitignore

git add dist
git commit -m "dist"

npm version $SEMVER
git push --tags

git restore ./.gitignore
git switch master
