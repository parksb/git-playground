#!/bin/bash

SEMVER=$1

if [ $SEMVER ] && [[ $SEMVER != "patch" ]] && [[ $SEMVER != "minor" ]] && [[ $SEMVER != "major" ]]; then
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

mkdir dist
echo "dist" > dist/file.dist

if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' '/dist/d' ./.gitignore
else
  sed -i '/dist/d' ./.gitignore
fi

git add .
git commit -m "dist: $(date +'%Y-%m-%d %H:%M:%S')"

VERSION=$(awk '/version/{gsub(/("|",)/,"",$2);print $2};' package.json)
git tag v$VERSION
git push origin --tags

git restore ./.gitignore
git switch master
