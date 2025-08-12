#!/bin/bash

#Bash Strict Mode
set -euo pipefail

function funinit() {

  local CWD=$(echo $(realpath $0) | xargs dirname)
  source "${CWD}"/_env-loader.sh

  sudo ip link delete "${vIF01}"
  sudo ip link delete "${vIF02}"


  sudo ip netns delete "${NS01}"

  sudo nmcli connection reload


  sudo iptables -v -t nat -F

}

funinit