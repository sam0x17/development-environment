#!/bin/bash
if ! [ -x "$(command -v docker)" ]; then
  echo 'error: docker is not installed.' >&2
  exit 1
fi
if ! [ -x "$(command -v git)" ]; then
  echo 'error: git is not installed.' >&2
  exit 1
fi
if test -f "~/.ssh"; then
  echo "error: ssh keys have not been set up (looked in ~/.ssh)" >&2
  exit 1
else
  echo "found ssh keys in ~/.ssh"
fi
if test -f "~/.s3cfg"; then
  echo "error: s3cmd configuration is not present (looked for ~/.s3cfg)" >&2
  exit 1
else
  echo "found s3cmd configuration in ~/.s3cfg"
fi
GIT_USER_NAME=$(git config --global user.name)
GIT_USER_EMAIL=$(git config --global user.email)
SYSTEM_USER_NAME=$(whoami)
echo "git user display name: $GIT_USER_NAME"
echo "git user email: $GIT_USER_EMAIL"
echo "system username: $SYSTEM_USER_NAME"
cp -r ~/.ssh . || exit 1
cp ~/.s3cfg . || exit 1
mkdir -p ~/workspace || exit 1
docker build -t dev-environment:latest . \
--build-arg SYSTEM_USER_NAME=$SYSTEM_USER_NAME \
--build-arg GIT_USER_EMAIL="$GIT_USER_EMAIL" \
--build-arg GIT_USER_NAME="$GIT_USER_NAME"
