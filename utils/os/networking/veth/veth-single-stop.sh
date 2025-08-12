#!/bin/bash

#Bash Strict Mode
set -euo pipefail

function funinit() {

  local CWD=$(echo $(realpath $0) | xargs dirname)
  source "${CWD}"/_env-loader.sh

  sudo ip link delete "${LINK}"
  sudo ip netns delete "${NS}"
  sudo nmcli connection reload

  #Appending to existing NetworkManager config file: /etc/NetworkManager/conf.d/unmanaged.conf
}

funinit