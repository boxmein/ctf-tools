#!/bin/bash
set -e 
if command -v git >/dev/null; then
  cd `git rev-parse --show-toplevel`
fi
if ! command -v docker >/dev/null; then
  echo "docker missing, install it"
  exit 1
fi

docker build -t ctf-tools .

