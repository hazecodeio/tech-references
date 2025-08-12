#!/bin/bash

#Bash Strict Mode
set -euo pipefail

function funinit() {
  local CWD=$(echo $(realpath $0) | xargs dirname)
  #echo "${CWD}"

  #find ~/dev/api-calls-sandbox -type f -regex '.*.properties'| xargs cat
  eval export "$(find "${CWD}" -type f -regextype posix-extended -regex "^(../|./|/).*(_env-)*.properties$" | xargs cat)"
}

funinit