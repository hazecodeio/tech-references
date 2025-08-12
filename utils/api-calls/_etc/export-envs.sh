#!/bin/bash

#Bash Strict Mode
set -euo pipefail

function funinit() {
  #find ~/dev/api-calls-sandbox -type f -regex '.*.properties'| xargs cat
  eval export $(find ~/dev/api-calls-sandbox -type f -regex '.*.properties' | xargs cat)
}

funinit