#!/bin/bash

#Bash Strict Mode
set -euo pipefail

function funinit() {

  local CWD=$(echo $(realpath $0) | xargs dirname)
  source "${CWD}"/_env-loader.sh

  sudo ip netns delete "${NS}"
  sudo nmcli connection reload

}

funinit