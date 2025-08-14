#!/bin/bash

CWD=$(echo $(realpath "${0}") | xargs dirname)
#echo "${CWD}"

source "${CWD}"/_env-loader.sh

find ../ -type f -regextype posix-extended \
    \(        -iregex "^(../|./|/).*(_env-).*.properties$" \
        -or   -iregex "^(../|./|/).*(\.rsync).*" \) \
    \(  -not  -iregex ".*.gpg$" \
        -not  -iregex ".*etc.*" \) \
  | xargs -i gpg -v --passphrase $GPG_PASSPHRASE --batch --yes -o {}.gpg -c {}