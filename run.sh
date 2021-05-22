#!/usr/bin/env bash


# See https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -euxo pipefail


sudo rm --force --recursive .git
git init

git config user.email "you@example.com"
git config user.name "Your Name"

git add .

git commit --message 'Save flake state'


nix build .#yocto

sudo rm --force --recursive .git
