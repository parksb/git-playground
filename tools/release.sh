#!/bin/bash

SEMVER=$1
PREFIX=$(git show --pretty=format:%s -s origin/master | egrep -o '^[a-z]*:')

if [[ -z "$SEMVER" ]]; then
  if [[ $PREFIX == "patch:" ]] || [[ $PREFIX == "minor:" ]] || [[ $PREFIX == "major:" ]]; then
    SEMVER=$(echo $PREFIX | sed 's/.\{1\}$//')
  else
    exit 2
  fi
elif [[ $SEMVER != "patch" ]] && [[ $SEMVER != "minor" ]] && [[ $SEMVER != "major" ]]; then
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

mkdir dist
echo "dist" > dist/file.dist

sed -i "" "/dist/d" ./.gitignore

git add .
git commit -m "dist: $(date +'%Y-%m-%d %H:%M:%S')"

npm version $SEMVER
git push --tags

git restore ./.gitignore
git switch master
