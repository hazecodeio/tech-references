#!/bin/bash

#Bash Strict Mode
set -euo pipefail

function funcinit() {
  local CWD=$(echo $(realpath "${0}") | xargs dirname)
  #echo "${CWD}"

  #find ~/dev/api-calls-sandbox -type f -regex '.*.properties'| xargs cat
  export "$(find "${CWD}" -type f -regextype posix-extended -iregex "^(../|./|/).*(_env-)*.properties$" | xargs cat)"
}

funcinit