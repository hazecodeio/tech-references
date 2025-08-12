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


#  ip link delete vopono01_d
#  nmcli connection reload
#
#  iptables -t nat -D POSTROUTING -s 10.200.1.0/24 -o proton0 -j MASQUERADE
#
#  iptables -D FORWARD -o vopono01_d -i proton0 -j ACCEPT
#  iptables -D FORWARD -i vopono01_d -o proton0 -j ACCEPT
#  ip netns delete vopono01


}

funinit