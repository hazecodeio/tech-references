#!/bin/bash

CWD=$(echo $(realpath "${0}") | xargs dirname)
#echo "${CWD}"

source "${CWD}"/_env-loader.sh

# ToDo - move pattern matching to separate files `.gpgrule`
#        Follow similar concept to `.gitignore`
#        `.gpgrule` in subdirectories override parent's

find ../ -type f -regextype posix-extended \
  -iregex "^(../|./|/).*.gpg$" \
  -not -iregex ".*etc.*" \
  | grep -o '.*[^.gpg]' \
  | xargs -i gpg -v --passphrase $GPG_PASSPHRASE --yes --batch -o {} -d {}.gpg