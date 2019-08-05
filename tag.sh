#!/bin/bash
cp -r ~/.ssh . || exit 1
docker build -t dev-environment:latest .
