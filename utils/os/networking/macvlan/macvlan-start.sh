#!/bin/bash

#Bash Strict Mode
set -euo pipefail

function funinit() {

  local CWD="$(echo $(realpath ${0}) | xargs dirname)"
  source "${CWD}"/_env-loader.sh

  sudo ip netns add "${NS}"
  sudo ip link add "${vIF}" link "${IF}" type ipvlan mode l2
  sudo ip link set dev "${vIF}" up
  sudo ip link set "${vIF}" netns "${NS}"


  sudo ip netns exec "${NS}" ip link set lo up
  sudo ip netns exec "${NS}" ip link set "${vIF}" up

  sudo ip netns exec "${NS}" ip addr add "${IP_HOST}" dev "${vIF}"
  sudo ip netns exec "${NS}" ip route add default via "${IP_GW}" dev "${vIF}"

  sudo nmcli connection reload

  #sudo -E ip netns exec "${NS}" sudo -E -u haze bash

}

funinit

